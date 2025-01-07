// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import "./interfaces/ILandTransform.sol";
import {LibLandManagement} from "../libraries/LibLandManagement.sol";
import {LibLandAccess} from "../libraries/LibLandAccess.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import {LibSafeMath } from "../libraries/LibSafeMath.sol";
import {LibLandAccess } from "../libraries/LibLandAccess.sol";
import "../interfaces/IRedistributor.sol"; 
import "../interfaces/IVesting.sol";
import "../interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import {LibToken} from "../libraries/LibToken.sol";
import {CafeCosmosConfig, ConfigAddresses, LandInfo, LandInfoData, LandItem, LandItemData, LandItemCookingState, ActiveStoves, WaterController, LandItemCookingStateData, ItemInfo, TransformationsData, PlayerTotalEarned} from  "../codegen/index.sol";

contract LandTransform is ILandTransform {

    uint256 constant _MAGNIFIER = 1e5;
    using LibSafeMath for uint256;

    function transform(uint256 landId, uint256 x, uint256 y, uint256 input, TransformationsData memory config) public override {
        uint256 base = LibLandManagement.getItemAt(landId, x, y);
        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
        LandItemData memory landSlot = LandItem.get(landId, x, y, z);
        uint yieldShares = LandItemCookingState.getYieldShares(landId, x, y, z);

        if (landSlot.dynamicUnlockTimes > 0) {  
            config.unlockTime = landSlot.dynamicUnlockTimes;
            config.timeout = landSlot.dynamicTimeoutTimes;
            require(config.unlockTime < config.timeout || config.timeout == 0, "error: unlock time must be less than timeout");
        } if (config.isRecipe) {
            _handleRecipe(landId, x, y, input, base, config);
        } else if (input == 0 && yieldShares > 0) {
           _handleUnlockRecipe(landId, x, y, config, landSlot.placementTime);
        } else if (config.unlockTime == 0 && ItemInfo.getIsTool(input)) {
           _handleToolUsage(landId, x, y, input, config);
        } else if (config.unlockTime == 0) {
           _handleNoUnlockTime(landId, x, y, input, config);
        } else {
           _handleUnlockTime(landId, x, y, input, config, landSlot.placementTime);
        }
    }

     function _handleRecipe(
        uint256 landId,
        uint256 x,
        uint256 y,
        uint256 input,
        uint256 base,
        TransformationsData memory config
    ) internal {
     
        LandInfoData memory landInfo = LandInfo.get(landId);
        uint256 totalActiveStoves = ActiveStoves.getTotalActiveStoves(base);

        require(landInfo.activeTables > 0, "you don't have any active tables");
        LibInventoryManagement.burn(landId, input, 1);

        LibLandManagement.setItemAt(landId, x, y, config.next);
        
        uint256 _shares = calculateShares(
            landId,
            totalActiveStoves + 1,
            landInfo.activeTables,
            input
        );
        IRedistributor(ConfigAddresses.getRedistributorAddress()).mintShares(input, _shares);

        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
        LandItemCookingState.setYieldShares(landId, x, y, z, _shares);
        LandItemCookingState.setRecipeId(landId, x, y, z, input);
        LandItemCookingState.setStoveId(landId, x, y, z, base);
        LandInfo.setActiveStoves(landId, landInfo.activeStoves + 1);
        ActiveStoves.setTotalActiveStoves(base, totalActiveStoves + 1);
    }

    function _handleUnlockRecipe(
        uint256 landId,
        uint256 x,
        uint256 y,
        TransformationsData memory config,
        uint256 placementTime
    ) internal {
        if (
            block.timestamp > (placementTime + config.unlockTime) && block.timestamp < (placementTime + config.timeout)
        ) {
            _unlockDividend(landId, x, y, config);
        } else if (block.timestamp < (placementTime + config.unlockTime)) {
            revert("Not unlocked yet");
        } else if (block.timestamp > (placementTime + config.timeout)) {
            _timeoutDividend(landId, x, y, config);
        } 
    }

    function _handleToolUsage(
        uint256 landId,
        uint256 x,
        uint256 y,
        uint256 input,
        TransformationsData memory config
    ) internal {
        require(LibInventoryManagement.itemBalanceOf(landId, input) > 0, "you don't have this tool");
        if (config.yield != 0) {
            LibInventoryManagement.mint(landId, config.yield, config.yieldQuantity);
        }
        LibLandManagement.setItemAt(landId, x, y, config.next);
    }

    function _handleNoUnlockTime(
        uint256 landId,
        uint256 x,
        uint256 y,
        uint256 input,
        TransformationsData memory config
    ) internal {
        if (input != 0) {
            LibInventoryManagement.burn(landId, input, 1);
        }
        if (config.yield != 0) {
            LibInventoryManagement.mint(landId, config.yield, config.yieldQuantity);
        }
        
        if(config.inputNext != 0){
            LibInventoryManagement.mint(landId, config.inputNext, 1);
        }
        
        LibLandManagement.setItemAt(landId, x, y, config.next);
        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
         if(config.isWaterCollection){
            require(LandItem.getDynamicUnlockTimes(landId, x, y, z) == 0, "error: overlapping water collection times");
            uint256 waterYieldTime = WaterController.getWaterYieldTime();
            LandItem.setDynamicUnlockTimes(landId, x, y, z, waterYieldTime);
            if(config.timeout > 0){
                LandItem.setDynamicUnlockTimes(landId, x, y, z, config.timeout + waterYieldTime);
            }
        }
    }

    function _handleUnlockTime(
        uint256 landId,
        uint256 x,
        uint256 y,
        uint256 input,
        TransformationsData memory config,
        uint256 placementTime
    ) internal {
        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
        LandItemData memory item = LandItem.get(landId, x, y, z);
        bool dynamicTimesExist =  item.dynamicUnlockTimes > 0;
        uint256 unlockTime = dynamicTimesExist ? item.dynamicUnlockTimes : config.unlockTime;
        uint256 timeout = dynamicTimesExist ? item.dynamicTimeoutTimes : config.timeout;

        if (
            block.timestamp > (placementTime + unlockTime) &&
            ((block.timestamp < (placementTime + timeout)) || timeout == 0)
        ) {
            _unlockYield(landId, x, y, input, config);
            if(dynamicTimesExist) _clearDynamicTimes(landId, x, y); // && config.yield > 0
        } else if (block.timestamp > (placementTime + timeout) && timeout != 0) {
            _timeoutYield(landId, x, y, config);
            if(dynamicTimesExist) _clearDynamicTimes(landId, x, y); // && config.yield > 0
        } else if (block.timestamp <= (placementTime + unlockTime)) {
            revert ILandTransform.notUnlockedYet({
                timeNow: block.timestamp,
                unlockTime: placementTime + unlockTime,
                x: x,
                y: y
            });
        } else {
            revert("Transformation: no valid unlock found");
        }

         if(config.inputNext != 0){
            LibInventoryManagement.mint(landId, config.inputNext, 1);
        }
    }

    function _clearDynamicTimes(uint256 landId, uint256 x, uint256 y) internal {
        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
        LandItem.setDynamicUnlockTimes(landId, x, y, z, 0);
        LandItem.setDynamicTimeoutTimes(landId, x, y, z, 0);
    }

    function _unlockDividend(
        uint256 landId,
        uint256 x,
        uint256 y,
        TransformationsData memory config
    ) internal {
        address landOwner = LibLandAccess.getLandOwner(landId);
        IRedistributor redistributor = IRedistributor(ConfigAddresses.getRedistributorAddress());
        IVesting vesting = IVesting(ConfigAddresses.getVestingAddress());
        vesting.release();
        redistributor.redistributeFunds();
        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
        LandItemCookingStateData memory landItemCookingState = LandItemCookingState.get(landId, x, y, z);
        uint256 div = redistributor.withdrawFunds(landItemCookingState.recipeId, landItemCookingState.yieldShares);
        
        //TRANSFER div to land owner
        if(div > 0) {
            LibToken.withdrawEthAndTransferToLandOwner(landId, div);
            PlayerTotalEarned.setTotalEarned(landId, PlayerTotalEarned.getTotalEarned(landId) + div);
        }

        LibLandManagement.setItemAt(landId, x, y, config.next);
        LandInfo.setActiveStoves(landId, LandInfo.getActiveStoves(landId) - 1);

        LandItemCookingState.deleteRecord(landId, x, y, z);
    }

    function _timeoutDividend(
        uint256 landId,
        uint256 x,
        uint256 y,
        TransformationsData memory config
    ) internal {
        IRedistributor redistributor = IRedistributor(ConfigAddresses.getRedistributorAddress());
        uint256 cookingCost = CafeCosmosConfig.getCookingCost();
        uint z = LibLandManagement.getLastItemInStackOrZero(landId, x, y);
        LandItemCookingStateData memory landItemCookingState = LandItemCookingState.get(landId, x, y, z);
        if(config.timeoutYield != 0) {
            LibInventoryManagement.mint(landId, config.timeoutYield, 1);
        }
        redistributor.burnShares(
           landItemCookingState.recipeId, 
           landItemCookingState.yieldShares);

        LibLandManagement.setItemAt(landId, x, y, config.next);
        // if(landItemCookingState.collateral > 0) {
        //     LibLandManagement.increaseLandTokenBalance(landId, cookingCost);
        // }
        LandInfo.setActiveStoves(landId, LandInfo.getActiveStoves(landId) - 1);
        LandItemCookingState.deleteRecord(landId, x, y, z);
    }

    function _unlockYield(
        uint256 landId,
        uint256 x,
        uint256 y,
        uint256 input,
        TransformationsData memory config
    ) internal {
        if (input != 0 && !ItemInfo.getIsTool(input)) {
            LibInventoryManagement.burn(landId, input, 1);
        }
        _yield(landId, x, y, config.yield, config.yieldQuantity, config.next);
    }

    function _yield(uint256 landId, uint256 x, uint256 y, uint256 yield, uint256 quantity, uint256 next) private {
        if (yield != 0) {
            LibInventoryManagement.mint(landId, yield, quantity);
        }
        LibLandManagement.setItemAt(landId, x, y, next);
    }

    function _timeoutYield(
        uint256 landId,
        uint256 x,
        uint256 y,
        TransformationsData memory config
    ) internal {
        _yield(landId, x, y, config.timeoutYield, config.timeoutYieldQuantity, config.timeoutNext);
    }

     function calculateShares(
        uint256 landId,
        uint256 activeStoves_,
        uint256 activeTables_,
        uint256 recipeId_
    ) internal view returns (uint256) {
        require(activeStoves_ > 0, "no active stoves of this type");

        uint256 effectiveBoost = calculateBooster(landId, recipeId_);
        uint256 magnifierWithBoost = _MAGNIFIER.mul(10000 + effectiveBoost).div(10000);
        uint256 stoveFactor = Math.sqrt(activeStoves_);
        unchecked {
            return magnifierWithBoost.mul(activeTables_).div(stoveFactor);
        }
    }

    function calculateBooster(uint256 landId, uint256 recipeId_) internal view returns (uint256) 
    {
        /*
        uint256 themeId = ls().itemIdToThemeId[recipeId_];
        if (themeId == 0) {
            return 0;
        }
        uint256 localBooster = 0;
        for (uint256 i = 0; i < 7; i++) {
            localBooster += Math.min(ls().lands[landId].boosters[themeId][i], ls().categoryMaxBoost[i]);
        }
        localBooster = Math.min(localBooster, ls().maxBoosts[0]);
        uint256 globalBooster = Math.min(ls().lands[landId].boosters[GLOBAL_BOOSTER_ID][0], ls().maxBoosts[1]);
        return Math.min(globalBooster + localBooster, ls().maxBoosts[2]);
        */
    }
}
