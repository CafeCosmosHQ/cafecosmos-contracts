// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.4;

import { System } from "@latticexyz/world/src/System.sol";
import { LibInventoryManagement } from "./LibInventoryManagement.sol";
import { LibRandomSelection } from "./LibRandomSelection.sol";

import { Quests, Quest, QuestData, QuestGroupData, QuestTaskData, QuestTask, RewardData, QuestGroup, QuestGroupData, Reward, QuestCollection, RewardCollection, TransformationCategories } from "../codegen/index.sol";

struct TransformationWithCategoriesDTO {
    uint256 base;
    uint256 input;
    uint256[] categories;
}

struct QuestTaskDTO {
    bytes32 taskId;
    QuestTaskData task;
}

struct RewardDTO {
    uint256 id;
    RewardData reward;
}

struct QuestDTO {
    uint256 id;
    QuestData quest;
    QuestTaskDTO[] tasks;
    RewardDTO[] rewards;
}

struct QuestCollectionDTO {
    uint256 questGroupType;
    uint256[] questIds;
}

struct RewardCollectionDTO {
    uint256 rewardType;
    uint256[] rewardIds;
}

struct QuestGroupDTO {
    uint256 id;
    QuestGroupData questGroup;
    QuestDTO[] quests;
    RewardDTO[] rewards;
}

enum QuestGroupType {
    Daily,
    Weekly
}

enum TaskType {
    Craft,
    Transform,
    Collect,
    Stack
}

enum RewardType {
    Item,
    XP,
    SoftToken,
    HardToken
}

