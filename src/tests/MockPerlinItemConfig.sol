// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IPerlinItemConfig.sol";
import "../Perlin.sol";

// Maps the perlin values to ERC1155 itemIds
contract MockPerlinItemConfig is Ownable, IPerlinItemConfig {

       // Mapping from uint256 to uint256
    mapping(uint256 => mapping(uint256 => uint256)) public items;

    // Function to set a value for a given key
    // Now only callable by the owner
    function setItem(uint256 groupId, uint256 perlin, uint256 itemId) external override onlyOwner {
        items[groupId][perlin] = itemId;
    }

    function setItems(PerlinConfig[] calldata perlinConfigs) external override onlyOwner {
        // for (uint256 i = 0; i < perlinConfigs.length; i++) {
        //     items[perlinConfigs[i].groupId][perlinConfigs[i].perlinId] = perlinConfigs[i].itemId;
        // }
    }

    // Function to get the value of a given key
    function getItem(uint groupId, uint256 perlin) external view override returns (uint256) {
        return items[groupId][perlin];
    }

    function calculatePerlinAndGetItem(uint256 x, uint256 y, uint256 seed) external view override returns (uint256) {
        return 0;
    }

    function calculatePerlin(uint256 x, uint256 y, uint256 seed) public pure override returns (uint256) {
        return 0;
    }

     function calculatePerlinGroupId(uint256 x, uint256 y, uint256 seed) public pure returns (uint256) {
        return 0;
    }


}
