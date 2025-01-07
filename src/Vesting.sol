// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IVesting.sol";

//import "hardhat/console.sol";

contract Vesting is Ownable, IVesting {
    event ERC20Released(address indexed token, uint256 amount);

    IERC20 private _token;
    address private _beneficiary;
    uint256 private _released;
    uint256 private _lastReleaseBlock;
    uint256 private _releasePerBlock = 1e8;

    constructor(address beneficiaryAddress, address tokenAddress) {
        require(beneficiaryAddress != address(0), "Vesting: beneficiary is zero address");
        require(tokenAddress != address(0), "Vesting: token is zero address");
        
        _beneficiary = beneficiaryAddress;
        _token = IERC20(tokenAddress);
        _lastReleaseBlock = block.number;
    }

    function beneficiary() public view returns (address) {
        return _beneficiary;
    }

    function released() public view returns (uint256) {
        return _released;
    }

    function release() external override {
        uint256 currentBalance = _token.balanceOf(address(this));
        uint256 blocksPassed = block.number - _lastReleaseBlock;
        uint256 amount = (currentBalance * _releasePerBlock * blocksPassed) / 1e18; // Adjust for 18 decimal precision

        if (amount == 0) {
            return;
        }

        _released += amount;
        emit ERC20Released(address(_token), amount);
        _token.transfer(beneficiary(), amount);
        _lastReleaseBlock = block.number;
    }

    function setReleasePerBlock(uint256 releasePerBlock) public onlyOwner {
        require(releasePerBlock < 10000, "Vesting: releasePerBlock is too high");
        _releasePerBlock = releasePerBlock*1e8; //min is 0.01% decay
    }

    function getReleasePerBlock() public view returns (uint256) {
        return _releasePerBlock;
    }

     function getLastReleaseBlock() public view returns (uint256) {
        return _lastReleaseBlock;
    }

    function setBeneficiary(address beneficiaryAddress) public onlyOwner {
        require(beneficiaryAddress != address(0), "Vesting: beneficiary is zero address");
        _beneficiary = beneficiaryAddress;
    }
}
