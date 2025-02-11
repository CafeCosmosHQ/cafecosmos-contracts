// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { InitialLandItem } from "../../libraries/LibInitialLandItemsStorage.sol";

/**
 * @title ILandCreationSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ILandCreationSystem {
  function setInitialLandLimits(uint256 limitX, uint256 limitY) external;

  function setLandName(uint256 landId, string memory name) external;

  function setInitialLandItems(
    InitialLandItem[] calldata items,
    uint256 landIndex,
    uint256 _initialLandItemsDefaultIndex
  ) external;

  function createPlayerInitialLand() external payable returns (uint256 landId);

  function createLand(uint256 limitX, uint256 limitY) external payable returns (uint256 landId);

  function expandLand(uint256 landId, uint256 x1, uint256 y1) external payable;

  function generateChunk(uint256 landId) external;

  function calculateLandCost(uint256 x0, uint256 y0) external view returns (uint256 cost);

  function calculateLandExpansionCost(uint256 landId, uint256 x1, uint256 y1) external view returns (uint256 cost);

  function calculateVrgdaCost(uint256 area) external view returns (uint256 vrgdaCost);

  function calculateArea(uint256 x, uint256 y) external pure returns (uint256 area);

  function calculateExpansionArea(uint256 landId, uint256 x1, uint256 y1) external view returns (uint256 area);

  function calculateLandInitialPurchaseCost() external view returns (uint256 cost);
}
