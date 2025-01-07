// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { CafeCosmosTest } from "./util/CafeCosmosTest.sol";
import "forge-std/console.sol";
import { MarketplaceListings, CafeCosmosConfig, LandInfo, MarketplaceNonce } from "../src/codegen/index.sol";
import { LibInventoryManagement } from "../src/libraries/LibInventoryManagement.sol";
import { LibLandManagement } from "../src/libraries/LibLandManagement.sol";


contract MarketplaceSystemTest is CafeCosmosTest {
    
    address public seller = address(0x01);
    address public buyer = address(0x02);

    uint256 public seller_landId;
    uint256 public buyer_landId;

    uint256 public constant ITEM_ID = 1;
    uint256 public constant INITIAL_QUANTITY = 10;
    uint256 public constant PRICE = 100;
    uint256 public constant INITIAL_BALANCE = 1000;

    function setUp() public override {
        super.setUp();
        
        seller_landId = setupPlayer(seller);
        buyer_landId = setupPlayer(buyer);

        // Give seller some items to sell
        LibInventoryManagement.increaseQuantity(seller_landId, ITEM_ID, INITIAL_QUANTITY);

        // Give buyer some tokens to buy with
        // LibLandManagement.increaseLandTokenBalance(buyer_landId, INITIAL_BALANCE);
        softToken.transfer(buyer, INITIAL_BALANCE);

        vm.prank(buyer);
        softToken.approve(worldAddress, INITIAL_BALANCE);
    }

    function test_ListItem() public {
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        
        uint256 listingId = MarketplaceNonce.get();
        assertEq(MarketplaceListings.getOwner(listingId), seller_landId);
        assertEq(MarketplaceListings.getItemId(listingId), ITEM_ID);
        assertEq(MarketplaceListings.getUnitPrice(listingId), PRICE);
        assertEq(MarketplaceListings.getQuantity(listingId), 5);
        
        // Check seller's inventory was decreased
        assertEq(world.itemBalanceOf(seller_landId, ITEM_ID), INITIAL_QUANTITY - 5);
    }

    function test_ListItem_RevertIfInsufficientQuantity() public {
        vm.startPrank(seller);
        vm.expectRevert("Marketplace: insufficient quantity");
        world.listItem(seller_landId, ITEM_ID, PRICE, INITIAL_QUANTITY + 1);
    }

    function test_ListItem_RevertIfZeroPrice() public {
        vm.startPrank(seller);
        vm.expectRevert("Marketplace: price must be greater than 0");
        world.listItem(seller_landId, ITEM_ID, 0, 1);
    }

    function test_BuyItem() public {
        // Setup: List an item first
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        uint256 listingId = MarketplaceNonce.get();
        
        // Buy the item
        vm.startPrank(buyer);
        world.buyItem(buyer_landId, listingId, 2);
        
        // Check buyer received items
        assertEq(world.itemBalanceOf(buyer_landId, ITEM_ID), 2);
        
        // Check buyer's token balance decreased
        assertEq(softToken.balanceOf(buyer), INITIAL_BALANCE - (PRICE * 2));
        
        // Check seller's token balance increased
        assertEq(softToken.balanceOf(seller), PRICE * 2);
        
        // Check listing was updated
        assertEq(MarketplaceListings.getQuantity(listingId), 3);
    }

    function test_BuyItem_CompleteListingRemoval() public {
        // Setup: List an item
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        uint256 listingId = MarketplaceNonce.get();
        
        // Buy entire quantity
        vm.startPrank(buyer);
        world.buyItem(buyer_landId, listingId, 5);
        
        // Check listing was removed
        assertEq(MarketplaceListings.getQuantity(listingId), 0);
        assertEq(MarketplaceListings.getOwner(listingId), 0);
    }

    function test_BuyItem_RevertIfOwnListing() public {
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        uint256 listingId = MarketplaceNonce.get();
        
        vm.expectRevert("Marketplace: cannot buy your own item");
        world.buyItem(seller_landId, listingId, 1);
    }

    function test_BuyItem_RevertIfInsufficientFunds() public {
        // Setup: List an item
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        uint256 listingId = MarketplaceNonce.get();
        vm.stopPrank();
        
        // Drain buyer's balance
        vm.prank(buyer);
        softToken.transfer(address(0xd), INITIAL_BALANCE);
        
        vm.startPrank(buyer);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        world.buyItem(buyer_landId, listingId, 1);
    }

    function test_BuyItem_PartialPurchase() public {
        // Setup: List an item
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        uint256 listingId = MarketplaceNonce.get();
        
        // Try to buy more than available
        vm.startPrank(buyer);
        world.buyItem(buyer_landId, listingId, 10);
        
        // Should only buy available amount
        assertEq(world.itemBalanceOf(buyer_landId, ITEM_ID), 5);
        assertEq(MarketplaceListings.getQuantity(listingId), 0);
    }

    function test_FullMarketplaceFlow() public {
        // 1. Seller lists item
        vm.startPrank(seller);
        world.listItem(seller_landId, ITEM_ID, PRICE, 5);
        uint256 listingId = MarketplaceNonce.get();
        
        // 2. Buyer purchases partial amount
        vm.startPrank(buyer);
        world.buyItem(buyer_landId, listingId, 2);
        
        // 3. Buyer purchases remaining amount
        world.buyItem(buyer_landId, listingId, 3);
        
        // Verify final state
        assertEq(LibInventoryManagement.itemBalanceOf(seller_landId, ITEM_ID), INITIAL_QUANTITY - 5);
        assertEq(LibInventoryManagement.itemBalanceOf(buyer_landId, ITEM_ID), 5);
        assertEq(softToken.balanceOf(buyer), INITIAL_BALANCE - (PRICE * 5));
        assertEq(softToken.balanceOf(seller), PRICE * 5);
        assertEq(MarketplaceListings.getQuantity(listingId), 0);
        assertEq(MarketplaceListings.getOwner(listingId), 0);
    }
}