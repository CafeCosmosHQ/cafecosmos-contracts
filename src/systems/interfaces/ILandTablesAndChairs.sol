// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;

interface ILandTablesAndChairs {
    function checkPlaceTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) external;
    function checkRemoveTableOrChair(uint256 landId, uint256 itemId, uint256 x, uint256 y) external;
}