// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {System } from "@latticexyz/world/src/System.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {LibLandQuests, LandQuestGroupDTO} from "../libraries/LibLandQuests.sol";

contract LandQuestsSystem is System, LandAccessOperator {

    function activateLandQuestGroup(uint256 landId, uint256 questGroupId) public onlyLandOperator(landId) {
        LibLandQuests.activateLandQuestGroup(landId, questGroupId);
    }

    function removeAllExpiredQuestGroups(uint256 landId) public onlyLandOperator(landId) {
        LibLandQuests.removeAllExpiredQuestGroups(landId);
    }

    function getActiveLandQuestGroups(uint256 landId) public view returns (LandQuestGroupDTO[] memory) {
        return LibLandQuests.getActiveLandQuestGroups(landId);
    }

    function getLandQuestGroup(uint256 landId, uint256 questGroupId) public view returns (LandQuestGroupDTO memory) {
        return LibLandQuests.getLandQuestGroup(landId, questGroupId);
    }
    
    function activateAllQuestGroups(uint256 landId) public onlyLandOperator(landId) {
        LibLandQuests.activateAllActiveQuestGroups(landId);
    }

}
   