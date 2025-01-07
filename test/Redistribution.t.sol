// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CafeCosmosTest} from "./util/CafeCosmosTest.sol";
import {MI} from "./MockItems.sol";
import "forge-std/console.sol";
import {CafeCosmosConfig, LandInfo, ActiveStoves, LandItemCookingState, PlayerTotalEarned} from "../src/codegen/index.sol";
import {TransformationDTO} from "../src/systems/interfaces/ITransformationsSystem.sol";

contract RedistributionTest is CafeCosmosTest {
    
    address public alice = address(0x01);
    address public bob = address(0x02);
    address public claire = address(0x03);

    uint256 public alice_landId;
    uint256 public bob_landId;

    function setUp() public override {
        super.setUp();
        softToken.transfer(address(vesting), 1000e18);

        vm.roll(1e5);
        
        TransformationDTO memory stove_to_cooking = TransformationDTO({
            base: MI.STOVE,
            input: MI.MAC_N_CHEESE,
            next: MI.STOVE_COOKING_MAC_N_CHEESE,
            yield: 0,
            inputNext: 0,
            yieldQuantity: 0,
            unlockTime: 0,
            timeout: 0,
            timeoutYield: 0,
            timeoutYieldQuantity: 0,
            timeoutNext: 0,
            isRecipe: true,
            isWaterCollection: false,
            xp: 100,
            exists: true
        });

        TransformationDTO memory stove_cooking_mac_n_cheese_to_reward = TransformationDTO({
            base: MI.STOVE_COOKING_MAC_N_CHEESE,
            input: MI.UNLOCK_,
            next: MI.STOVE,
            yield: 0,
            inputNext: 0,
            yieldQuantity: 0,
            unlockTime: COOKING_TIME,
            timeout: COOKING_TIMEOUT,
            timeoutYield: MI.DUST,
            timeoutYieldQuantity: 1,
            timeoutNext: 0,
            isRecipe: false,
            isWaterCollection: false,
            xp: 100,
            exists: true
        });


        TransformationDTO[] memory transformations = new TransformationDTO[](2);
        transformations[0] = stove_to_cooking;
        transformations[1] = stove_cooking_mac_n_cheese_to_reward;

        world.setTransformations(transformations);

        alice_landId = setupPlayer(alice);
        bob_landId = setupPlayer(bob);

        uint256[] memory itemIds = new uint256[](5);
        uint256[] memory amounts = new uint256[](5);
        
        itemIds[0] = MI.FLOOR;
        itemIds[1] = MI.CHAIR;
        itemIds[2] = MI.TABLE;
        itemIds[3] = MI.STOVE;
        itemIds[4] = MI.MAC_N_CHEESE;

        for (uint256 i = 0; i < itemIds.length; i++) {
            amounts[i] = 1;
        }

        items.mintBatch(alice, itemIds, amounts, "");

        vm.startPrank(alice);
        world.depositItems(alice_landId, itemIds, amounts);
        
    }

    function test_cook() public {   
        vm.startPrank(alice);
        world.placeItem(alice_landId, 1, 1, MI.TABLE);
        world.placeItem(alice_landId, 1, 0, MI.CHAIR);
        world.placeItem(alice_landId, 0, 0, MI.STOVE);

        //time for vesting
        vm.roll(10000);

        uint256 bal1 = world.tokenBalanceOf(alice_landId);
        world.placeItem(alice_landId, 0, 0, MI.MAC_N_CHEESE);
        uint256 bal2 = world.tokenBalanceOf(alice_landId);

        assertEq(bal2, 0);
        assertEq(world.tokenBalanceOf(alice_landId), bal1);
        assertEq(ActiveStoves.getTotalActiveStoves(MI.STOVE), 1);
        assertEq(LandInfo.getActiveTables(alice_landId), 1);
        assertEq(LandItemCookingState.getYieldShares(alice_landId, 0, 0, 0), 100000);
        assertEq(LandItemCookingState.getRecipeId(alice_landId, 0, 0, 0), MI.MAC_N_CHEESE);

        bal1 = world.tokenBalanceOf(alice_landId);
        uint256 warpTime = block.timestamp + COOKING_TIME + 1;
        vm.warp(warpTime);
        world.placeItem(alice_landId, 0, 0, MI.UNLOCK_);
        bal2 = world.tokenBalanceOf(alice_landId);
        assertEq(bal2, (16248375e7));
        assertEq(PlayerTotalEarned.getTotalEarned(alice_landId), bal2);
    }

}