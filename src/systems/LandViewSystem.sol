// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import {LandItemDTO, PlayerTotalEarnedDTO} from "../libraries/LandDTOs.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { LandCell, LandItem, LandItemData, LandInfo, LandTablesAndChairs, PlayerTotalEarned, PlayerTotalEarnedData} from  "../codegen/index.sol";
 
contract LandViewSystem is System {
    /* 
    Returns the entire grid of items 
    */
    function getLandItems(uint256 landId, uint256 x, uint256 y) public view returns (LandItemDTO[] memory landItems) {
        uint zCount = LandCell.getZItemCount(landId, x, y);
        landItems = new LandItemDTO[](zCount);
        for (uint256 z = 0; z < zCount; z++) {
            LandItemData  memory landItem = LandItem.get(landId, x, y, z);
            landItems[z] = LandItemDTO({
                x: x,
                y: y,
                itemId: landItem.itemId,
                placementTime: landItem.placementTime,
                stackIndex: z,
                isRotated: landItem.isRotated,
                dynamicUnlockTime: landItem.dynamicUnlockTimes,
                dynamicTimeoutTime: landItem.dynamicTimeoutTimes
            });
        }
        return landItems;
    }

    function getRotation(uint256 landId, uint256 x, uint256 y) public view returns (bool) {
        uint z = LandCell.getZItemCount(landId, x, y) - 1;
        return LandItem.getIsRotated(landId, x, y, z);
    }

    function getPlacementTime(uint256 landId, uint x, uint y) public view returns (uint256) {
        uint z = LandCell.getZItemCount(landId, x, y) - 1;
        return LandItem.getPlacementTime(landId, x, y, z);
    }

    function getActiveTables(uint256 landId) public view returns (uint256) {
        return LandInfo.getActiveTables(landId);
    }

    function getTablesOfChairs(uint256 landId, uint256 x, uint256 y) public view returns (uint256[3] memory) {
        return LandTablesAndChairs.getTablesOfChairs(landId, x, y);
    }

    function getChairsOfTables(uint256 landId, uint256 x, uint256 y) public view returns (uint256[3] memory) {
        return LandTablesAndChairs.getChairsOfTables(landId, x, y);
    }

    function getTotalEarned(uint256 landId) public view returns (PlayerTotalEarnedDTO memory playerTotalEarned)  {
        PlayerTotalEarnedData memory playerTotalEarnedData = PlayerTotalEarned.get(landId);
        return PlayerTotalEarnedDTO({
            landId: landId,
            totalEarned: playerTotalEarnedData.totalEarned,
            totalSpent: playerTotalEarnedData.totalSpent
        });
    }

    function getLandItems3d(uint256 landId) public view returns (LandItemDTO[][][] memory land3d) {
        //this will have the min and max x starting from minX and the same for y
        uint256 limX = LandInfo.get(landId).limitX;
        uint256 limY = LandInfo.get(landId).limitY;
        
        land3d = new LandItemDTO[][][](limX);
        for (uint256 x; x < limX; x++) {
            land3d[x] = new LandItemDTO[][](limY);
            for (uint256 y; y < limY; y++) {
                land3d[x][y] = getLandItems(landId, x, y);
            }
        }
        return land3d;
    }
    
}