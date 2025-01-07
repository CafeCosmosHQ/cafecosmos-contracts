// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import "../libraries/LibAccess.sol";

contract RootAccessOperator {

    modifier onlyOwner()  {  
            require(LibAccess.checkRootAccess(), "RootAccessOperator: No owner access");
             _;
    }

}