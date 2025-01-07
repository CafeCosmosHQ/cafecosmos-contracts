// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

interface IWETH9 {
    /// @notice Deposit ether to get wrapped ether
    function deposit() external payable;

    /// @notice Withdraw wrapped ether to get ether
    function withdraw(uint256) external;
}

interface IWETH9WithdrawTo {
    /// @notice Withdraw wrapped ether to get ether
    function withdrawTo(address to, uint256) external;
}