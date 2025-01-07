// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {LibLandQuests} from "../libraries/LibLandQuests.sol";
import {ILandQuestTaskProgressUpdate} from "./interfaces/ILandQuestTaskProgressUpdate.sol";

contract LandQuestTaskProgressUpdate is ILandQuestTaskProgressUpdate {

    function incrementProgressTransform(uint256 landId, uint256 base, uint256 input) external override {
        LibLandQuests.incrementProgressTransform(landId, base, input);
    }

    function incrementProgressCraft(uint256 landId, uint256 outputItemId) external override {
        LibLandQuests.incrementProgressCraft(landId, outputItemId);
    }

    function incrementQuestProgressStackItem(uint256 landId, uint256 base, uint256 input) override external {
        LibLandQuests.incrementQuestProgressStackItem(landId, base, input);
    }

    function incrementProgressCollectItem(uint256 landId, uint256 itemId) override external {
        LibLandQuests.incrementProgressCollectItem(landId, itemId);
    }

}

