// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";
import { Vrgda } from  "../codegen/index.sol";
import { wadLn } from "solmate/utils/SignedWadMath.sol";

contract VrgdaSystem is RootAccessOperator, System {

    /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18.
    /// @param _priceDecayPercent The percent price decays per unit of time with no sales, scaled by 1e18.
    /// @param _perTimeUnit The number of tokens to target selling in 1 full unit of time, scaled by 1e18.

    function setVrgdaParameters(int256 _targetPrice, 
                           int256 _priceDecayPercent, 
                           int256 _perTimeUnit
                        ) public onlyOwner {
        
        int256 decayConstant = wadLn(1e18 - _priceDecayPercent);
        require(decayConstant < 0, "NON_NEGATIVE_DECAY_CONSTANT");

        Vrgda.setTargetPrice(_targetPrice);
        Vrgda.setDecayConstant(decayConstant);
        Vrgda.setPerTimeUnit(_perTimeUnit);
        Vrgda.setStartingTime(int256(block.timestamp));
    }

}