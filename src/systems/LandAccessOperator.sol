// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import "../libraries/LibLandAccess.sol";

contract LandAccessOperator {

    modifier onlyLandOperator(uint256 landId)  {  
            LibLandAccess.checkLandOperator(landId);
             _;
    }

    modifier onlyLandOwner(uint256 landId)  {  
            LibLandAccess.checkLandOwner(landId);
             _;
    }

}