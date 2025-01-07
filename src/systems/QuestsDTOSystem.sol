// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {System } from "@latticexyz/world/src/System.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {QuestDTO, QuestCollectionDTO, RewardCollectionDTO, RewardDTO, LibQuests, QuestGroupDTO, TransformationWithCategoriesDTO} from "../libraries/LibQuests.sol";

import {QuestData, Quest, Quests} from  "../codegen/index.sol";

contract QuestsDTOSystem is System, RootAccessOperator {

    function getQuest(uint256 questId) public view returns (QuestDTO memory questDTO) {
       return LibQuests.getQuest(questId);
    }

    function getAllQuests() public view returns (QuestDTO[] memory quests) {
       return LibQuests.getAllQuests();
    }

   function getAllActiveQuestGroups() public view returns (QuestGroupDTO[] memory questGroups) {
       return LibQuests.getAllActiveQuestGroups();
   }

   function addNewQuests(QuestDTO[] calldata quests) public onlyOwner {
       LibQuests.addQuests(quests);
    }

    function addNewQuest(QuestDTO calldata questDTO) public onlyOwner {
      LibQuests.addQuest(questDTO);
    }

    function updateQuest(uint256 questId, QuestData calldata quest) public onlyOwner {
        Quest.set(questId, quest);
    }

    function upsertQuestCollections(QuestCollectionDTO[] calldata questCollections)  public onlyOwner {
       LibQuests.upsertQuestCollections(questCollections);
    }

    function upsertRewardColletions(RewardCollectionDTO[] calldata rewardCollections) public onlyOwner {
       LibQuests.upsertRewardCollections(rewardCollections);
   }

    function upsertTransformationCategories(TransformationWithCategoriesDTO[] calldata transformationCategories) public onlyOwner {
        LibQuests.upsertTransformationCategories(transformationCategories);
    }

   function addRewards(RewardDTO[] calldata rewardDTO) public onlyOwner {
      LibQuests.addRewards(rewardDTO);
   }

}