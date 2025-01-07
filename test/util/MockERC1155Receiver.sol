// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

contract MockERC1155Receiver is ERC1155Receiver {
    bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61; 
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; 

    function onERC1155Received(
        address _operator,
        address _from,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external override returns (bytes4) {
        return ERC1155_ACCEPTED;
    }

    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external override returns (bytes4) {
        return ERC1155_BATCH_ACCEPTED;
    }

}
