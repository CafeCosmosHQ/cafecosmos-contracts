// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import { AccessControl } from "@latticexyz/world/src/AccessControl.sol";
import "@latticexyz/world/src/constants.sol";
import {WorldContextConsumerLib } from "@latticexyz/world/src/worldcontext.sol";

library LibAccess {

    function checkRootAccess() internal view returns (bool) {
        AccessControl.requireAccess(ROOT_NAMESPACE_ID,  WorldContextConsumerLib._msgSender());
        return true;
    }

    function hasRootAccess() internal view returns (bool) {
        return AccessControl.hasAccess(ROOT_NAMESPACE_ID,  WorldContextConsumerLib._msgSender());
    }
}