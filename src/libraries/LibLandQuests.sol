// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.24;

import { LibInventoryManagement } from "./LibInventoryManagement.sol";
import { LibLandManagement } from "./LibLandManagement.sol";
import { TaskType, RewardType } from "./LibQuests.sol";
import { LandInfo } from "../codegen/index.sol";

import { Quests, Quest, QuestData, QuestGroupData, QuestTaskData, QuestTask, LandQuest, LandQuestData, LandQuestGroups, LandQuestTaskProgress, LandQuestTaskProgressData, RewardData, QuestGroup, Reward, LandQuestGroup, LandQuestGroupData, QuestCollection, RewardCollection, TransformationCategories } from "../codegen/index.sol";

struct LandQuestGroupDTO {
    uint256 landId;
    uint questGroupId;
    LandQuestGroupData landQuestGroup;
    LandQuestDTO[] landQuests;
}

struct LandQuestDTO {
    uint256 landId;
    uint questGroupId;
    uint questId;
    LandQuestData landQuest;
    LandQuestTaskDTO[] landQuestTasks;
}

struct LandQuestTaskDTO {
    bytes32 taskId;
    uint256 landId;
    uint questGroupId;
    uint questId;
    uint taskType;
    bytes32 key;
    uint quantity;
    LandQuestTaskProgressData landQuestTask;
}

event LandQuestItemRewardClaimed(uint256 indexed landId, uint256 itemId, uint256 quantity);
event LandQuestXPRewardClaimed(uint256 indexed landId, uint256 xp);
event LandQuestCompleted(uint256 indexed landId, uint256 questGroupId, uint256 questId);
event LandQuestGroupCompleted(uint256 indexed landId, uint256 questGroupId);
event LandQuestTaskCompleted(uint256 indexed landId, uint256 questGroupId, uint256 questId, uint256 taskType, bytes32 key);


//keccak256("category") used to create a unique identifier for the category and avoid collision with transformation base and input type task
bytes32 constant CATEGORY_TASK = 0xbdd02474c81b92517571439fccee8195ec31f3b050bfdcd23d46928133a076c3;

