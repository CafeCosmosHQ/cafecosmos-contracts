// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { Inventory } from "../codegen/index.sol";

library LibInventoryManagement {

    function mint(uint256 landId, uint256 itemId, uint256 quantity) internal {
        require(itemId != 0, "InventorySystem: invalid item id");
        uint256 currInventory = Inventory.getQuantity(landId, itemId);
        Inventory.setQuantity(landId, itemId, (currInventory + quantity));
    }

    function mintBatch(uint256 landId, uint256[] memory itemIds, uint256[] memory quantities) internal {
        require(itemIds.length == quantities.length, "InventorySystem: invalid input");
        for (uint256 i = 0; i < itemIds.length; i++) {
            if(itemIds[i] == 0){
                revert("InventorySystem: invalid item id");
            }
            uint256 currInventory = Inventory.getQuantity(landId, itemIds[i]);
            uint256 currQuantity = quantities[i];
            Inventory.setQuantity(landId, itemIds[i], (currInventory + currQuantity));
        }
    }
    
    function burn(uint256 landId, uint256 itemId, uint256 quantity) internal {
        require(itemId != 0, "InventorySystem: invalid item id");
        uint256 currInventory = Inventory.getQuantity(landId, itemId);
        require(currInventory >= quantity, "InventorySystem: insufficient balance");
        Inventory.setQuantity(landId, itemId, (currInventory - quantity));
    }

    function burnBatch(uint256 landId, uint256[] memory itemIds, uint256[] memory quantities) internal {
        require(itemIds.length == quantities.length, "InventorySystem: invalid input lengths");
        for (uint256 i = 0; i < itemIds.length; i++) {
            if(itemIds[i] == 0){
                revert("InventorySystem: invalid item id");
            }
            uint256 currInventory = Inventory.getQuantity(landId, itemIds[i]);
            uint256 currQuantity = quantities[i];
            require(currInventory >= currQuantity, "InventorySystem: insufficient balance");
            Inventory.setQuantity(landId, itemIds[i], (currInventory - currQuantity));
        }
    }

    function itemBalanceOf(uint256 landId, uint256 itemId) internal view returns (uint256) {
        return Inventory.getQuantity(landId, itemId);
    }

    function increaseQuantity(uint landId, uint itemId, uint amount) internal {
        uint balance = Inventory.getQuantity(landId, itemId);
        Inventory.setQuantity(landId, itemId, balance + amount);
    }

    function decreaseQuantity(uint landId, uint itemId, uint amount) internal {
        uint balance = Inventory.getQuantity(landId, itemId);
        require(balance >= amount, "LibInventoryManagement decreaseQuantity: insufficient balance");
        Inventory.setQuantity(landId, itemId, balance - amount);
    }
}