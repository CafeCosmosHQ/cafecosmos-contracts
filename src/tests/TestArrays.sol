pragma solidity ^0.8.0;

import "../util/Arrays.sol";

contract TestArrays {
    function testParseCraftingArray(uint256[3][3] memory recipe_)
        public
        pure
        returns (uint256[9] memory parsed, uint8 length)
    {
        (parsed, length) = Arrays.parseCraftingArray(recipe_);
    }
}
