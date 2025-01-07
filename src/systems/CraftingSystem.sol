// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import "../interfaces/ICrafting.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import {LibCraftingStorage, CraftingRecipeDTO} from "../libraries/LibCraftingStorage.sol";
import {CraftingRecipe, CraftingRecipeData, ItemInfo, LandInfo, ConfigAddresses} from "../codegen/index.sol";
import {LibInventoryManagement} from "../libraries/LibInventoryManagement.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {ILandQuestTaskProgressUpdate} from "./interfaces/ILandQuestTaskProgressUpdate.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract CraftingSystem is System, LandAccessOperator, RootAccessOperator {

    event CraftRecipe(uint256 landId, uint256 output, uint256[] inputs, uint256[] quantities);
    event CraftRecipeXpReward(uint256 landId, uint256 totalXp, uint256 xp);

    function craftRecipe(uint256 landId, uint256 output) public onlyLandOperator(landId) {
       require(CraftingRecipe.getExists(output), "Crafting: recipe does not exists");
        CraftingRecipeData memory recipe = CraftingRecipe.get(output);      
        LibInventoryManagement.burnBatch(landId, recipe.inputs, recipe.quantities);
        LibInventoryManagement.mint(landId, output, recipe.outputQuantity);
        emit CraftRecipe(landId, output, recipe.inputs, recipe.quantities);
        incrementProgressCraft(landId, output);
        LandInfo.setCumulativeXp(landId, LandInfo.getCumulativeXp(landId) + recipe.xp);
        
        emit CraftRecipeXpReward(landId, LandInfo.getCumulativeXp(landId) + recipe.xp, recipe.xp);
          //returnable items
        for (uint256 i = 0; i < recipe.inputs.length; i++) {
            uint256 input = recipe.inputs[i];
            uint256 returnsItem = ItemInfo.getReturnsItem(input);
            if(returnsItem != 0) {
                uint256 quantity = recipe.quantities[i];    
                LibInventoryManagement.mint(landId, returnsItem, quantity);
            }
        }
    }

    function incrementProgressCraft(uint256 landId, uint256 outputItemId) private {
        bytes memory data = abi.encodeWithSelector(ILandQuestTaskProgressUpdate.incrementProgressCraft.selector, landId, outputItemId);
        Address.functionDelegateCall(ConfigAddresses.getLandQuestTaskProgressUpdateAddress(), data);
    }

    function createRecipes(CraftingRecipeDTO[] calldata recipes) public onlyOwner {
        for (uint256 index = 0; index < recipes.length; index++) {
            createRecipe(recipes[index]);
        }
    }

    function createRecipe(CraftingRecipeDTO calldata recipe) public onlyOwner {
        require(!CraftingRecipe.getExists(recipe.output), "Crafting: recipe already exists");
        CraftingRecipe.set(recipe.output, recipe.outputQuantity, recipe.xp, recipe.exists, recipe.inputs, recipe.quantities);
    }

    function removeRecipe(CraftingRecipeDTO calldata recipe) public onlyOwner() {
        require(CraftingRecipe.getExists(recipe.output), "Crafting: recipe does not exists");
        CraftingRecipe.setExists(recipe.output, false);
        CraftingRecipe.deleteRecord(recipe.output);
    }

}

