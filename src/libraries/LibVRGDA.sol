// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.4;

import { System } from "@latticexyz/world/src/System.sol";
import { LibInventoryManagement } from "./LibInventoryManagement.sol";
import { LibRandomSelection } from "./LibRandomSelection.sol";
import { wadExp, wadMul, unsafeWadMul, toWadUnsafe, unsafeWadDiv } from "solmate/utils/SignedWadMath.sol";

import { Vrgda } from "../codegen/index.sol";


/// @title Linear Variable Rate Gradual Dutch Auction
/// @notice VRGDA with a linear issuance curve.
/// @notice Sell tokens roughly according to an issuance schedule.

library LibVRGDA {

    /// @param sold The total number of tokens that have been sold so far.
    /// @return The price of a token according to VRGDA, scaled by 1e18.
    function getVRGDAPrice(uint256 sold) internal view returns (uint256) {
        int256 timeSinceStart = int256(block.timestamp) - Vrgda.getStartingTime();
        unchecked {
            // prettier-ignore
            return uint256(wadMul(Vrgda.getTargetPrice(), wadExp(unsafeWadMul(Vrgda.getDecayConstant(),
                // Theoretically calling toWadUnsafe with sold can silently overflow but under
                // any reasonable circumstance it will never be large enough. We use sold + 1 as
                // the VRGDA formula's n param represents the nth token and sold is the n-1th token.
                timeSinceStart - getTargetSaleTime(toWadUnsafe(sold + 1))
            ))));
        }
    }

    // /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
    // /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
    // /// @return The target time the tokens should be sold by, scaled by 1e18, where the time is
    // /// relative, such that 0 means the tokens should be sold immediately when the VRGDA begins.
    function getTargetSaleTime(int256 sold) public view returns (int256) {
        return unsafeWadDiv(sold, Vrgda.getPerTimeUnit());
    }
}


