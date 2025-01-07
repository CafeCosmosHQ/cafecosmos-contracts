// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoftTokenPermissioned is ERC20, Ownable {

    mapping (address => bool) public whitelist;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        _mint(msg.sender, 1001e30);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        require(whitelist[from] || whitelist[to], "SoftTokenPermissioned: only whitelisted addresses can transfer");
        super.transferFrom(from, to, amount);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(whitelist[msg.sender] || whitelist[to], "SoftTokenPermissioned: only whitelisted addresses can transfer");
        super.transfer(to, amount);
    }

    function setWhitelist(address[] memory addresses, bool[] memory isWhitelisted) public onlyOwner {
        require(addresses.length == isWhitelisted.length, "SoftTokenPermissioned: addresses and isWhitelisted must have the same length");
        for (uint256 index = 0; index < addresses.length; index++) {
            whitelist[addresses[index]] = isWhitelisted[index];
        }
    }

    function mintBatch(address[] memory addresses, uint256[] memory amounts) public onlyOwner {
        require(addresses.length == amounts.length, "SoftTokenPermissioned: addresses and amounts must have the same length");
        for (uint256 index = 0; index < addresses.length; index++) {
            _mint(addresses[index], amounts[index]);
        }
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }
}
