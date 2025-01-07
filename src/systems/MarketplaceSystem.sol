// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { LandAccessOperator } from "./LandAccessOperator.sol";
import { MarketplaceListings, CafeCosmosConfig, ConfigAddresses, LandInfo, MarketplaceNonce, MarketplaceListingsData, PlayerTotalEarned } from "../codegen/index.sol";
import { LibInventoryManagement } from "../libraries/LibInventoryManagement.sol";
import { LibLandAccess } from "../libraries/LibLandAccess.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IWETH9, IWETH9WithdrawTo } from "../interfaces/IWETH9.sol";
import { MarketPlaceListingDTO } from "../libraries/Types.sol";

contract MarketplaceSystem is System, LandAccessOperator {

    event MarketplaceItemListed(uint256 indexed landId, uint256 listingId, uint256 itemId, uint256 price, uint256 quantity);
    event MarketplaceItemPurchased(uint256 indexed landId, uint256 listingId, uint256 itemId, uint256 price, uint256 quantity);
    event MarketplaceItemCancelled(uint256 indexed landId, uint256 listingId, uint256 itemId, uint256 price, uint256 quantity);

    function listItem(uint256 landId, uint256 itemId, uint256 price, uint256 quantity) public onlyLandOperator(landId) {
        require(LibInventoryManagement.itemBalanceOf(landId, itemId) >= quantity, "Marketplace: insufficient quantity");
        require(price > 0, "Marketplace: price must be greater than 0");
        require(quantity > 0, "Marketplace: listing quantity must be greater than 0");

        uint256 listingId = MarketplaceNonce.getNonce() + 1;
        MarketplaceNonce.setNonce(listingId);
        uint256 totalListings = MarketplaceNonce.getTotalListings();
        MarketplaceNonce.setTotalListings(totalListings + 1);

        MarketplaceListings.set(listingId, landId, itemId, price, quantity, true);
        LibInventoryManagement.decreaseQuantity(landId, itemId, quantity);
        emit MarketplaceItemListed(landId, listingId, itemId, price, quantity);
    }

    function buyItem(uint256 landId, uint256 listingId, uint256 quantity) payable public onlyLandOperator(landId) {
        require(MarketplaceListings.getOwner(listingId) != landId, "Marketplace: cannot buy your own item");
        require(quantity > 0, "Marketplace: purchase quantity must be greater than 0");

        quantity = quantity > MarketplaceListings.getQuantity(listingId) ? MarketplaceListings.getQuantity(listingId) : quantity;

        uint256 itemId = MarketplaceListings.getItemId(listingId);
        uint256 price = MarketplaceListings.getUnitPrice(listingId);
        uint256 totalPrice = price * quantity;

        _completePurchasePayment(MarketplaceListings.getOwner(listingId), landId, totalPrice);

        LibInventoryManagement.increaseQuantity(landId, itemId, quantity);

        uint256 remainingQuantity = MarketplaceListings.getQuantity(listingId) - quantity;
        
        if (remainingQuantity == 0) {
            MarketplaceListings.setExists(listingId, false);
            MarketplaceListings.deleteRecord(listingId);
            uint256 totalListings = MarketplaceNonce.getTotalListings();
            MarketplaceNonce.setTotalListings(totalListings - 1);
        } else {
            MarketplaceListings.setQuantity(listingId, remainingQuantity);
        }

        emit MarketplaceItemPurchased(landId, listingId, itemId, price, quantity);
    }

    function cancelListing(uint256 landId, uint256 listingId) public onlyLandOperator(landId) {
        require(MarketplaceListings.getOwner(listingId) == landId, "Marketplace: cannot cancel another user's listing");

        uint256 itemId = MarketplaceListings.getItemId(listingId);
        uint256 quantity = MarketplaceListings.getQuantity(listingId);
        uint256 price = MarketplaceListings.getUnitPrice(listingId);

        uint256 totalListings = MarketplaceNonce.getTotalListings();
        MarketplaceNonce.setTotalListings(totalListings - 1);

        MarketplaceListings.deleteRecord(listingId);
        LibInventoryManagement.increaseQuantity(landId, itemId, quantity);

        emit MarketplaceItemCancelled(landId, listingId, itemId, price, quantity);
    }

    function editListing(uint256 landId, uint256 listingId, uint256 price, uint256 quantity) public onlyLandOperator(landId) {
        require(MarketplaceListings.getOwner(listingId) == landId, "Marketplace: cannot edit another user's listing");
        require(price > 0, "Marketplace: price must be greater than 0");
        require(quantity > 0, "Marketplace: listing quantity must be greater than 0");

        uint256 itemId = MarketplaceListings.getItemId(listingId);
        uint256 currentQuantity = MarketplaceListings.getQuantity(listingId);
        uint256 currentPrice = MarketplaceListings.getUnitPrice(listingId);

        if (price != currentPrice) {
            MarketplaceListings.setUnitPrice(listingId, price);
        }

        if (quantity != currentQuantity) {
            if (quantity > currentQuantity) {
                uint256 diff = quantity - currentQuantity;
                require(LibInventoryManagement.itemBalanceOf(landId, itemId) >= diff, "Marketplace: insufficient quantity");
                LibInventoryManagement.decreaseQuantity(landId, itemId, diff);
            } else {
                uint256 diff = currentQuantity - quantity;
                LibInventoryManagement.increaseQuantity(landId, itemId, diff);
            }
            MarketplaceListings.setQuantity(listingId, quantity);
        }
    }

    function getListing(uint256 listingId) public view returns (MarketPlaceListingDTO memory marketPlaceListing) {
      
        if(MarketplaceListings.getExists(listingId)) {
            MarketplaceListingsData memory data = MarketplaceListings.get(listingId);
            marketPlaceListing.listingId = listingId;
            marketPlaceListing.owner = data.owner;
            marketPlaceListing.itemId = data.itemId;
            marketPlaceListing.unitPrice = data.unitPrice;
            marketPlaceListing.quantity = data.quantity;
        }
        return marketPlaceListing;
    }

    function getAllListings() public view returns (MarketPlaceListingDTO[] memory marketPlaceListings) {
        uint256 lastListingId = MarketplaceNonce.getNonce();
        uint256 totalListings = MarketplaceNonce.getTotalListings();
        marketPlaceListings = new MarketPlaceListingDTO[](totalListings);
        uint itemCount = 0;
        for (uint256 index = 1; index <= lastListingId; index++) {
            bool exists = MarketplaceListings.getExists(index);
            if(!exists) {
                continue;
            }
            marketPlaceListings[itemCount] = getListing(index);
            itemCount++;
        }
        return marketPlaceListings;
    }

    function _completePurchasePayment(uint landIdOwner, uint landIdBuyer, uint256 totalPrice) private {
         address itemsOwner = LibLandAccess.getLandOwner(landIdOwner); 
         if(msg.value == 0) {
            IERC20(ConfigAddresses.getSoftTokenAddress()).transferFrom(msg.sender, address(this), totalPrice);
            IWETH9WithdrawTo(ConfigAddresses.getSoftTokenAddress()).withdrawTo(itemsOwner, totalPrice);
        } else {
            require(msg.value == totalPrice, "Incorrect payment amount");
            payable(itemsOwner).transfer(msg.value);
        }
        PlayerTotalEarned.setTotalEarned(landIdOwner, PlayerTotalEarned.getTotalEarned(landIdOwner) + totalPrice);
        PlayerTotalEarned.setTotalSpent(landIdBuyer, PlayerTotalEarned.getTotalSpent(landIdBuyer) + totalPrice);  
    }
}
