// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import "./interfaces/ILandTablesAndChairs.sol"; 
import "./interfaces/ILandTransform.sol";
import "../interfaces/IRedistributor.sol"; 
import "../interfaces/ILandNFTs.sol";
import "../interfaces/IERC20.sol";

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {LibLandManagement} from "../libraries/LibLandManagement.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import {ILandQuestTaskProgressUpdate} from "./interfaces/ILandQuestTaskProgressUpdate.sol";
import {CafeCosmosConfig, ConfigAddresses, LandInfo, LandItemCookingState, LandItemCookingStateData, ActiveStoves, LandCell, LandItem, ItemInfo, StackableItem, Inventory, Transformations, TransformationsData} from  "../codegen/index.sol";
   
contract LandItemInteractionSystem is System, LandAccessOperator {
    using SafeMath for uint256;
    //** PUBLIC METHODS */
    function placeItem(uint256 landId, uint256 x, uint256 y, uint256 itemId) public onlyLandOperator(landId){
        require(LibLandManagement.checkBounds(landId, x, y), "Land: Out of bounds"); 
        require(LibInventoryManagement.itemBalanceOf(landId, itemId) > 0 || itemId == 0, "Land: you do not have this item in your inventory");
        uint itemIdAtPosition = LibLandManagement.getItemAt(landId, x, y);
        if (
            itemIdAtPosition == 0 &&
            !Transformations.getExists(0, itemId) && 
            itemId != 0
        ) {
            _handlePlaceItemNoTransformation(landId, x, y, itemId);
        } else if (
            Transformations.getExists(itemIdAtPosition, itemId)
        ) {  
            _handleTransformation(landId, x, y, itemId);
        } else if (StackableItem.getStackable(itemIdAtPosition,itemId)) {
            _handleStackable(landId, x, y, itemId, itemIdAtPosition);
        } else { //no transformation found
            revert ILandTransform.TransformationIncompatible({ base: itemIdAtPosition, input: itemId });
        }
    }

     function removeItem(uint256 landId, uint256 x, uint256 y) public onlyLandOperator(landId) {
        uint256 itemId = LibLandManagement.getItemAt(landId, x, y);
        uint256 activeStoves = LandInfo.getActiveStoves(landId);
        require(itemId > 0, "Land: space is empty");
        require(!ItemInfo.getNonRemovable(itemId), "Land: item is non removable");
        require(
            !(ItemInfo.getIsChair(itemId) && activeStoves > 0),
            "Land: cannot remove chair while cooking"
        );
        require(
            !(ItemInfo.getIsTable(itemId) && activeStoves > 0),
            "Land: cannot remove table while cooking"
        );
        LibInventoryManagement.increaseQuantity(landId, itemId, 1);
        LibLandManagement.removeLastItem(landId, x, y);
        _checkRemoveTableOrChair(landId, itemId, x, y);
        _checkRemoveBooster(landId, itemId);
        _incrementQuestProgressCollectItem(landId, itemId);
        
    }

    function moveItem(uint256 landId, uint256 srcX, uint256 srcY, uint256 dstX, uint256 dstY) public onlyLandOperator(landId) {
        uint256 itemId =  LibLandManagement.getItemAt(landId, srcX, srcY);
        removeItem(landId, srcX, srcY);
        placeItem(landId, dstX, dstY, itemId); 
    }

    //hack work around to force
    function timestampCheck() public {
        uint x = 1;
    }

    /* NOT COLLATERAL SO NO NEED FOR THIS
    //allow anyone to update the stove for a reward
    function updateStove(uint256 landId, uint256 x, uint256 y) public { 
        uint zCount = LandCell.getZItemCount(landId, x, y);
        LandItemCookingStateData memory cookingState = LandItemCookingState.get(landId, x, y, zCount - 1);
        require(cookingState.yieldShares > 0, "Land: not cooking anything");

        uint256 base = LibLandManagement.getItemAt(landId, x, y);
        TransformationsData memory config = Transformations.get(base, 0);
        uint256 placementTime = LandItem.getPlacementTime(landId, x, y, zCount - 1);
        
        require(block.timestamp > (placementTime + config.timeout), "Land: not timed out");

        LibInventoryManagement.mint(landId, config.timeout, 1);
        
        IRedistributor(ConfigAddresses.getRedistributorAddress()).burnShares(cookingState.recipeId, cookingState.yieldShares);
        LibLandManagement.setItemAt(landId, x, y, config.next);

        IERC20(ConfigAddresses.getSoftTokenAddress()).transfer(msg.sender, cookingState.collateral); //TODO: remvoe collateral
        
        //cookingState.stoveId;
        uint activeStoves = ActiveStoves.getTotalActiveStoves(cookingState.stoveId);
        ActiveStoves.setTotalActiveStoves(cookingState.stoveId, activeStoves - 1);
        LandItemCookingState.deleteRecord(landId, x, y, zCount - 1);
    }
    */

    function toggleRotation(uint256 landId, uint256 x, uint256 y, uint256 z) external onlyLandOperator(landId) {
        require(z < LandCell.getZItemCount(landId, x, y), "Land: index out of range");
        require(ItemInfo.getIsRotatable(LandItem.getItemId(landId, x, y, z)), "Land: item is not rotatable");
        bool isRotated = LandItem.getIsRotated(landId, x, y, z);
        LandItem.setIsRotated(landId, x, y, z, !isRotated);
    }

    //** PRIVATE METHODS */
     
    function _handleTransformation(uint256 landId, uint256 x, uint256 y, uint256 itemId) private {
        _transform(landId, x, y, itemId);
        _checkRemoveBooster(landId, itemId);
    }

    function _handlePlaceItemNoTransformation(uint256 landId, uint256 x, uint256 y, uint256 itemId) private {
        require(!ItemInfo.getNonPlaceable(itemId), "Land: item is non placeable"); //item should only be placeable if not going into transformation
        LibInventoryManagement.decreaseQuantity(landId, itemId, 1);
        LibLandManagement.setItemAt(landId, x, y, itemId);
        _checkPlaceTableOrChair(landId, itemId, x, y);
        _checkBooster(landId, itemId);
        //_incrementQuestProgressPlaceItemNoTransform(landId, itemId);
    }

    function _handleStackable(uint256 landId, uint256 x, uint256 y, uint256 itemId, uint itemIdAtPosition) private {
        LibInventoryManagement.decreaseQuantity(landId, itemId, 1);
        LibLandManagement.addItemAt(landId, x, y, itemId);
        _checkPlaceTableOrChair(landId, itemId, x, y);
        _checkBooster(landId, itemId);
        _incrementQuestProgressStackItem(landId, itemIdAtPosition, itemId);
    }

    function _checkPlaceTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) internal {
        bytes memory data = abi.encodeWithSelector(ILandTablesAndChairs.checkPlaceTableOrChair.selector, landId, itemId, x, y);
        Address.functionDelegateCall(ConfigAddresses.getLandTablesAndChairsAddress(), data);
    } 

    function _checkRemoveTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) internal {
        bytes memory data = abi.encodeWithSelector(ILandTablesAndChairs.checkRemoveTableOrChair.selector, landId, itemId, x, y);
        Address.functionDelegateCall(ConfigAddresses.getLandTablesAndChairsAddress(), data);
    }

    function _checkBooster(uint256 landId, uint256 itemId) internal {
        /*
        uint256 themeId = ls().itemIdToThemeId[itemId];
        if (themeId > 0) {
            if (themeId == GLOBAL_BOOSTER_ID) {
                ls().lands[landId].boosters[themeId][0] += ls().booster[themeId][itemId];
            } else {
                uint256 category = ls().item_category[itemId];
                ls().lands[landId].boosters[themeId][category] += ls().booster[themeId][itemId];
            }
        }*/
    }

    function _checkRemoveBooster(uint256 landId, uint256 itemId) view internal {
        /*
        uint256 themeId = ls().itemIdToThemeId[itemId];
        if (themeId > 0) {
            if (themeId == GLOBAL_BOOSTER_ID) {
                ls().lands[landId].boosters[GLOBAL_BOOSTER_ID][0].sub(ls().booster[themeId][itemId]);
            } else {
                uint256 category = ls().item_category[itemId];
                ls().lands[landId].boosters[themeId][category].sub(ls().booster[themeId][itemId]);
            }
        }*/
    } 
    
    function _transform(uint256 landId, uint256 x, uint256 y, uint256 input) internal {
        uint256 base = LibLandManagement.getItemAt(landId, x, y);
        TransformationsData memory   config = Transformations.get(base, input); 
        LandInfo.setCumulativeXp(landId, LandInfo.getCumulativeXp(landId) + config.xp);
        bytes memory data = abi.encodeWithSelector(ILandTransform.transform.selector, landId, x, y, input, config);
        Address.functionDelegateCall(ConfigAddresses.getLandTransformAddress(), data);
       
       _incrementQuestProgressTransform(landId, base, input);
    }

    function _incrementQuestProgressTransform(uint256 landId, uint256 base, uint256 input) internal {
        bytes memory data = abi.encodeWithSelector(ILandQuestTaskProgressUpdate.incrementProgressTransform.selector, landId, base, input);
        Address.functionDelegateCall(ConfigAddresses.getLandQuestTaskProgressUpdateAddress(), data);
    }

     function _incrementQuestProgressStackItem(uint256 landId, uint base, uint256 itemId) internal {
        bytes memory data = abi.encodeWithSelector(ILandQuestTaskProgressUpdate.incrementQuestProgressStackItem.selector, landId, base, itemId);
        Address.functionDelegateCall(ConfigAddresses.getLandQuestTaskProgressUpdateAddress(), data);
    }

    function _incrementQuestProgressCollectItem(uint256 landId, uint256 itemId) internal { 
        bytes memory data = abi.encodeWithSelector(ILandQuestTaskProgressUpdate.incrementProgressCollectItem.selector, landId, itemId);
        Address.functionDelegateCall(ConfigAddresses.getLandQuestTaskProgressUpdateAddress(), data);
    }
}