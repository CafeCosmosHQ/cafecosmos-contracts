// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "hardhat/console.sol";

//import "forge-std/console.sol";

contract Items is ERC1155, Ownable {

    mapping(address => bool) public minters;

    modifier onlyMinter() {
        require(minters[msg.sender], "Only a minter address can mint");
        _;
    }

    constructor(string memory uri_) ERC1155(uri_) {
        minters[msg.sender] = true;
    }

    function mint(address account, uint256 id, uint256 amount, bytes calldata data) external onlyMinter {
        require(id != 0, "Tried to mint itemId 0");
        _mint(account, id, amount, data);
    }

    function burnBatch(uint256[] memory ids, uint256[] memory amounts) external {
        for (uint256 i = 0; i < ids.length; i++) {
            _burn(msg.sender, ids[i], amounts[i]);
        }
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(id != 0, "Tried to transfer itemId 0");
        _safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        for (uint256 i; i < ids.length; i++) {
            require(ids[i] != 0, "Tried to transfer itemId 0");
        }
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function mintBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes calldata data
    ) external onlyMinter {
        for (uint256 i; i < ids.length; i++) {
            require(ids[i] != 0, "Tried to mint itemId 0");
        }
        _mintBatch(account, ids, amounts, data);
    }

    function balanceOfBatchSingle(address account, uint256[] memory ids) public view returns (uint256[] memory) {
        uint256[] memory batchBalances = new uint256[](ids.length);
        for (uint256 i = 0; i < ids.length; ++i) {
            batchBalances[i] = balanceOf(account, ids[i]);
        }
        return batchBalances;
    }

    function setMinter(address minter, bool status) external onlyOwner {
        minters[minter] = status;
   }
}
