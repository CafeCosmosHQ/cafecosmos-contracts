// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;

interface IRedistributor {

    function redistributeFunds() external;
    function withdrawFunds(uint256 _identifier, uint256 shares) external returns (uint256);
    function mintShares(uint256 _identifier, uint256 shares) external;
    function burnShares(uint256 _identifier, uint256 shares) external;

}