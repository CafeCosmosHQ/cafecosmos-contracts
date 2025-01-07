
pragma solidity ^0.8.28;

struct CatalogueItemDTO {
    uint256 itemId;
    uint256 price;
    uint256 catalogueId;
    bool exists;
}

struct CatalogueItemPurchaseDTO {
    uint256 itemId;
    uint256 quantity;
}

struct LevelRewardDTO {
    uint256 level;
    uint256 tokens;
    uint256 cumulativeXp;
    uint256[] items;
}

