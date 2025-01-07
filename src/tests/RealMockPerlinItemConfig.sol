// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "../Perlin.sol";
import "../PerlinItemConfig.sol";
//import "forge-std/console.sol";

// Maps the perlin values to ERC1155 itemIds
contract RealMockPerlinItemConfig is PerlinItemConfig {

    function calculatePerlinAndGetItem(uint256 x, uint256 y, uint256 seed, uint256 timestamp) public view returns (uint256) {
        
        uint seedRe = (uint32(timestamp & (seed) >> 2));
        if((seedRe + x + y) % 2 == 0)  return 0;
        uint perlin = calculatePerlin(x, y, seedRe);
        uint groupId = ((perlin + x + y) % maxGroupIdNumber) + 1 ;  
        return items[groupId][perlin];      
    
     
    }

}