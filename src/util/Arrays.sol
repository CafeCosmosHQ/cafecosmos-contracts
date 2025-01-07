// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;

library Arrays {
    function parseCraftingArray(
        uint256[3][3] memory recipe_
    ) internal pure returns (uint256[9] memory parsed, uint8 length) {
        for (uint256 x = 0; x < 3; x++) {
            for (uint256 y = 0; y < 3; y++) {
                if (recipe_[x][y] != 0) {
                    parsed[length] = recipe_[x][y];
                    length++;
                }
            }
        }
    }

    function parseKitchenPrepArray(
        uint256[3][2] memory recipe_
    ) internal pure returns (uint256[] memory parsed, uint8 length) {
        parsed = new uint256[](6);
        for (uint256 x = 0; x < 2; x++) {
            for (uint256 y = 0; y < 3; y++) {
                if (recipe_[x][y] != 0) {
                    parsed[length] = recipe_[x][y];
                    length++;
                }
            }
        }
    }
}
