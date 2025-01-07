// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

struct CraftingRecipeDTO {
    uint256 output;
    uint256 outputQuantity;
    uint256 xp;
    bool exists;
    uint256[] inputs;
    uint256[] quantities;
}

struct CraftingStorage {
    mapping(bytes32 => uint256) craftingRecipe;
    mapping(uint256 => uint256) returnsItem;
}

library LibCraftingStorage {
    
    bytes32 constant CRAFTING_STORAGE_POSITION = keccak256("visioncontracts.crafting.storage");

    function cs() internal pure returns (CraftingStorage storage craftingStorage) {
        bytes32 position = CRAFTING_STORAGE_POSITION;
        assembly {
            craftingStorage.slot := position
        }
    }
}
