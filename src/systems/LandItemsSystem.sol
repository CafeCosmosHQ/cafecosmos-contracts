 // SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import {ConfigAddresses, Inventory} from  "../codegen/index.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import "../interfaces/IITems.sol";
import "../interfaces/ILandNFTs.sol";


contract LandItemsSystem is System, LandAccessOperator {
 
    function itemBalanceOf(uint256 landId, uint256 itemId) public view returns (uint256) {
        return LibInventoryManagement.itemBalanceOf(landId, itemId);
    } 

    function itemBalanceOfBatch(uint256 landId, uint256[] memory ids) public view returns (uint256[] memory) {
        uint256[] memory batchBalances = new uint256[](ids.length);
        for (uint256 i = 0; i < ids.length; ++i) {
            batchBalances[i] = LibInventoryManagement.itemBalanceOf(landId, ids[i]);
        }
        return batchBalances;
    }

    function depositItems(uint256 landId, uint256[] memory itemIds, uint256[] memory amounts) public {
        IItems items = IItems(ConfigAddresses.getItemsAddress());
        items.safeBatchTransferFrom(msg.sender, address(this), itemIds, amounts, "0x003");
        for (uint256 index = 0; index < itemIds.length; index++) {
            LibInventoryManagement.increaseQuantity(landId, itemIds[index], amounts[index]);
        }
        items.burnBatch(itemIds, amounts);
    }

    function withdrawItems(uint256 landId, uint256[] memory itemIds, uint256[] memory amounts) public onlyLandOperator(landId) {
        IItems items = IItems(ConfigAddresses.getItemsAddress());
        ILandNFTs landNFTs = ILandNFTs(ConfigAddresses.getLandNFTsAddress());
        for (uint256 index = 0; index < itemIds.length; index++) {
            LibInventoryManagement.decreaseQuantity(landId, itemIds[index], amounts[index]);
        }
        items.mintBatch(landNFTs.ownerOf(landId), itemIds, amounts, "0x003");
    }
}