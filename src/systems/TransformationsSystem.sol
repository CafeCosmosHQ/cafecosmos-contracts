// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {TransformationDTO} from "./interfaces/ITransformationsSystem.sol";
import {ITransformationsSystem} from "./interfaces/ITransformationsSystem.sol";
import {System } from "@latticexyz/world/src/System.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";

import {Transformations, TransformationsData} from  "../codegen/index.sol";


contract TransformationsSystem is System, RootAccessOperator, ITransformationsSystem {

   function setTransformations(TransformationDTO[] calldata newTransformations) public onlyOwner {
        for (uint256 index = 0; index < newTransformations.length; index++) {
            setTransformation(newTransformations[index]);
        }
    }

    //@dev: if its a water collection transformation include the timeout in the first transformation step (1. isWaterCollection==true), and the timeout yield in the second step (2. isWaterCollection==false);
    function setTransformation(TransformationDTO calldata newTransformation) public onlyOwner {
        require(newTransformation.timeout > newTransformation.unlockTime || newTransformation.timeout == 0, "Transformations: timeout must be greater than unlockTime");
        require(!newTransformation.isWaterCollection || newTransformation.unlockTime == 0, "Transformations: water collection must have unlockTime of 0");
        require(!(newTransformation.isWaterCollection && newTransformation.isRecipe), "Transformations: water collection must not be a recipe");

        Transformations.set(newTransformation.base, newTransformation.input,
            newTransformation.next,
            newTransformation.yield,
            newTransformation.inputNext,
            newTransformation.yieldQuantity,
            newTransformation.unlockTime,
            newTransformation.timeout,
            newTransformation.timeoutYield,
            newTransformation.timeoutYieldQuantity,
            newTransformation.timeoutNext,
            newTransformation.isRecipe,
            newTransformation.isWaterCollection,
            newTransformation.xp,
            newTransformation.exists
        );
    }

    function getTransformation(
        uint256 base,
        uint256 input
    ) external view returns (TransformationsData memory transformation) {
        transformation = Transformations.get(base, input);
    }
}