library LibQuests {
    function upsertTransformationCategories(
        TransformationWithCategoriesDTO[] calldata transformationsWithCategories
    ) internal {
        for (uint256 index = 0; index < transformationsWithCategories.length; index++) {
            TransformationCategories.set(
                transformationsWithCategories[index].base,
                transformationsWithCategories[index].input,
                transformationsWithCategories[index].categories
            );
        }
    }

    function getAllActiveQuestGroups() internal view returns (QuestGroupDTO[] memory questGroups) {
        uint[] memory activeQuestGroups = Quests.getActiveQuestGroups();
        questGroups = new QuestGroupDTO[](activeQuestGroups.length);
        for (uint256 index = 0; index < activeQuestGroups.length; index++) {
            questGroups[index] = getQuestGroup(activeQuestGroups[index]);
        }
    }

    function getQuestGroup(uint256 questGroupId) internal view returns (QuestGroupDTO memory questGroupDTO) {
        QuestGroupData memory questGroup = QuestGroup.get(questGroupId);
        questGroupDTO.id = questGroupId;
        questGroupDTO.questGroup = questGroup;
        questGroupDTO.quests = new QuestDTO[](questGroup.questIds.length);
        for (uint256 questIndex = 0; questIndex < questGroup.questIds.length; questIndex++) {
            QuestDTO memory quest = getQuest(questGroup.questIds[questIndex]);
            questGroupDTO.quests[questIndex] = quest;
        }
        questGroupDTO.rewards = new RewardDTO[](questGroup.rewardIds.length);
        for (uint256 rewardIndex = 0; rewardIndex < questGroup.rewardIds.length; rewardIndex++) {
            questGroupDTO.rewards[rewardIndex] = getReward(questGroup.rewardIds[rewardIndex]);
        }
        return questGroupDTO;
    }

    function upsertQuestCollections(QuestCollectionDTO[] calldata questCollections) internal {
        for (uint256 index = 0; index < questCollections.length; index++) {
            QuestCollection.setQuestIds(questCollections[index].questGroupType, questCollections[index].questIds);
        }
    }

    function upsertRewardCollections(RewardCollectionDTO[] calldata rewardCollections) internal {
        for (uint256 index = 0; index < rewardCollections.length; index++) {
            RewardCollection.setRewardIds(rewardCollections[index].rewardType, rewardCollections[index].rewardIds);
        }
    }

    function createDailyQuestIfNotExists() internal {
        removeExpiredDailyQuestGroups();
        //TODO: This is a temporary solution to remove expired quests as we only have daily quests
        //and we need to remove them to create new ones. This will be changed when we have more quest types
        uint256 questGroupId = getDailyQuestGroupId();
        if (questGroupId == 0) {
            (uint256 startOfDay, uint256 endOfDay) = getStartAndEndOfDayUTC();
            questGroupId = createDailyQuest(startOfDay, endOfDay);
            Quests.pushActiveQuestGroups(questGroupId);
        }
    }

    function removeExpiredDailyQuestGroups() internal {
        uint[] memory activeQuestGroups = Quests.getActiveQuestGroups();
        uint[] memory validQuestGroups = new uint[](activeQuestGroups.length);
        uint validIndex = 0;

        for (uint256 index = 0; index < activeQuestGroups.length; index++) {
            QuestGroupData memory questGroup = QuestGroup.get(activeQuestGroups[index]);

            // Check if it's a daily quest
            if (questGroup.questGroupType == uint(QuestGroupType.Daily)) {
                // If it's a daily quest, remove it if it's expired
                if (questGroup.expiresAt > block.timestamp) {
                    // Non-expired daily quest: store it
                    validQuestGroups[validIndex] = activeQuestGroups[index];
                    validIndex++;
                }
            } else {
                // Non-daily quest: always store it
                validQuestGroups[validIndex] = activeQuestGroups[index];
                validIndex++;
            }
        }
        // Resize array to the valid index
        uint[] memory filteredQuestGroups = new uint[](validIndex);
        for (uint256 i = 0; i < validIndex; i++) {
            filteredQuestGroups[i] = validQuestGroups[i];
        }

        Quests.setActiveQuestGroups(filteredQuestGroups);
    }

    function getDailyQuestGroupId() internal view returns (uint256) {
        uint[] memory activeQuestGroups = Quests.getActiveQuestGroups();
        for (uint256 index = 0; index < activeQuestGroups.length; index++) {
            QuestGroupData memory questGroup = QuestGroup.get(activeQuestGroups[index]);
            if (
                questGroup.startsAt <= block.timestamp && // Quest has already started
                questGroup.expiresAt > block.timestamp && // Quest has not yet expired
                questGroup.questGroupType == uint(QuestGroupType.Daily) // It's a daily quest
            ) {
                return activeQuestGroups[index];
            }
        }
        return 0;
    }

    function createDailyQuest(uint256 startsAt, uint256 expiresAt) internal returns (uint questGroupId) {
        uint256[] memory questIds = QuestCollection.getQuestIds(uint(QuestGroupType.Daily));
        uint256[] memory rewardIds = RewardCollection.getRewardIds(uint(QuestGroupType.Daily));
        uint256[] memory previousQuestIds = QuestCollection.getPreviousQuestIds(uint(QuestGroupType.Daily));
        questIds = LibRandomSelection.randomSelectionWithExclusions(questIds, 3, previousQuestIds);
        rewardIds = LibRandomSelection.randomSelection(rewardIds, 1);
        uint256[] memory updatedPreviousQuestsIds = updateRollingItems(previousQuestIds, questIds, 9);
        QuestCollection.setPreviousQuestIds(uint(QuestGroupType.Daily), updatedPreviousQuestsIds);
        return createQuestGroup(startsAt, expiresAt, uint(QuestGroupType.Daily), questIds, rewardIds);
    }

    function getStartAndEndOfDayUTC() public view returns (uint256 startOfDay, uint256 endOfDay) {
        // Get the current timestamp in UTC
        uint256 currentTime = block.timestamp;

        // Calculate the start of the day (00:00:00 UTC)
        startOfDay = (currentTime / 1 days) * 1 days;

        // Calculate the end of the day (23:59:59 UTC)
        endOfDay = startOfDay + 1 days - 1 seconds;

        return (startOfDay, endOfDay);
    }

    function createWeeklyQuestIfNotExists() internal {
        uint256 questGroupId = getWeeklyQuestGroupId();
        if (questGroupId == 0) {
            (uint256 startOfWeek, uint256 endOfWeek) = getStartAndEndofWeekUTC();
            questGroupId = createWeeklyQuest(startOfWeek, endOfWeek);
            Quests.pushActiveQuestGroups(questGroupId);
        }
    }

    function getStartAndEndofWeekUTC() public view returns (uint256 startOfWeek, uint256 endOfWeek) {
        // Get the current timestamp in UTC
        uint256 currentTime = block.timestamp;

        // Calculate the number of seconds since the start of the week (Sunday 00:00:00 UTC)
        // Add 4 days to adjust from Thursday (Unix epoch start) to Sunday
        uint256 secondsSinceStartOfWeek = (currentTime + 4 days) % 1 weeks;

        // Calculate the start of the week (Sunday 00:00:00 UTC)
        startOfWeek = currentTime - secondsSinceStartOfWeek;

        // Calculate the end of the week timestamp (Saturday 23:59:59 UTC)
        endOfWeek = startOfWeek + 1 weeks - 1 seconds;

        return (startOfWeek, endOfWeek);
    }

    function updateRollingItems(
        uint256[] memory previousItems, // Previous items in memory
        uint256[] memory newItems, // Newly selected items in memory
        uint256 maxItemsToKeep // Maximum number of items to keep in the rolling window
    ) internal pure returns (uint256[] memory) {
        uint256 previousLength = previousItems.length;
        uint256 newLength = newItems.length;

        // If the new items cause the total to exceed maxItemsToKeep, remove the oldest items
        uint256 excessItems = (previousLength + newLength > maxItemsToKeep)
            ? (previousLength + newLength - maxItemsToKeep)
            : 0;

        // Calculate the size of the resulting array after removal
        uint256 resultingLength = previousLength + newLength - excessItems;
        uint256[] memory updatedItems = new uint256[](resultingLength);

        // Copy over the remaining previous items (after removing the oldest)
        for (uint256 i = excessItems; i < previousLength; i++) {
            updatedItems[i - excessItems] = previousItems[i];
        }

        // Append the new items
        for (uint256 i = 0; i < newLength; i++) {
            updatedItems[previousLength - excessItems + i] = newItems[i];
        }

        return updatedItems; // Return the updated array
    }

    function createWeeklyQuest(uint256 startsAt, uint256 expiresAt) internal returns (uint questGroupId) {
        uint256[] memory questIds = QuestCollection.getQuestIds(uint(QuestGroupType.Weekly));
        uint256[] memory rewardIds = RewardCollection.getRewardIds(uint(QuestGroupType.Weekly));
        questIds = LibRandomSelection.randomSelection(questIds, 2);
        rewardIds = LibRandomSelection.randomSelection(rewardIds, 1);
        return createQuestGroup(startsAt, expiresAt, uint(QuestGroupType.Weekly), questIds, rewardIds);
    }

    function createQuestGroup(
        uint256 startsAt,
        uint256 expiresAt,
        uint256 questType,
        uint256[] memory questIds,
        uint256[] memory rewardIds
    ) internal returns (uint256 questGroupId) {
        questGroupId = Quests.getNumberOfQuestsGroups() + 1;
        QuestGroupData memory questGroup = QuestGroupData({
            startsAt: startsAt,
            expiresAt: expiresAt,
            sequential: false,
            questGroupType: questType,
            questIds: questIds,
            rewardIds: rewardIds
        });
        QuestGroup.set(questGroupId, questGroup);
        Quests.setNumberOfQuestsGroups(questGroupId);
    }

    function getWeeklyQuestGroupId() internal view returns (uint256) {
        uint[] memory activeQuestGroups = Quests.getActiveQuestGroups();
        for (uint256 index = 0; index < activeQuestGroups.length; index++) {
            QuestGroupData memory questGroup = QuestGroup.get(activeQuestGroups[index]);
            if (
                questGroup.expiresAt <= block.timestamp &&
                questGroup.startsAt >= block.timestamp &&
                questGroup.questGroupType == uint(QuestGroupType.Weekly)
            ) {
                return activeQuestGroups[index];
            }
        }
        return 0;
    }

    function getDailyQuest() internal view returns (QuestGroupDTO memory questGroupDTO) {
        uint[] memory activeQuestGroups = Quests.getActiveQuestGroups();
        for (uint256 index = 0; index < activeQuestGroups.length; index++) {
            QuestGroupData memory questGroup = QuestGroup.get(activeQuestGroups[index]);
            if (
                questGroup.expiresAt <= block.timestamp &&
                questGroup.startsAt >= block.timestamp &&
                questGroup.questGroupType == uint(QuestGroupType.Daily)
            ) {
                questGroupDTO.id = activeQuestGroups[index];
                questGroupDTO.questGroup = questGroup;
                for (uint256 questIndex = 0; questIndex < questGroup.questIds.length; questIndex++) {
                    QuestDTO memory quest = getQuest(questGroup.questIds[questIndex]);
                    questGroupDTO.quests[questIndex] = quest;
                }
                for (uint256 rewardIndex = 0; rewardIndex < questGroup.rewardIds.length; rewardIndex++) {
                    questGroupDTO.rewards[rewardIndex] = getReward(questGroup.rewardIds[rewardIndex]);
                }
                return questGroupDTO;
            }
        }
    }

    function getWeeklyQuest() internal view returns (QuestGroupDTO memory questGroupDTO) {
        uint[] memory activeQuestGroups = Quests.getActiveQuestGroups();
        for (uint256 index = 0; index < activeQuestGroups.length; index++) {
            QuestGroupData memory questGroup = QuestGroup.get(activeQuestGroups[index]);
            if (
                questGroup.expiresAt <= block.timestamp &&
                questGroup.startsAt >= block.timestamp &&
                questGroup.questGroupType == uint(QuestGroupType.Weekly)
            ) {
                questGroupDTO.id = activeQuestGroups[index];
                questGroupDTO.questGroup = questGroup;
                for (uint256 questIndex = 0; questIndex < questGroup.questIds.length; questIndex++) {
                    QuestDTO memory quest = getQuest(questGroup.questIds[questIndex]);
                    questGroupDTO.quests[questIndex] = quest;
                }
                for (uint256 rewardIndex = 0; rewardIndex < questGroup.rewardIds.length; rewardIndex++) {
                    questGroupDTO.rewards[rewardIndex] = getReward(questGroup.rewardIds[rewardIndex]);
                }
                return questGroupDTO;
            }
        }
    }

    function getReward(uint256 rewardId) internal view returns (RewardDTO memory rewardDTO) {
        rewardDTO.id = rewardId;
        rewardDTO.reward = Reward.get(rewardId);
        return rewardDTO;
    }

    function addReward(RewardDTO memory reward) internal {
        uint numberOfRewards = Quests.getNumberOfRewards();
        if (reward.id > numberOfRewards) {
            Quests.setNumberOfRewards(reward.id);
        }
        Reward.set(reward.id, reward.reward);
    }

    function addRewards(RewardDTO[] calldata rewards) internal {
        for (uint256 index = 0; index < rewards.length; index++) {
            RewardDTO memory reward = rewards[index];
            addReward(reward);
        }
    }

    function addQuests(QuestDTO[] calldata quests) internal {
        for (uint256 index = 0; index < quests.length; index++) {
            QuestDTO memory questDTO = quests[index];
            addQuest(questDTO);
        }
    }

    function addQuest(QuestDTO memory questDTO) internal {
        //add validation
        //uint numberOfQuets = Quests.getNumberOfQuests();
        //uint questId = numberOfQuets + 1;
        uint questId = questDTO.id;
        //require(questDTO.id == questId, "Quest id is not valid");
        Quest.set(questId, questDTO.quest);
        for (uint256 index = 0; index < questDTO.tasks.length; index++) {
            QuestTaskData memory task = questDTO.tasks[index].task;
            bytes32 taskId = questDTO.tasks[index].taskId;

            require(task.questId == questId, "Quest id in Task is not valid");
            require(questDTO.quest.tasks[index] == taskId, "Task id is not valid");
            require(taskId == keccak256(abi.encodePacked(questId, task.taskType, task.key)), "Task id is not valid");

            QuestTask.set(taskId, task);
        }
        Quests.setNumberOfQuests(questId);
    }

    function getQuest(uint256 questId) internal view returns (QuestDTO memory questDTO) {
        questDTO.quest = Quest.get(questId);
        questDTO.id = questId;
        questDTO.tasks = new QuestTaskDTO[](questDTO.quest.tasks.length);
        for (uint256 taskIndex = 0; taskIndex < questDTO.quest.tasks.length; taskIndex++) {
            bytes32 taskId = questDTO.quest.tasks[taskIndex];
            questDTO.tasks[taskIndex].taskId = taskId;
            questDTO.tasks[taskIndex].task = QuestTask.get(taskId);
        }
        questDTO.rewards = new RewardDTO[](questDTO.quest.rewardIds.length);
        for (uint256 rewardIndex = 0; rewardIndex < questDTO.quest.rewardIds.length; rewardIndex++) {
            questDTO.rewards[rewardIndex] = getReward(questDTO.quest.rewardIds[rewardIndex]);
        }
        return questDTO;
    }

    function getAllQuests() internal view returns (QuestDTO[] memory quests) {
        uint256 numberOfQuests = Quests.getNumberOfQuests();
        quests = new QuestDTO[](numberOfQuests);
        for (uint256 index = 0; index < numberOfQuests; index++) {
            quests[index] = getQuest(index + 1);
        }
    }
}
