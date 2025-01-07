// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {System } from "@latticexyz/world/src/System.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {LibQuests} from "../libraries/LibQuests.sol";
import {Quests} from  "../codegen/index.sol";

contract QuestsSystem is System, RootAccessOperator {

   function createWeeklyQuestIfNotExists() public {
       LibQuests.createWeeklyQuestIfNotExists();
   }

   function createDailyQuestIfNotExists() public {
       LibQuests.createDailyQuestIfNotExists();
   }

   function getAllActiveQuestGroupIds() public view returns (uint256[] memory questGroupIds) {
       return Quests.getActiveQuestGroups();
   }

}