// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import "../interfaces/IPerlinItemConfig.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {CafeCosmosConfig, ConfigAddresses, LandInfoData, LandItem, LandCell, LandInfo, Vrgda, PlayerTotalEarned, ItemInfo} from  "../codegen/index.sol";
import {LibLandManagement} from "../libraries/LibLandManagement.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import {LibLandAccess} from "../libraries/LibLandAccess.sol";
import {LibVRGDA} from "../libraries/LibVRGDA.sol";
import {LibInitialLandItemsStorage, InitialLandItem} from "../libraries/LibInitialLandItemsStorage.sol"; 
import "../interfaces/ILandNFTs.sol";
import "../interfaces/IERC20.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {WorldContextConsumerLib } from "@latticexyz/world/src/worldcontext.sol";
import {LibLandAccess} from "../libraries/LibLandAccess.sol";
import {IWETH9} from "../interfaces/IWETH9.sol";
import "./interfaces/ILandTablesAndChairs.sol"; 
import "@openzeppelin/contracts/utils/Address.sol";

  
contract LandCreationSystem is System, RootAccessOperator, LandAccessOperator {
    uint160 constant SEED_MASK = (1 << 32) - 1;
    uint256 constant DEFAULT_LAND_TYPE = 0; // we only have one land type for now
    event LandCreated(uint256 indexed landId, address indexed owner, uint256 limitX, uint256 limitY);
    event LandPurchase(uint256 indexed landId, uint256 area, uint256 cost);
    event LandExpanded(uint256 indexed landId, uint256 x1, uint256 y1);
 
    function setInitialLandLimits(
        uint256 limitX,
        uint256 limitY
    ) public onlyOwner {
        CafeCosmosConfig.setInitialLimitX(limitX);
        CafeCosmosConfig.setInitialLimitY(limitY);
    }

    function setLandName(uint256 landId, string memory name) public onlyLandOperator(landId) {
         ILandNFTs(ConfigAddresses.getLandNFTsAddress()).setLandName(landId, name);
    }

    function setInitialLandItems(InitialLandItem[] calldata items, uint256 landIndex, uint256 _initialLandItemsDefaultIndex) public onlyOwner {
        LibInitialLandItemsStorage.st().initialLandItemsDefaultIndex[DEFAULT_LAND_TYPE] = _initialLandItemsDefaultIndex;
        for (uint256 i = 0; i < items.length; i++) {
            InitialLandItem[] storage initialLandItemLand =  LibInitialLandItemsStorage.st().initialLandItems[DEFAULT_LAND_TYPE][landIndex];
            InitialLandItem storage item = initialLandItemLand.push();
            item.x = items[i].x;
            item.y = items[i].y; 
            item.z = items[i].z;
            item.rotated = items[i].rotated;
            item.itemId = items[i].itemId;
        }
    }

     function createPlayerInitialLand() external payable returns (uint256 landId) {
        address sender = WorldContextConsumerLib._msgSender();
        require(!LibInitialLandItemsStorage.st().isLandCreatedWithDefaultItems[sender], "Land: Only one land per address");
        uint256 initialLimitX = CafeCosmosConfig.getInitialLimitX();
        uint256 initialLimitY = CafeCosmosConfig.getInitialLimitY();

        uint256 area = calculateArea(initialLimitX, initialLimitY);
        _completeLandPurchasePayment(landId, area);

        landId = ILandNFTs(ConfigAddresses.getLandNFTsAddress()).mint(sender);
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

       _expandLand(landId, initialLimitX, initialLimitY);

        uint256 perlin = IPerlinItemConfig(ConfigAddresses.getPerlinItemConfigAddress()).calculatePerlin(5, 5, seed);
        InitialLandItem[] memory items =  LibInitialLandItemsStorage.st().initialLandItems[DEFAULT_LAND_TYPE][perlin];
        if(items.length == 0) {
            items =  LibInitialLandItemsStorage.st().initialLandItems[DEFAULT_LAND_TYPE][ LibInitialLandItemsStorage.st().initialLandItemsDefaultIndex[DEFAULT_LAND_TYPE]];
        }

        for (uint256 index = 0; index < items.length; index++) {

        
            uint x = items[index].x;
            uint y = items[index].y;
            uint z = items[index].z;
            uint itemId = items[index].itemId;
            bool rotated = items[index].rotated;
            
            if(ItemInfo.getIsTable(itemId) || ItemInfo.getIsChair(itemId)) {
                continue; // we don't want to place tables and chairs here as we cannot guarantee the z order count as they are placed in a different way and depend on other tables and chairs
            }
            LandItem.set(landId, x, y, z, itemId, block.timestamp, 0, 0, rotated);
            uint16 zCount = LandCell.getZItemCount(landId, x, y);
            if(zCount < z + 1) {
                 LandCell.setZItemCount(landId, x, y, uint16(z) + 1);
            }
        }

        for (uint256 index = 0; index < items.length; index++) {
            uint itemId = items[index].itemId;
            //we place tables and chairs after all other items are placed as they are the last items to be placed and depend on other tables and chairs
            if(ItemInfo.getIsTable(itemId) || ItemInfo.getIsChair(itemId)) {

                //uint x = items[index].x;
                //uint y = items[index].y;
                LibInventoryManagement.increaseQuantity(landId, itemId, 1);
                //LibLandManagement.addItemAt(landId, x, y, itemId);
                //_checkPlaceTableOrChair(landId, itemId, x, y);
            }            
        }
        emit LandCreated(landId, msg.sender, initialLimitX, initialLimitY); 
        LibInitialLandItemsStorage.st().isLandCreatedWithDefaultItems[msg.sender] = true; 
    }

    function _checkPlaceTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) internal {
        bytes memory data = abi.encodeWithSelector(ILandTablesAndChairs.checkPlaceTableOrChair.selector, landId, itemId, x, y);
        Address.functionDelegateCall(ConfigAddresses.getLandTablesAndChairsAddress(), data, "error placing table or chair when creating land");
    } 
    
    function createLand(uint256 limitX, uint256 limitY) payable external returns (uint256 landId) {
        address landNFTs = ConfigAddresses.getLandNFTsAddress();
        require(landNFTs != address(0), "LandConfig: LandNFTs address not set");
        require(limitX > CafeCosmosConfig.getMinStartingX() && limitY > CafeCosmosConfig.getMinStartingY(), "LandConfig: minimum starting limits not met");
        landId = ILandNFTs(landNFTs).mint(msg.sender);

        uint160 caller = uint160(msg.sender);
        uint32 seed = 0;
        unchecked {
            seed = uint32(caller & SEED_MASK) + (uint32(block.timestamp & SEED_MASK) >> 2);
            LandInfo.setSeed(landId, seed);
            LandInfo.setActiveStoves(landId, 0);
            LandInfo.setActiveTables(landId, 0);
        }
        LandInfo.setIsInitialized(landId, true);
        uint area = calculateArea(limitX, limitY);
        _completeLandPurchasePayment(landId, area);
    
        _expandLand(landId, limitX, limitY); 
        emit LandCreated(landId, msg.sender, limitX, limitY);  
    }

    function expandLand(uint256 landId, uint256 x1, uint256 y1) external payable onlyLandOperator(landId) {
        if (x1 == 0 && y1 == 0) {
            return;
        } 
         uint area = calculateExpansionArea(landId, x1, y1);
        _completeLandPurchasePayment(landId, area);
        _expandLand(landId, x1, y1);
        emit LandExpanded(landId, x1, y1);
       
    }

    function _completeLandPurchasePayment(uint landId, uint area) private {
          uint256 cost = calculateVrgdaCost(area);
          Vrgda.setTotalUnitsSold(Vrgda.getTotalUnitsSold() + area);
          if(msg.value == 0) {
            IERC20(ConfigAddresses.getSoftTokenAddress()).transferFrom(msg.sender, ConfigAddresses.getSoftDestinationAddress(), cost);
        } else {
            require(msg.value == cost, "Incorrect payment amount");
            IWETH9(ConfigAddresses.getSoftTokenAddress()).deposit{value: msg.value}();
            IERC20(ConfigAddresses.getSoftTokenAddress()).transfer(ConfigAddresses.getSoftDestinationAddress(), msg.value);
        }
        PlayerTotalEarned.setTotalSpent(landId, PlayerTotalEarned.getTotalSpent(landId) + cost);
        emit LandPurchase(landId, area, cost);
    }
    
     function _expandLand(uint256 landId, uint256 x1, uint256 y1) internal  {
        if (x1 == 0 && y1 == 0) {
            return;
        }

        unchecked {
            uint256 limitX = LandInfo.getLimitX(landId);
            uint256 limitY = LandInfo.getLimitY(landId);
            LandInfo.setLimitX(landId, limitX + x1);
            LandInfo.setLimitY(landId, limitY + y1);
        }

        for (uint256 i = 0; i < y1; i++) {
            LandInfo.pushYBound(landId, 0);
        }

        generateChunk(landId);
    }
    
     function generateChunk(uint256 landId) public onlyLandOperator(landId) {
        uint256 chunkSize = CafeCosmosConfig.getChunkSize();
        require(chunkSize > 0, "generateChunk: configure chunk size");
        uint256 count = 0;
        uint256[] memory yBounds = LandInfo.getYBound(landId);
        uint256 limitX = LandInfo.getLimitX(landId);
        
        for (uint256 y = 0; y < yBounds.length; y++) {
            uint256 ybound = yBounds[y];
            for (uint256 x = ybound; x < limitX; x++) {
                ybound = ybound + 1;
                initialiseItem(landId, x, y);
                LandInfo.updateYBound(landId, y, ybound);
                count++;
                if (count == chunkSize) {
                    break;
                }
            }
            if (count == chunkSize) {
                break;
            }
        }
    }

    function initialiseItem(uint256 landId, uint256 x, uint256 y) internal {
        uint256 itemId = getItemIdFromPerlin(landId, x, y);
        LibLandManagement.setItemAt(landId, x, y, itemId);
    }


     function getItemIdFromPerlin(uint256 landId, uint256 x, uint256 y) internal view returns (uint256 itemId)
     { 
        if(gasleft() < 10000) {
            return 0;
        }
        uint32 seed = LandInfo.getSeed(landId);
        try IPerlinItemConfig(ConfigAddresses.getPerlinItemConfigAddress()).calculatePerlinAndGetItem(
            x,
            y,
            seed
            )
            returns (uint256 _itemId) {
            return _itemId;
        } catch {
            return 0;
        }
        
    }

    function calculateLandCost(uint256 x0, uint256 y0) public view returns (uint256 cost) {
        return calculateVrgdaCost(y0 * x0);
    } 

    function calculateLandExpansionCost(uint256 landId, uint256 x1, uint256 y1) public view returns (uint256 cost) {
        return calculateVrgdaCost(calculateExpansionArea(landId, x1, y1));
    }

    function calculateVrgdaCost(uint256 area) public view returns (uint256 vrgdaCost) {

        uint256 fixedCost = CafeCosmosConfig.getSoftCostPerSquare();
        if(fixedCost > 0) {
            return fixedCost * area;
        }

        for(uint256 i; i < area; i++) {
            vrgdaCost += LibVRGDA.getVRGDAPrice(i + Vrgda.getTotalUnitsSold());
        }
        require(vrgdaCost > 0, "Land: cost cannot be zero");
    }

    function calculateArea(uint256 x, uint256 y) public pure returns (uint256 area) {
        unchecked {
            area = x * y;
        }
    }

    function calculateExpansionArea(uint256 landId, uint256 x1, uint256 y1) public view returns (uint256 area) {
        uint256 x0 = LandInfo.getLimitX(landId);
        uint256 y0 = LandInfo.getLimitY(landId);
        unchecked {
            area = x1 * y0 + y1 * x0 + y1 * x1;
        }
    }

    function calculateLandInitialPurchaseCost() public view returns (uint256 cost) {
        uint256 x0 = CafeCosmosConfig.getInitialLimitX();
        uint256 y0 = CafeCosmosConfig.getInitialLimitY();
        return calculateLandCost(x0, y0);
    }
}