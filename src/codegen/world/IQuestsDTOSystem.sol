// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { QuestDTO, QuestGroupDTO, QuestCollectionDTO, RewardCollectionDTO, TransformationWithCategoriesDTO, RewardDTO } from "../../libraries/LibQuests.sol";
import { QuestData } from "../index.sol";

/**
 * @title IQuestsDTOSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IQuestsDTOSystem {
  function getQuest(uint256 questId) external view returns (QuestDTO memory questDTO);

  function getAllQuests() external view returns (QuestDTO[] memory quests);

  function getAllActiveQuestGroups() external view returns (QuestGroupDTO[] memory questGroups);

  function addNewQuests(QuestDTO[] calldata quests) external;

  function addNewQuest(QuestDTO calldata questDTO) external;

  function updateQuest(uint256 questId, QuestData calldata quest) external;

  function upsertQuestCollections(QuestCollectionDTO[] calldata questCollections) external;

  function upsertRewardColletions(RewardCollectionDTO[] calldata rewardCollections) external;

  function upsertTransformationCategories(TransformationWithCategoriesDTO[] calldata transformationCategories) external;

  function addRewards(RewardDTO[] calldata rewardDTO) external;
}
