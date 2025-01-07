pragma solidity ^0.8.13;

import {CafeCosmosTest} from "./util/CafeCosmosTest.sol";
import {MI} from "./MockItems.sol";
import "forge-std/console.sol";
import {CafeCosmosConfig, LandInfo, ActiveStoves, LandItemCookingState, PlayerTotalEarned} from "../src/codegen/index.sol";
import {TransformationDTO} from "../src/systems/interfaces/ITransformationsSystem.sol";


contract VrgdaExpansion is CafeCosmosTest {
    
    address bob = address(0xb);
    uint256 bob_landId;
    
    address chuck = address(0xc);
    uint256 chuck_landId;

    function testLandExpansion() public {
        //bob
        uint256 cost = world.calculateLandCost(5, 5);
        softToken.transfer(bob, cost);

        uint256 bal1 = softToken.balanceOf(bob);

        vm.startPrank(bob);
        softToken.approve(worldAddress, cost);
        bob_landId = world.createLand(5, 5);
        vm.stopPrank(); 

        uint256 bal2 = softToken.balanceOf(bob);
        assertEq(bal1 - cost, bal2);

        //chuck
        uint256 cost2 = world.calculateLandCost(5, 5);

        softToken.transfer(chuck, cost2);       

        uint256 bal3 = softToken.balanceOf(chuck);        

        vm.startPrank(chuck);
        softToken.approve(worldAddress, cost2); 
        chuck_landId = world.createLand(5, 5);

        uint256 bal4 = softToken.balanceOf(chuck);
        assertEq(bal3 - bal4, cost2);

        assertGt(cost2, cost);
    }

}