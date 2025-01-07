// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {ItemInfoData, PlayerTotalEarnedData} from  "../codegen/index.sol";
 
struct LandItemDTO {    
    uint256 x;
    uint256 y;
    uint256 itemId;
    uint256 placementTime;
    uint256 stackIndex;
    bool isRotated;
    uint256 dynamicUnlockTime;
    uint256 dynamicTimeoutTime;
}


struct PlayerTotalEarnedDTO {
    uint256 landId;
    uint256 totalEarned;
    uint256 totalSpent;
}

struct ItemInfoDTO
{
    uint256 itemId;
    ItemInfoData itemInfo;
}

struct StackableItemDTO
{
    uint256 base;
    uint256 input;
    bool stackable;
}
