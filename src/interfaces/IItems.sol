// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IItems is IERC1155 {
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    function burn(
        address account,
        uint256 id,
        uint256 amount
    ) external;

    function mintBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes calldata data
    ) external;

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes calldata data
    ) external;

    function burnBatch(uint256[] memory ids, uint256[] memory amounts) external;
}
