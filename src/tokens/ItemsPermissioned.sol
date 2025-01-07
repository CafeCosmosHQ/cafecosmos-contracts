// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Items.sol";

contract ItemsPermissioned is Items {

    constructor(string memory uri_) Items(uri_) {}

    mapping (address => bool) public whitelist;

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(whitelist[from] || whitelist[to], "ItemsPermissioned: only whitelisted addresses can transfer");
        require(id != 0, "Tried to transfer itemId 0");
        _safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public override {
        require(whitelist[from] || whitelist[to], "ItemsPermissioned: only whitelisted addresses can transfer");
        for (uint256 i; i < ids.length; i++) {
            require(ids[i] != 0, "Tried to transfer itemId 0");
        }
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function setWhitelist(address[] memory addresses, bool[] memory isWhitelisted) public onlyOwner {
        require(addresses.length == isWhitelisted.length, "ItemsPermissioned: addresses and isWhitelisted must have the same length");
        for (uint256 index = 0; index < addresses.length; index++) {
            whitelist[addresses[index]] = isWhitelisted[index];
        }
    }

}