library LibLandQuests {
    function getActiveLandQuestGroups(
        uint256 landId
    ) internal view returns (LandQuestGroupDTO[] memory activeQuestGroups) {
        //This will probably need to be changed to get the active quest groups (global) and then find the ones for the land (completd or not)
        //So they can be displayed in the UI
        //The ones that are not active will need to be activated by the user
        //TBC until the UI is implemented and we can see how the data is needed
        uint[] memory activeQuestGroupsIds = LandQuestGroups.getActiveQuestGroupIds(landId);
        activeQuestGroups = new LandQuestGroupDTO[](activeQuestGroupsIds.length);
        for (uint i = 0; i < activeQuestGroupsIds.length; i++) {
            uint questGroupId = activeQuestGroupsIds[i];
            activeQuestGroups[i] = getLandQuestGroup(landId, questGroupId);
        }
    }

    function getLandQuestGroup(uint256 landId, uint questGroupId) internal view returns (LandQuestGroupDTO memory landQuestGroupDTO) {
        LandQuestGroupData memory landQuestGroup = LandQuestGroup.get(landId, questGroupId);
        uint[] memory questIds = QuestGroup.getQuestIds(questGroupId);
        LandQuestDTO[] memory landQuests = new LandQuestDTO[](questIds.length);
        for (uint j = 0; j < questIds.length; j++) {
            uint questId = questIds[j];
            LandQuestData memory landQuest = LandQuest.get(landId, questGroupId, questId);
            bytes32[] memory taskKeys = Quest.getTasks(questId);
            //create LandQuestTaskDTOs using QuestTask quantity taskid and using  the values from the QuestTask to get the LandQuestTask
            LandQuestTaskDTO[] memory landQuestTasks = new LandQuestTaskDTO[](taskKeys.length);
            for (uint k = 0; k < taskKeys.length; k++) {
                bytes32 taskId = taskKeys[k];
                QuestTaskData memory questTaskData = QuestTask.get(taskId);
                uint quantity = questTaskData.quantity;
                LandQuestTaskProgressData memory landQuestTask = LandQuestTaskProgress.get(
                    landId,
                    questGroupId,
                    questId,
                    questTaskData.taskType,
                    questTaskData.key
                );
                landQuestTasks[k] = LandQuestTaskDTO(
                    taskId,
                    landId,
                    questGroupId,
                    questId,
                    questTaskData.taskType,
                    questTaskData.key,
                    quantity,
                    landQuestTask
                );
            }
            landQuests[j] = LandQuestDTO(landId, questGroupId, questId, landQuest, landQuestTasks);
        }
        return LandQuestGroupDTO(landId, questGroupId, landQuestGroup, landQuests);
    }

    function addActiveLandQuestGroup(uint256 landId, uint256 questGroupId) internal {
        uint256[] memory activeQuests = LandQuestGroups.getActiveQuestGroupIds(landId);
        // Check if the quest group is already active
        for (uint256 i = 0; i < activeQuests.length; i++) {
            require(activeQuests[i] != questGroupId, "LandQuestsSystem: Quest is already active");
        }

        LandQuestGroups.pushActiveQuestGroupIds(landId, questGroupId);
        LandQuestGroups.pushQuestGroupIds(landId, questGroupId);
    }

    function activateAllActiveQuestGroups(uint256 landId) internal {
        uint256[] memory questGroupIds = Quests.getActiveQuestGroups();
        for (uint256 i = 0; i < questGroupIds.length; i++) {
            activateLandQuestGroup(landId, questGroupIds[i]);
        }
    }

    function activateLandQuestGroup(uint256 landId, uint256 questGroupId) internal {
        LandQuestGroupData memory landQuestGroup = LandQuestGroup.get(landId, questGroupId);
        if (landQuestGroup.active || landQuestGroup.claimed) {
            return;
        }
        QuestGroupData memory questGroup = QuestGroup.get(questGroupId);
        require(
            questGroup.startsAt == 0 || (block.timestamp >= questGroup.startsAt),
            "QuestGroup is not started yet cannot be activated"
        );
        require(
            questGroup.expiresAt == 0 || (block.timestamp <= questGroup.expiresAt),
            "QuestGroup is expired cannot be activated"
        );
        landQuestGroup.active = true;
        landQuestGroup.expiresAt = questGroup.expiresAt;
        landQuestGroup.numberOfQuests = questGroup.questIds.length;
        landQuestGroup.numberOfCompletedQuests = 0;
        LandQuestGroup.set(landId, questGroupId, landQuestGroup);
        for (uint256 i = 0; i < questGroup.questIds.length; i++) {
            uint256 questId = questGroup.questIds[i];
            activateLandQuest(landId, questGroupId, questId);
        }
        addActiveLandQuestGroup(landId, questGroupId);
    }

    function activateLandQuest(uint256 landId, uint groupId, uint256 questId) internal {
        LandQuestData memory landQuest = LandQuest.get(landId, groupId, questId);
        if(landQuest.numberOfCompletedTasks > 0) return;
        QuestData memory questData = Quest.get(questId);
        //require(questData.startsAt == 0 || (block.timestamp >= questData.startsAt), "Quest is not started yet cannot be activated");
        //require(questData.expiresAt == 0 || (block.timestamp <= questData.expiresAt), "Quest is expired cannot be activated");
        //using duration instead of startsAt and expiresAt so that the quest can be activated at any time
        landQuest.active = true;
        landQuest.expiresAt = 0; //we are not using the expiresAt for now as we are using the duration and the daily and weekly quests are created on the fly
        landQuest.claimed = false;
        landQuest.numberOfCompletedTasks = 0;
        landQuest.numberOfTasks = questData.tasks.length;
        LandQuest.set(landId, groupId, questId, landQuest);
    }

    function removeActiveLandQuestGroup(uint256 landId, uint256 questGroupId) internal {
        uint256[] memory activeQuests = LandQuestGroups.getActiveQuestGroupIds(landId);
        uint256 length = activeQuests.length;

        // Early exit if array is empty
        require(length > 0, "LandQuestsSystem: No active quests");

        // Initialize a new array for the remaining active quests
        uint256[] memory newActiveQuests = new uint256[](length - 1);
        bool found = false;
        uint256 newIndex = 0;

        for (uint256 i = 0; i < length; i++) {
            if (activeQuests[i] != questGroupId) {
                // Only add non-matching quest group IDs to the new array
                newActiveQuests[newIndex] = activeQuests[i];
                newIndex++;
            } else {
                found = true;
            }
        }

        require(found, "LandQuestsSystem: Quest is not active");
        LandQuestGroup.setActive(landId, questGroupId, false); //ensure the quest group is deactivated
        // Set the new active quest group IDs
        LandQuestGroups.setActiveQuestGroupIds(landId, newActiveQuests);
    }

    function removeAllExpiredQuestGroups(uint256 landId) internal {
        uint256[] memory activeQuests = LandQuestGroups.getActiveQuestGroupIds(landId);
        uint256 length = activeQuests.length;
        uint256[] memory validQuests = new uint256[](length);
        uint256 validCount = 0;

        for (uint256 i = 0; i < length; i++) {
            uint expiresAt = LandQuestGroup.getExpiresAt(landId, activeQuests[i]);

            // If the quest has not expired, include it in the valid quests array
            if (expiresAt == 0 || expiresAt > block.timestamp) {
                validQuests[validCount] = activeQuests[i];
                validCount++;
            } else {
                // Mark the quest as inactive if it has expired
                LandQuestGroup.setActive(landId, activeQuests[i], false);
            }
        }
        // Resize the array to the number of valid quests found
        assembly {
            mstore(validQuests, validCount)
        }

        LandQuestGroups.setActiveQuestGroupIds(landId, validQuests);
    }

    function completeQuestGroupAndClaimReward(uint256 landId, uint256 questGroupId) internal {
        require(LandQuestGroup.getActive(landId, questGroupId), "LandQuestsSystem: Quest Group is not active");
        uint expiresAt = LandQuestGroup.getExpiresAt(landId, questGroupId);

        if (expiresAt == 0 || expiresAt > block.timestamp) {
            // Check if the quest has expired (if it has an expiration date)
            uint numberOfCompletedQuests = LandQuestGroup.getNumberOfCompletedQuests(landId, questGroupId);
            uint totalQuests = LandQuestGroup.getNumberOfQuests(landId, questGroupId);
            if (numberOfCompletedQuests >= totalQuests) {
                QuestGroupData memory questGroup = QuestGroup.get(questGroupId);
                for (uint256 i = 0; i < questGroup.rewardIds.length; i++) {
                    RewardData memory rewardData = Reward.get(questGroup.rewardIds[i]);
                    claimReward(rewardData, landId);
                }
                LandQuestGroup.setClaimed(landId, questGroupId, true);
                LandQuestGroup.setActive(landId, questGroupId, false);
                removeActiveLandQuestGroup(landId, questGroupId);
            }
        } else {
            LandQuestGroup.setActive(landId, questGroupId, false);
            emit LandQuestGroupCompleted(landId, questGroupId);
            removeActiveLandQuestGroup(landId, questGroupId);
        }
    }

    function claimReward(RewardData memory rewardData, uint256 landId) internal {
        if (rewardData.rewardType == uint(RewardType.Item)) {
            LibInventoryManagement.increaseQuantity(landId, rewardData.itemId, rewardData.quantity);
            emit LandQuestItemRewardClaimed(landId, rewardData.itemId, rewardData.quantity);
        }
        if (rewardData.rewardType == uint(RewardType.XP)) {
            LandInfo.setCumulativeXp(landId, LandInfo.getCumulativeXp(landId) + rewardData.quantity);
            emit LandQuestXPRewardClaimed(landId, rewardData.quantity);
        }

        /*
        if (rewardData.rewardType == uint(RewardType.SoftToken)) {
            //TODO: THIS IS JUST INCREASING THE AMOUNT OF SOFT TOKENS IN THE LAND, NOT THE SUPPLY ETC
            //WELL WE NEED TO FIGURE OUT WHAT TOKEN IS REWARDED ETC
            LibLandManagement.increaseLandTokenBalance(landId, rewardData.quantity);
        }*/
    }

    function completeQuestAndClaimReward(uint256 landId, uint questGroupId, uint256 questId) internal {
        require(LandQuest.getActive(landId, questGroupId, questId), "LandQuestsSystem: Quest is not active");
        uint expiresAt = LandQuest.getExpiresAt(landId, questGroupId, questId);

        if (expiresAt == 0 || expiresAt > block.timestamp) {
            // Check if the quest has expired (if it has an expiration date)
            uint numberOfCompletedTasks = LandQuest.getNumberOfCompletedTasks(landId, questGroupId, questId);
            uint totalTasks = LandQuest.getNumberOfTasks(landId, questGroupId, questId);

            if (numberOfCompletedTasks >= totalTasks) {
                QuestData memory questData = Quest.get(questId);
                for (uint256 i = 0; i < questData.rewardIds.length; i++) {
                    uint256 rewardId = questData.rewardIds[i];
                    RewardData memory rewardData = Reward.get(rewardId);
                    claimReward(rewardData, landId);
                }
                LandQuest.setClaimed(landId, questGroupId, questId, true);
                LandQuest.setActive(landId, questGroupId, questId, false);

                uint numberOfCompletedQuests = LandQuestGroup.getNumberOfCompletedQuests(landId, questGroupId);
                uint toltalNumberOfQuests = LandQuestGroup.getNumberOfQuests(landId, questGroupId);
                uint newNumberOfCompletedQuests = numberOfCompletedQuests + 1;
                LandQuestGroup.setNumberOfCompletedQuests(landId, questGroupId, newNumberOfCompletedQuests);
                if (newNumberOfCompletedQuests == toltalNumberOfQuests) {
                    completeQuestGroupAndClaimReward(landId, questGroupId); //buuble up to complete the quest group if all the other quests are completed and claim the quest group reward
                }
            }
        } else {
            // If the quest has expired but was not completed, deactivate it without giving the reward
            LandQuest.setActive(landId, questGroupId, questId, false);
            emit LandQuestCompleted(landId, questGroupId, questId);
            completeQuestGroupAndClaimReward(landId, questGroupId); //buble up to deactivate the quest group
        }
    }

    function incrementProgressTransform(uint256 landId, uint256 base, uint256 input) internal {
        // get categories for transformation and create task keys for each category and the transformation itself
        uint256[] memory categories = TransformationCategories.getCategories(base, input);

        bytes32[] memory taskKeys = new bytes32[](categories.length + 1);
        taskKeys[0] = keccak256(abi.encodePacked(base, input));
        for (uint i = 0; i < categories.length; i++) {
            uint256 category = categories[i];
            taskKeys[i + 1] = keccak256(abi.encodePacked(CATEGORY_TASK, category));
        }
        incrementProgressForAllActiveQuests(landId, uint256(TaskType.Transform), taskKeys);
    }

    function incrementProgressCraft(uint256 landId, uint256 outputItemId) internal {
        bytes32[] memory taskKeys = new bytes32[](1);
        taskKeys[0] = bytes32(outputItemId);
        incrementProgressForAllActiveQuests(landId, uint256(TaskType.Craft), taskKeys);
    }

    function incrementQuestProgressStackItem(uint256 landId, uint256 base, uint256 input) internal {
        bytes32[] memory taskKeys = new bytes32[](1);
        taskKeys[0] = keccak256(abi.encodePacked(base, input));
        incrementProgressForAllActiveQuests(landId, uint256(TaskType.Stack), taskKeys);
    }

    function incrementProgressCollectItem(uint256 landId, uint256 itemId) internal {
        bytes32[] memory taskKeys = new bytes32[](1);
        taskKeys[0] = bytes32(itemId);
        incrementProgressForAllActiveQuests(landId, uint256(TaskType.Collect), taskKeys);
    }

    function incrementProgressForAllActiveQuests(uint256 landId, uint256 taskType, bytes32[] memory taskKeys) internal {
        // Retrieve all active quest IDs for the given landId
        uint256[] memory activeQuestsGroupIds = LandQuestGroups.getActiveQuestGroupIds(landId);
        // Loop through each active quest ID
        for (uint256 i = 0; i < activeQuestsGroupIds.length; i++) {
            uint256 questGroupId = activeQuestsGroupIds[i];
            QuestGroupData memory questGroup = QuestGroup.get(questGroupId);

            // Check if the land quest group is completed or expired and deactivate them if needed
            if (questGroup.expiresAt != 0 && questGroup.expiresAt < block.timestamp) {
                // has expired
                
                LandQuestGroup.setActive(landId, questGroupId, false); //should not be completed as it was still active
                removeActiveLandQuestGroup(landId, questGroupId);
            }

            // Loop through each quest ID in the quest group
            for (uint256 j = 0; j < questGroup.questIds.length; j++) {
                uint256 questId = questGroup.questIds[j];
                // Increment the task progress for the current quest
                incrementTasksProgress(landId, questGroupId, questId, taskType, taskKeys);
            }
        }
    }

    function incrementTasksProgress(
        uint256 landId,
        uint questGroupId,
        uint256 questId,
        uint256 taskType,
        bytes32[] memory taskKey
    ) internal {
        for (uint i = 0; i < taskKey.length; i++) {
            bytes32 key = taskKey[i];
            incrementTaskProgress(landId, questGroupId, questId, taskType, key);
        }
    }

    function incrementTaskProgress(
        uint256 landId,
        uint questGroupId,
        uint256 questId,
        uint256 taskType,
        bytes32 taskKey
    ) internal {
        QuestTaskData memory questTask = QuestTask.get(keccak256(abi.encodePacked(questId, taskType, taskKey)));

        if (questTask.questId == 0) {
            // Task is not found
            return;
        }

        bool completed = LandQuestTaskProgress.getTaskCompleted(
            landId,
            questGroupId,
            questTask.questId,
            questTask.taskType,
            questTask.key
        );
        if (!completed) {
            uint progress = LandQuestTaskProgress.getTaskProgress(
                landId,
                questGroupId,
                questTask.questId,
                questTask.taskType,
                questTask.key
            );
            LandQuestTaskProgress.setTaskProgress(
                landId,
                questGroupId,
                questTask.questId,
                questTask.taskType,
                questTask.key,
                progress + 1
            );
            checkCompletionOfLandQuestTask(landId, questGroupId, questTask);
        }
    }

    function checkCompletionOfLandQuestTask(uint landId, uint questGroupId, QuestTaskData memory questTask) internal {
        uint progress = LandQuestTaskProgress.getTaskProgress(
            landId,
            questGroupId,
            questTask.questId,
            questTask.taskType,
            questTask.key
        );
        if (progress >= questTask.quantity) {
            bool completed = LandQuestTaskProgress.getTaskCompleted(
                landId,
                questGroupId,
                questTask.questId,
                questTask.taskType,
                questTask.key
            );
            if (!completed) {
                LandQuestTaskProgress.setTaskCompleted(
                    landId,
                    questGroupId,
                    questTask.questId,
                    questTask.taskType,
                    questTask.key,
                    true
                );
                emit LandQuestTaskCompleted(
                    landId,
                    questGroupId,
                    questTask.questId,
                    questTask.taskType,
                    questTask.key
                );
                uint numberOfCompletedTasks = LandQuest.getNumberOfCompletedTasks(
                    landId,
                    questGroupId,
                    questTask.questId
                );
                uint totalTasks = LandQuest.getNumberOfTasks(landId, questGroupId, questTask.questId);
                LandQuest.setNumberOfCompletedTasks(
                    landId,
                    questGroupId,
                    questTask.questId,
                    numberOfCompletedTasks + 1
                );
                if (numberOfCompletedTasks + 1 == totalTasks) {
                    completeQuestAndClaimReward(landId, questGroupId, questTask.questId);
                }
            }
        }
    }
}
