// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

interface ILandQuestTaskProgressUpdate {
    function incrementProgressTransform(uint256 landId, uint256 base, uint256 input) external;
    function incrementProgressCraft(uint256 landId, uint256 outputItemId) external;
    function incrementQuestProgressStackItem(uint256 landId, uint256 base, uint256 itemId) external;
    function incrementProgressCollectItem(uint256 landId, uint256 itemId) external;
}