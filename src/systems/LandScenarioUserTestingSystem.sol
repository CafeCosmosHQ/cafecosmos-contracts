 // SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import {LandItemDTO} from "../libraries/LandDTOs.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {LibLandAccess} from "../libraries/LibLandAccess.sol";
import {LibAccess} from "../libraries/LibAccess.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/ILandTablesAndChairs.sol"; 

import "../interfaces/ILandNFTs.sol";
import {CafeCosmosConfig, ConfigAddresses, LandInfo, LandItemCookingState, LandItemCookingStateData, ActiveStoves, LandCell, LandItemData, LandItem, LandTablesAndChairs, LandItemCookingState} from  "../codegen/index.sol";

contract LandScenarioUserTestingSystem is System, RootAccessOperator, LandAccessOperator{
    
    event LandCreated(uint256 indexed landId, address indexed owner, uint256 limitX, uint256 limitY);

    modifier onlyRootOwnerOrLandOperator(uint landId) {
        require(LibAccess.hasRootAccess() || LibLandAccess.isLandOperator(landId, msg.sender), "Only owner or land operator can call this function");
        _;
    }

    function _clearLand(uint256 landId) private onlyRootOwnerOrLandOperator(landId) {
        uint256 limX = LandInfo.get(landId).limitX;
        uint256 limY = LandInfo.get(landId).limitY;
        
        for (uint256 x; x < limX; x++) {
            for (uint256 y; y < limY; y++) {
                uint numberOfStackItems = LandCell.getZItemCount(landId, x, y);
                for(uint z; z <= numberOfStackItems; z++){
                    LandItem.deleteRecord(landId, x, y, z);
                    LandItemCookingState.deleteRecord(landId, x, y, z);
                }
                LandCell.setZItemCount(landId, x, y, 0);
                LandCell.deleteRecord(landId, x, y);
                LandTablesAndChairs.deleteRecord(landId, x, y);
            }
        }
        
        uint length = LandInfo.lengthYBound(landId);
        for (uint i = 0; i < length; i++) {
            LandInfo.popYBound(landId);
        } 
    }

    function resetUserTestLandScenario(uint landId, uint limitX, uint limitY,  LandItemDTO[] calldata landItems) public onlyRootOwnerOrLandOperator(landId) {    
        _clearLand(landId);
        LandInfo.setLimitX(landId, limitX);
        LandInfo.setLimitY(landId, limitY);
        LandInfo.setActiveStoves(landId, 0);
        LandInfo.setActiveTables(landId, 0);
    
        for (uint256 index = 0; index < limitY; index++) {
            LandInfo.pushYBound(landId, limitX);
        }

        for (uint256 index = 0; index < landItems.length; index++) {
            uint256 x = landItems[index].x;
            uint256 y = landItems[index].y;
            uint256 itemId = landItems[index].itemId;
            uint256 stackIndex = landItems[index].stackIndex;
            setItemInitAt(landId, x, y, stackIndex, itemId);
        }
        
    }

  function createUserTestScerarioLand(
        address player,
        uint256 limitX,
        uint256 limitY,
        LandItemDTO[] calldata landItems
    ) public onlyOwner {
        
        ILandNFTs landNFTs = ILandNFTs(ConfigAddresses.getLandNFTsAddress());  
        uint256 landId = landNFTs.mint(player);
        //setting the deployer as land operator so we can mint and deposit items through items management
        //LandAccessOperator.setLandOperator(landId, player);
        //ls().operatingApproval[player][landId][msg.sender] = true;
        LandInfo.setLimitX(landId, limitX);
        LandInfo.setLimitY(landId, limitY);
        LandInfo.setActiveStoves(landId, 0);
        LandInfo.setActiveTables(landId, 0);
    
        for (uint256 index = 0; index < limitY; index++) {
            LandInfo.pushYBound(landId, limitX);
        }

        for (uint256 index = 0; index < landItems.length; index++) {
            uint256 x = landItems[index].x;
            uint256 y = landItems[index].y;
            uint256 itemId = landItems[index].itemId;
            uint256 stackIndex = landItems[index].stackIndex;
            setItemInitAt(landId, x, y, stackIndex, itemId);
        }

         emit LandCreated(landId, player, limitX, limitY);  
    }

    /*
    function createPlayerInitialFreeLand() public returns (uint256 landId) {
       
        landId = ILandNFTs(ConfigAddresses.getLandNFTsAddress()).mint(msg.sender);
        //tools
         LibInventoryManagement.mint(landId, 1010, 1);
         LibInventoryManagement.mint(landId, 110, 1);
         LibInventoryManagement.mint(landId, 111, 1);
         LibInventoryManagement.mint(landId, 112, 1);
         LibInventoryManagement.mint(landId, 108, 1); 
         
        
        uint160 caller = uint160(msg.sender);
        uint32 seed = 0;
        unchecked {
            seed = uint32(caller & SEED_MASK) + (uint32(block.timestamp & SEED_MASK) >> 2);
            LandInfo.setSeed(landId, seed);
            LandInfo.setActiveStoves(landId, 0);
            LandInfo.setActiveTables(landId, 0);
        }
        LandInfo.setIsInitialized(landId, true);
        uint256 initialLimitX = CafeCosmosConfig.getInitialLimitX();
        uint256 initialLimitY = CafeCosmosConfig.getInitialLimitY();

     
         _expandLand(landId, initialLimitX, initialLimitY);

        uint256 perlin = IPerlinItemConfig(ConfigAddresses.getPerlinItemConfigAddress()).calculatePerlin(5, 5, seed);
        InitialLandItem[] memory items =  LibInitialLandItemsStorage.st().initialLandItems[DEFAULT_LAND_TYPE][perlin];
        if(items.length == 0) {
            items =  LibInitialLandItemsStorage.st().initialLandItems[DEFAULT_LAND_TYPE][ LibInitialLandItemsStorage.st().initialLandItemsDefaultIndex[DEFAULT_LAND_TYPE]];
        }
        for (uint256 index = 0; index < items.length; index++) {
            LibLandManagement.setItemAt(landId, items[index].x, items[index].y, items[index].itemId);
        }

       emit LandCreated(landId, msg.sender, initialLimitX, initialLimitY); 
       LibInitialLandItemsStorage.st().isLandCreatedWithDefaultItems[msg.sender] = true; 
    }*/

    function setItemInitAt(uint256 landId, uint256 x, uint256 y, uint z, uint itemId) internal {
        if(itemId == 0) {
            return;
        }
        uint256 zItemCount = LandCell.getZItemCount(landId, x, y);
        if(z >= zItemCount) {
            uint16 newLength = uint16(z + 1);
            LandCell.setZItemCount(landId, x, y, newLength);
        }
        LandItem.setItemId(landId, x, y, z, itemId);
        LandItem.setPlacementTime(landId, x, y, z, block.timestamp);
        LandItem.setIsRotated(landId, x, y, z, false);
        _checkPlaceTableOrChair(landId, itemId, x, y);
    }
    
    function _checkPlaceTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) internal {
        bytes memory data = abi.encodeWithSelector(ILandTablesAndChairs.checkPlaceTableOrChair.selector, landId, itemId, x, y);
        Address.functionDelegateCall(ConfigAddresses.getLandTablesAndChairsAddress(), data);
    } 


}