// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPerlinItemConfig.sol";
import {PerlinV2} from "./Perlin.sol";

// Maps the perlin values to ERC1155 itemIds
contract PerlinItemConfig is Ownable, IPerlinItemConfig {

    uint public maxGroupIdNumber = 0;
    // Mapping from uint256 to uint256
    mapping(uint256 => mapping(uint256 => uint256)) public items;

    // Function to set a value for a given key
    // Now only callable by the owner
    function setItem(uint256 groupId, uint256 perlin, uint256 itemId) external override onlyOwner {
        _setItem(groupId, perlin, itemId);
    }

    function setItems(PerlinConfig[] calldata perlinConfigs) external override onlyOwner {
        for (uint256 i = 0; i < perlinConfigs.length; i++) {
            _setItem(perlinConfigs[i].groupId, perlinConfigs[i].perlinId, perlinConfigs[i].itemId);
        }
    }

    function _setItem(uint256 groupId, uint256 perlin, uint256 itemId) private onlyOwner {
        items[groupId][perlin] = itemId;
        if(groupId > maxGroupIdNumber) {
            maxGroupIdNumber = groupId;
        }
    }


    // Function to get the value of a given key
    function getItem(uint groupId, uint256 perlin) external view override returns (uint256) {
        return items[groupId][perlin];
    }

    function calculatePerlinAndGetItem(uint256 x, uint256 y, uint256 seed) external view override returns (uint256) {
      unchecked {
         uint seedRe = (uint32(block.timestamp & (seed) >> 2));
         if((seedRe + x + y) % 2 == 0)  return 0;
         uint perlin = calculatePerlin(x, y, seedRe);
         uint groupId = ((perlin + x + y) % maxGroupIdNumber) + 1 ;  
         return items[groupId][perlin];      
      }
     
    }

    function calculatePerlin(uint256 x, uint256 y, uint256 seed) public pure override returns (uint256) {
        if(seed == 0) {
            return 0;
        }
        int128 perlin = PerlinV2.noise(int256(x), int256(y), int256(seed), 3, 5);
        return uint256(uint128(perlin));
    }
}
