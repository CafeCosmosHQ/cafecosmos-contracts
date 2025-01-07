// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import "../interfaces/IRedistributor.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../util/CoinReceiver.sol";
import "../interfaces/ICrafting.sol";
import { ItemInfoDTO, StackableItemDTO } from "../libraries/LandDTOs.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {CafeCosmosConfig, ConfigAddresses, LandInfo, LandInfoData, ActiveStoves, ItemInfoData, ItemInfo, LandPermissions, StackableItem} from  "../codegen/index.sol";


contract LandConfigSystem is RootAccessOperator, LandAccessOperator, System {
     
    function getLandInfo(uint256 landId) public view returns (LandInfoData memory landInfo) {
        return LandInfo.get(landId);
    }

    function setItemConfigAddress(address itemConfigAddress_) public onlyOwner {
        ConfigAddresses.setPerlinItemConfigAddress(itemConfigAddress_);
    }

    function setLandTransformAddress(address landTransformAddress_) public onlyOwner {
       ConfigAddresses.setLandTransformAddress(landTransformAddress_);
       
    }

    function setLandTablesAndChairsAddress(address landTablesAndChairsAddress_) public onlyOwner {
       ConfigAddresses.setLandTablesAndChairsAddress(landTablesAndChairsAddress_);
    }

    function setLandQuestTaskProgressUpdateAddress(address landQuestTaskProgressUpdateAddress_) public onlyOwner {
        ConfigAddresses.setLandQuestTaskProgressUpdateAddress(landQuestTaskProgressUpdateAddress_); 
    }

    function setSoftDestination(address softDestination_) public onlyOwner {
        ConfigAddresses.setSoftDestinationAddress(softDestination_);
    }

    function setRedistributor(address _redistributor) public onlyOwner {
        ConfigAddresses.setRedistributorAddress(_redistributor);
    }

    function setLandNFTs(address landNFTs_) public onlyOwner {
        ConfigAddresses.setLandNFTsAddress(landNFTs_);
    }

    function setSoftToken(address softToken_) public onlyOwner {
        ConfigAddresses.setSoftTokenAddress(softToken_);
    }

    function getSoftToken() public view returns (address) {
        return ConfigAddresses.getSoftTokenAddress();
    }


    function setVesting(address vesting_) public onlyOwner {
        ConfigAddresses.setVestingAddress(vesting_);
    }

      function getSoftDestinationAddress() public view returns (address) {
        ConfigAddresses.getSoftDestinationAddress();
    }

    function getLandTablesAndChairsAddress() public view returns (address) {
        return ConfigAddresses.getLandTablesAndChairsAddress();
    }

    function setItems(address items) public onlyOwner {
        ConfigAddresses.setItemsAddress(items);
    }

/*
    function setBooster(uint256 _itemId, uint256 _boost, uint256 _themeId, uint256 _categoryId) public onlyOwner {
        require(_categoryId < 7, "category ID too large");
        ls().itemIdToThemeId[_itemId] = _themeId;
        ls().item_category[_itemId] = _categoryId;
        ls().booster[_themeId][_itemId] = _boost;
    }
    */

/*
    function setGlobalBooster(uint256 _itemId, uint256 _boost) public onlyOwner {
        ls().itemIdToThemeId[_itemId] = GLOBAL_BOOSTER_ID;
        ls().booster[GLOBAL_BOOSTER_ID][_itemId] = _boost;
    }

    function setMaxCategoryBoosts(
        uint256 _maxFloor,
        uint256 _maxTable,
        uint256 _maxChair,
        uint256 _maxDecoration,
        uint256 _maxBarTable,
        uint256 _maxStove,
        uint256 _maxWall
    ) public onlyOwner {
        ls().categoryMaxBoost = [_maxFloor, _maxTable, _maxChair, _maxDecoration, _maxBarTable, _maxStove, _maxWall];
    }

    function setMaxBoost(uint256 _maxLocal, uint256 _maxGlobal, uint256 _maxTotal) public onlyOwner {
        ls().maxBoosts = [_maxLocal, _maxGlobal, _maxTotal];
    }
*/
/*
    function setRecipeIdToThemeId(uint256 _recipeId, uint256 _themeId) public onlyOwner {
        ls().itemIdToThemeId[_recipeId] = _themeId;
    }
*/ 

    function setMaxLevel(uint256 maxLevel_) public onlyOwner {
        CafeCosmosConfig.setMaxLevel(maxLevel_);
    }

    function setSoftCostPerSquare(uint256 softCost_) public onlyOwner {
       CafeCosmosConfig.setSoftCostPerSquare(softCost_);
    }

    function setCookingCost(uint256 cookingCost_) public onlyOwner {
        CafeCosmosConfig.setCookingCost(cookingCost_);
    }

    function setChunkSize(uint256 chunkSize) public onlyOwner {
        CafeCosmosConfig.setChunkSize(chunkSize);
    }

   
    function getSoftCostPerSquare() public view returns (uint256) {
        return CafeCosmosConfig.getSoftCostPerSquare();
    }

  

    function setItems(ItemInfoDTO[] memory items) public onlyOwner {
        for (uint256 i = 0; i < items.length; i++) {
            ItemInfo.set(items[i].itemId, items[i].itemInfo);
        }
    }

    function setIsStackable(uint256 _base, uint256 _input, bool _isStackable) public onlyOwner {
        StackableItem.setStackable(_base, _input, _isStackable);
    }

    function setStackableItems(StackableItemDTO[]  calldata stackableItems) public onlyOwner {
        for (uint256 i = 0; i < stackableItems.length; i++) {
            StackableItem.setStackable(stackableItems[i].base, stackableItems[i].input, stackableItems[i].stackable);
        }
    }

     function setReturnItems(uint256[] memory items, uint256[] memory itemsReturned) public onlyOwner {
        require(items.length == itemsReturned.length, "length mismatch");
        for (uint256 index = 0; index < items.length; index++) {
            ItemInfo.setReturnsItem(items[index], itemsReturned[index]);
        }
    } 

    function setReturnsItem(uint256 _itemId, uint256 _itemReturned) public onlyOwner {
         ItemInfo.setReturnsItem(_itemId, _itemReturned);
    }

    function getCookingCost() public view returns (uint256) {
        CafeCosmosConfig.getCookingCost();
    }

    function getActiveStoves(uint256 stoveId) public view returns (uint256) {
        return ActiveStoves.getTotalActiveStoves(stoveId);
    }
 

    function approveLandOperator(uint256 landId, address operator, bool status) public onlyLandOwner(landId){
        LandPermissions.setIsOperator(msg.sender, landId, operator, status);
    }

    function setMinStartingLimits(uint256 minStartingX, uint256 minStartingY) public onlyOwner {
       CafeCosmosConfig.setMinStartingX(minStartingX);
       CafeCosmosConfig.setMinStartingY(minStartingY);
    }

     function setNonRemovableItems(uint256[] calldata items) public onlyOwner {
        for (uint256 i = 0; i < items.length; i++) {
            setNonRemovable(items[i], true);
        }
    }

    function setNonRemovable(uint256 _nonRemovables, bool _removable) public onlyOwner {
        ItemInfo.setNonRemovable(_nonRemovables, _removable);
    }

    function setNonPlaceableItems(uint256[] calldata items) public onlyOwner {
        for (uint256 i = 0; i < items.length; i++) {
            setNonPlaceable(items[i], true);
        }
    }

    function setNonPlaceable(uint256 _nonPlaceable, bool _placeable) public onlyOwner {
        ItemInfo.setNonPlaceable(_nonPlaceable, _placeable);
    }

     // Tables & Chairs
    function setTable(uint256 _table, bool _isTable) public onlyOwner {
        ItemInfo.setIsTable(_table, _isTable);
    }

    function setChair(uint256 _chair, bool _isChair) public onlyOwner {
        ItemInfo.setIsChair(_chair, _isChair);
    }

    function setTool(uint256 _tool, bool _isTool) public onlyOwner {
        ItemInfo.setIsTool(_tool, _isTool);
    }

     function setRotatable(uint256[] memory _itemIds, bool _isRotatable) public onlyOwner {
        for (uint256 i = 0; i < _itemIds.length; i++) {
            uint256 itemId = _itemIds[i];
            ItemInfo.setIsRotatable(itemId, _isRotatable);
        }
    }

}
