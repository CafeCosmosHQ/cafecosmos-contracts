// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {CafeCosmosConfig, LandInfo, LandCell, LandItem, LandInfoData, ItemInfoData} from  "../codegen/index.sol";

library LibLandManagement {

    
    function increaseLandTokenBalance(uint256 landId, uint256 amount) internal {
        // uint balance = LandInfo.getTokenBalance(landId);
        // LandInfo.setTokenBalance(landId, balance + amount);
    }

    function decreaseLandTokenBalance(uint256 landId, uint256 amount) internal {
        // uint balance = LandInfo.getTokenBalance(landId);
        // require(balance >= amount, "decreaseLandBalance: insufficient balance");
        // uint newBalance = balance - amount;
        // LandInfo.setTokenBalance(landId, newBalance);
    }

    function getLandTokenBalance(uint256 landId) internal view returns (uint256) {
        return LandInfo.getTokenBalance(landId);
    }
    
    function checkBounds(uint256 landId, uint256 x, uint256 y) internal view returns (bool) {        
        return LandInfo.getLimitY(landId) > y && 
               LandInfo.getLimitX(landId) > x &&
               LandInfo.getYBound(landId)[y] > x;
    }

    function getItemAt(uint256 landId, uint256 x, uint256 y) internal view returns (uint256 item) {
        require(
            checkBounds(landId, x, y),
            "getItemAt: Out of bounds"
        );
        uint zItemCount = LandCell.getZItemCount(landId, x, y);
        if (zItemCount == 0) { // no items in the cell
            return 0;
        }
        return LandItem.getItemId(landId, x, y, zItemCount - 1);
    }

    function setItemAt(uint256 landId, uint256 x, uint256 y, uint256 itemId) internal {
        if(itemId == 0) {
            removeLastItem(landId, x, y); // if itemId is 0 and there is an item in the cell, remove it
            return;
        }
        uint16 zItemCount = LandCell.getZItemCount(landId, x, y);  
        if(zItemCount == 0) {
            addItemAt(landId, x, y, itemId); // if there are no items in the cell, add the item
            return;
        }
        
        // if there are items in the cell, replace the last item with the new item
        LandItem.setItemId(landId, x, y, zItemCount - 1, itemId);
        LandItem.setIsRotated(landId, x, y, zItemCount - 1, false);
        LandItem.setPlacementTime(landId, x, y, zItemCount - 1, block.timestamp);
    }

    function addItemAt(uint256 landId, uint256 x, uint256 y, uint256 itemId) internal {
        uint16 zItemCount = LandCell.getZItemCount(landId, x, y);
        LandItem.setItemId(landId, x, y, zItemCount, itemId);
        LandItem.setPlacementTime(landId, x, y, zItemCount, block.timestamp);
        LandItem.setIsRotated(landId, x, y, zItemCount, false);
        LandCell.setZItemCount(landId, x, y, zItemCount + 1);
    }

    function removeLastItem(uint256 landId, uint256 x, uint256 y) internal {
        uint16 zItemCount = LandCell.getZItemCount(landId, x, y);
        if (zItemCount == 0) {
            return;
        }
        LandCell.setZItemCount(landId, x, y, zItemCount - 1);
        LandItem.deleteRecord(landId, x, y, zItemCount - 1);
    }

    function getLastItemInStackOrZero(uint256 landId, uint256 x, uint256 y) internal view returns (uint256) {
        uint zCount =  LandCell.getZItemCount(landId, x, y);
        if (zCount > 0) {
            return zCount - 1;
        }
        return 0;
    }
}