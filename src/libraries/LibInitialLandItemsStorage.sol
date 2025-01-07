// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

//InitialLandItem is used to initialize the land on creation with preconfigured default items
struct InitialLandItem {
        uint256 x;
        uint256 y;
        uint256 z;
        uint256 itemId;
        bool rotated;
}


struct InitialLandItemsStorage{
    mapping (uint => mapping(uint => InitialLandItem[])) initialLandItems; //land type, perlin number, initialLandItems
    mapping( uint => uint) initialLandItemsDefaultIndex; 
    mapping (address => bool) isLandCreatedWithDefaultItems;
}

library LibInitialLandItemsStorage {
    
    bytes32 constant INITIALLANDITEM_STORAGE_POSITION = keccak256("visioncontracts.intiallanditem.storage");

    function st() internal pure returns (InitialLandItemsStorage storage initialLandItemsStorage) {
        bytes32 position = INITIALLANDITEM_STORAGE_POSITION;
        assembly {
            initialLandItemsStorage.slot := position
        }
    }
}

