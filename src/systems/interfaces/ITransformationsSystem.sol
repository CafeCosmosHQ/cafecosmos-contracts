// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import {TransformationsData} from  "../../codegen/index.sol";

 struct TransformationDTO {
        uint256 base; //what you're placing on top of
        uint256 input;
        uint256 next; //what your base turns into
        uint256 yield; //what you earn immediately after your base converts
        uint256 inputNext; //what the input is tranformed to (ie the input is consumed) for example from bucket of water to empty bucket
        uint256 yieldQuantity; //the quantity of the item earned
        uint256 unlockTime; //the time it takes to unlock the yield
        uint256 timeout; //the time it takes to timeout the yield
        uint256 timeoutYield; //the item you receive if you timeout the yield
        uint256 timeoutYieldQuantity; //amount of timeoutYield that you will receive
        uint256 timeoutNext; // the next item if you timeout
        bool isRecipe; //is this a cooking recipe. Does this have a subsequent dividend pool?
        bool isWaterCollection; //is this transformation collecting from a water source?
        uint256 xp; //xp earned from this transformation
        bool exists; //does this transformatione exist? AKA can it be used?
    }
    
interface ITransformationsSystem {
    function getTransformation(uint256 base, uint256 input) external returns (TransformationsData memory);
}