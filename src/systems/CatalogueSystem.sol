// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import "../interfaces/ICrafting.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {CatalogueItem, CatalogueItemData, LandInfo, ConfigAddresses} from "../codegen/index.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import {LibLandManagement} from "../libraries/LibLandManagement.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {CatalogueItemDTO, CatalogueItemPurchaseDTO} from "../libraries/Types.sol";

contract CatalogueSystem is System, LandAccessOperator, RootAccessOperator {


    function purchaseCatalogueItem(uint256 landId, uint256 itemId, uint256 quantity) public onlyLandOperator(landId) {
        (bool sufficientBalance, uint256 totalCost) = getTotalCostAndSufficientBalanceToPurchaseItem(landId, itemId, quantity);
        require(sufficientBalance, "Catalogue: insufficient balance to purchase item");
        LibInventoryManagement.increaseQuantity(landId, itemId, quantity);
        LibLandManagement.decreaseLandTokenBalance(landId, totalCost);
    }

    function purchaseCatalogueItems(uint landId, CatalogueItemPurchaseDTO[] calldata items) public onlyLandOperator(landId) {
        (bool sufficientBalance, uint256 totalCost) = getTotalCostAndSufficientBalanceToPurchaseItems(landId, items);
        require(sufficientBalance, "Catalogue: insufficient balance to purchase items");
        for (uint256 index = 0; index < items.length; index++) {
            CatalogueItemPurchaseDTO memory item = items[index];
            LibInventoryManagement.increaseQuantity(landId, item.itemId, item.quantity);
        }
        LibLandManagement.decreaseLandTokenBalance(landId, totalCost);
    }

    function getTotalCostAndSufficientBalanceToPurchaseItem(uint256 landId, uint256 itemId, uint256 quantity) public view returns (bool sufficient, uint256 totalCost) {    
        CatalogueItemData memory catalogueItem = CatalogueItem.get(itemId);
        require(catalogueItem.exists, "Catalogue: item does not exist");
        uint256 price = catalogueItem.price;
        totalCost = price * quantity;
        uint256 balance = LibLandManagement.getLandTokenBalance(landId);(landId);
        sufficient = balance >= totalCost;
    }

    function getTotalCostAndSufficientBalanceToPurchaseItems(uint256 landId, CatalogueItemPurchaseDTO[] calldata items) public view returns (bool sufficient, uint256 totalCost) {
        totalCost = getTotalCost(items);
        uint256 balance = LibLandManagement.getLandTokenBalance(landId);
        sufficient = balance >= totalCost;
    }

    function getTotalCost(CatalogueItemPurchaseDTO[] calldata items) public view returns (uint256 totalCost) {
        for (uint256 index = 0; index < items.length; index++) {
            CatalogueItemPurchaseDTO memory item = items[index];
            CatalogueItemData memory catalogueItem = CatalogueItem.get(item.itemId);
            require(catalogueItem.exists, "Catalogue: item does not exist");
            uint256 price = catalogueItem.price;
            totalCost += price * item.quantity;
        }
    }

    function upsertCatalogueItems(CatalogueItemDTO[] calldata items) public onlyOwner {
        for (uint256 index = 0; index < items.length; index++) {
            CatalogueItemDTO memory item = items[index];
            CatalogueItem.set(item.itemId,  item.catalogueId, item.price, item.exists); 
        }
    }
}