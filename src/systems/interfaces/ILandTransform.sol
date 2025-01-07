// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;
import {TransformationsData} from  "../../codegen/index.sol";


interface ILandTransform {
    function transform(uint256 landId, uint256 x, uint256 y, uint256 input, TransformationsData memory config) external;
    error TransformationIncompatible(uint256 base, uint256 input);
    error notUnlockedYet(uint256 timeNow, uint256 unlockTime, uint256 x, uint256 y);
}