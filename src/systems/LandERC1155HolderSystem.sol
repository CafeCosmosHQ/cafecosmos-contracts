// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { WorldContextConsumer } from "@latticexyz/world/src/WorldContext.sol";

contract LandERC1155HolderSystem is ERC1155Holder, System 
{ 
    function supportsInterface(bytes4 interfaceId) public pure virtual override(ERC1155Receiver, WorldContextConsumer) returns (bool) 
    {
        return interfaceId == type(IERC1155Receiver).interfaceId || 
        interfaceId == type(WorldContextConsumer).interfaceId ||
        super.supportsInterface(interfaceId);
    } 
}