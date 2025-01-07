// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Whitelist is Ownable {
    address _crafter;
    address _land;
    address _wrapper;

    modifier onlyWhitelist() {
        require(
            msg.sender == _crafter || msg.sender == _land || msg.sender == _wrapper || msg.sender == owner(),
            "address not in whitelist"
        );
        _;
    }

    function setCrafter(address crafter_) external onlyOwner {
        _crafter = crafter_;
    }

    function setLand(address land_) external onlyOwner {
        _land = land_;
    }
}
