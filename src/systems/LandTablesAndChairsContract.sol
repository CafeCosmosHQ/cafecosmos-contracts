// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;
import "./interfaces/ILandTablesAndChairs.sol";
import {LibLandManagement} from "../libraries/LibLandManagement.sol";
import {LandInfo, LandCell, LandTablesAndChairs, ItemInfo} from  "../codegen/index.sol";

contract LandTablesAndChairsContract is ILandTablesAndChairs {
     
    function checkPlaceTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) public override {
        if (ItemInfo.getIsTable(itemId)) {
            _placeTable(landId, x, y);
        } else if (ItemInfo.getIsChair(itemId)) {
            _placeChair(landId, x, y);
        }
    }

    function checkRemoveTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) public override {
        if (ItemInfo.getIsTable(itemId)) {
            _removeTable(landId, x, y);
        } else if (ItemInfo.getIsChair(itemId)) {
            _removeChair(landId, x, y);
        }
    }

    function _placeTable(uint256 landId, uint256 x, uint256 y) private {
        //right
        uint limitX = LandInfo.getLimitX(landId);
        uint limitY = LandInfo.getLimitY(landId);
        if (
            (limitX > x + 1) &&
            ItemInfo.getIsChair(LibLandManagement.getItemAt(landId, x + 1, y)) &&
            LandTablesAndChairs.getTablesOfChairs(landId, x + 1, y)[2] == 0 //if there is an adjacent chair
        ) {
            LandTablesAndChairs.setChairsOfTables(landId, x, y, [x + 1, y, 1]); //set location of chair on tables coordinates, and a flag saying this is active
            LandTablesAndChairs.setTablesOfChairs(landId, x + 1, y, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
        }
        //left
        else if (
            x > 0 &&
            ItemInfo.getIsChair(LibLandManagement.getItemAt(landId, x - 1, y)) &&
            LandTablesAndChairs.getTablesOfChairs(landId, x - 1, y)[2] == 0
        ) {
             LandTablesAndChairs.setChairsOfTables(landId, x, y, [x - 1, y, 1]);
             LandTablesAndChairs.setTablesOfChairs(landId, x - 1, y, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
        }
        //up
        else if (
            (limitY > y + 1) &&
            ItemInfo.getIsChair(LibLandManagement.getItemAt(landId, x, y + 1)) &&
            LandTablesAndChairs.getTablesOfChairs(landId, x, y +1)[2] == 0
        ) {
            LandTablesAndChairs.setChairsOfTables(landId, x, y, [x, y + 1, 1]);
            LandTablesAndChairs.setTablesOfChairs(landId, x, y + 1, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
        }
        //down
        else if (
            y > 0 &&
            ItemInfo.getIsChair(LibLandManagement.getItemAt(landId, x, y - 1)) &&
             LandTablesAndChairs.getTablesOfChairs(landId, x, y - 1)[2] == 0
        ) {
            LandTablesAndChairs.setChairsOfTables(landId, x, y, [x, y -1, 1]);
            LandTablesAndChairs.setTablesOfChairs(landId, x, y -1 , [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
        }
    }

    function _placeChair(uint256 landId, uint256 x, uint256 y) private {
        //up
        uint limitX = LandInfo.getLimitX(landId);
        uint limitY = LandInfo.getLimitY(landId);
        if (
            (limitX > x + 1) &&
            ItemInfo.getIsTable(LibLandManagement.getItemAt(landId, x + 1, y)) &&
            LandTablesAndChairs.getChairsOfTables(landId, x + 1, y)[2] == 0
        ) {
            //if that table is not already taken
            LandTablesAndChairs.setTablesOfChairs(landId, x, y, [x + 1, y, 1]); //set location of table on chairs coordinates, and a flag saying this is active
            LandTablesAndChairs.setChairsOfTables(landId, x + 1, y, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
            
        }
        //left
        else if (
            x > 0 &&
            ItemInfo.getIsTable(LibLandManagement.getItemAt(landId, x - 1, y)) &&
            LandTablesAndChairs.getChairsOfTables(landId, x - 1, y)[2] == 0
            
        ) {

            LandTablesAndChairs.setTablesOfChairs(landId, x, y, [x - 1, y, 1]);
            LandTablesAndChairs.setChairsOfTables(landId, x - 1, y, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
            
        }
        //up
        else if (
            (limitY > y + 1) &&
            ItemInfo.getIsTable(LibLandManagement.getItemAt(landId, x, y + 1)) &&
            LandTablesAndChairs.getChairsOfTables(landId, x, y + 1)[2] == 0
        ) {
            LandTablesAndChairs.setTablesOfChairs(landId, x, y, [x, y + 1, 1]);
            LandTablesAndChairs.setChairsOfTables(landId, x, y + 1, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
            
        }
        //down
        else if (
            y > 0 &&
            ItemInfo.getIsTable(LibLandManagement.getItemAt(landId, x, y - 1)) &&
            LandTablesAndChairs.getChairsOfTables(landId, x, y - 1)[2] == 0
        ) {
            LandTablesAndChairs.setTablesOfChairs(landId, x, y, [x, y - 1, 1]);
            LandTablesAndChairs.setChairsOfTables(landId, x, y - 1, [x, y, 1]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables + 1);
        }
    }

     function _removeTable(uint256 landId, uint256 x, uint256 y) private {
        uint256[3] memory chairsOfTables = LandTablesAndChairs.getChairsOfTables(landId, x, y);
        if (chairsOfTables[2] == 1) {
            uint256 chairX = chairsOfTables[0];
            uint256 chairY = chairsOfTables[1];
            uint256[3] memory tablesOfChair = LandTablesAndChairs.getTablesOfChairs(landId, chairX, chairY);
            require(
                tablesOfChair[0] == x &&
                tablesOfChair[1] == y &&
                tablesOfChair[2] == 1,
                "tablesOfChairs has a different coordinate for the table"
            );
            LandTablesAndChairs.setChairsOfTables(landId, x, y, [uint256(0), uint256(0), uint256(0)]);
            LandTablesAndChairs.setTablesOfChairs(landId, chairX, chairY, [uint256(0), uint256(0), uint256(0)]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables - 1);
        }
    }

    function _removeChair(uint256 landId, uint256 x, uint256 y) private {
        uint256[3] memory tablesOfChair = LandTablesAndChairs.getTablesOfChairs(landId, x, y);
        if (tablesOfChair[2] == 1) {
            uint256 tableX = tablesOfChair[0];
            uint256 tableY = tablesOfChair[1];
            uint256[3] memory chairsOfTables = LandTablesAndChairs.getChairsOfTables(landId, tableX, tableY);
            require(
                chairsOfTables[0] == x &&
                chairsOfTables[1] == y &&
                chairsOfTables[2] == 1,
                "chairsOfTables has different coordinates for the chair"
            );
            LandTablesAndChairs.setTablesOfChairs(landId, x, y, [uint256(0), uint256(0), uint256(0)]);
            LandTablesAndChairs.setChairsOfTables(landId, tableX, tableY, [uint256(0), uint256(0), uint256(0)]);
            uint activeTables = LandInfo.getActiveTables(landId);
            LandInfo.setActiveTables(landId, activeTables - 1);
            //we are "placing" the table again to check if there are any other chairs around it
            _placeTable(landId, tableX, tableY);
        }
    }   
}
