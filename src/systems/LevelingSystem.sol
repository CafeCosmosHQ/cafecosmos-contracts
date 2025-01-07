// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { LandInfo, ClaimedLevels, LevelReward, LevelRewardData, CafeCosmosConfig } from "../codegen/index.sol";
import { LibLandManagement } from "../libraries/LibLandManagement.sol";
import { LibInventoryManagement } from "../libraries/LibInventoryManagement.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { RootAccessOperator } from "./RootAccessOperator.sol";
import {LevelRewardDTO} from "../libraries/Types.sol";

contract LevelingSystem is System, RootAccessOperator {
   
    function unlockLevel(uint256 landId, uint256 level) public {
        require(level != 0, "LevelingSystem: level must be greater than 0");
        uint256 lastLevel = LandInfo.getLastLevelClaimed(landId);
        require(lastLevel == level - 1, "LevelingSystem: must claim your next level");
        require(ClaimedLevels.getClaimed(landId, level) == false, "LevelingSystem: level already claimed");
        LevelRewardData memory rewards = LevelReward.get(level);
        require(LandInfo.getCumulativeXp(landId) >= rewards.cumulativeXp, "LevelingSystem: insufficient XP to claim level");
        // LibLandManagement.increaseLandTokenBalance(landId, rewards.tokens);
        for (uint256 i = 0; i < rewards.items.length; i++) {
            LibInventoryManagement.increaseQuantity(landId, rewards.items[i], 1);
        }
        ClaimedLevels.setClaimed(landId, level, true);
        LandInfo.setLastLevelClaimed(landId, level);
    } 

    function unlockLevels(uint256 landId, uint256[] calldata levels) public {
        for (uint256 index = 0; index < levels.length; index++) {
            unlockLevel(landId, levels[index]);
        }
    }

    function unlockAllLevels(uint256 landId) public {
        uint256 lastLevel = LandInfo.getLastLevelClaimed(landId);
        uint256 maxLevel = CafeCosmosConfig.getMaxLevel();
        uint256 cumulativeXp = LandInfo.getCumulativeXp(landId);
        for (uint256 level = lastLevel + 1; level <= maxLevel; level++) {
            if (ClaimedLevels.getClaimed(landId, level) == false) {
                LevelRewardData memory rewards = LevelReward.get(level);
                if (cumulativeXp >= rewards.cumulativeXp) {
                    unlockLevel(landId, level);
                } else {
                    break;
                }
            }
        }
    }

    function upsertLevelRewards(LevelRewardDTO[] calldata levelRewards) public onlyOwner {
        for (uint256 index = 0; index < levelRewards.length; index++) {
            LevelRewardDTO calldata levelReward = levelRewards[index];
            upsertLevelReward(levelReward);
        }
    }

    function upsertLevelReward(LevelRewardDTO calldata levelReward) public onlyOwner {
        LevelRewardData memory data = LevelRewardData({
            cumulativeXp: levelReward.cumulativeXp,
            tokens: levelReward.tokens,
            items: levelReward.items
        });
        LevelReward.set(levelReward.level, data);
    }

    /*
    function calculateLevel(uint256 cumulativeXp) public view returns (uint256) {
        uint256 maxLevel = CafeCosmosConfig.getMaxLevel();
        for (uint256 level = 1; level <= maxLevel; level++) {
            uint256 xpNeeded = round(Math.sqrt(1 - ((level - 1)**2) / ((maxLevel - 1)**2)) * 1000, 10);
            if (cumulativeXp < xpNeeded) {
                return level - 1;
            }
            cumulativeXp -= xpNeeded;
        }
        
        return maxLevel;
    }

    function round(uint256 value, uint256 precision) internal pure returns (uint256) {
        return ((value + precision / 2) / precision) * precision;
    }
    */
}
