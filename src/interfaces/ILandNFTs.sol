// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

struct LandMetadata {
        uint256 landId;
        string name;
}

interface ILandNFTs {

    function ownerOf(uint256 landId) external view returns (address);

    function mint(address to) external returns (uint256);

    function setLandName(uint256 landId, string memory name) external;

    function getAllLands() external view returns (LandMetadata[] memory);

}