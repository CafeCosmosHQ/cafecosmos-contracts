// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;

interface ICrafting {
    function createRecipe(uint256[3][3] memory recipe_, uint256 output) external;

    function removeRecipe(uint256[3][3] memory recipe_) external;

    function craftCheck(uint256[3][3] memory recipe_) external;

    function craft(uint256 landId, uint256[3][3] memory recipe_) external;

    function craftFrom(uint256 landId, uint256[3][3] memory recipe_) external;
}