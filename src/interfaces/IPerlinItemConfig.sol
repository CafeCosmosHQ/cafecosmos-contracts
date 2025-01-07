// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPerlinItemConfig {
    struct PerlinConfig {
        uint256 groupId;
        uint256 perlinId;
        uint256 itemId;
    }
    function setItem(uint256 groupId, uint256 perlin, uint256 itemId) external;
    function setItems(PerlinConfig[] calldata perlinConfigs) external;
    function getItem(uint groupId, uint256 perlin) external view returns (uint256);
    function calculatePerlinAndGetItem(uint256 x, uint256 y, uint256 seed) external view returns (uint256);
    function calculatePerlin(uint256 x, uint256 y, uint256 seed) external view returns (uint256);
}