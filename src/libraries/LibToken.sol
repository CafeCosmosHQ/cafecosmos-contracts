// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import {ConfigAddresses} from  "../codegen/index.sol";
import {ILandNFTs} from "../interfaces/ILandNFTs.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IWETH9, IWETH9WithdrawTo} from "../interfaces/IWETH9.sol";


library LibToken {

    function balanceOfLandOwner(uint256 landId) internal view returns (uint256) {
        return IERC20(ConfigAddresses.getSoftTokenAddress()).balanceOf(landOwnerOf(landId));
    }

    function landOwnerOf(uint256 landId) internal view returns (address) {
        return ILandNFTs(ConfigAddresses.getLandNFTsAddress()).ownerOf(landId);
    }

    function transferFromLandOwners(uint256 landIdFrom, uint256 landIdTo, uint256 amount) internal {
        IERC20(ConfigAddresses.getSoftTokenAddress()).transferFrom(landOwnerOf(landIdFrom), landOwnerOf(landIdTo), amount);
    }
    
    function transferToLandOwner(uint256 landIdTo, uint256 amount) internal {
        IERC20(ConfigAddresses.getSoftTokenAddress()).transfer(landOwnerOf(landIdTo), amount);
    }

    function withdrawEthAndTransferToLandOwner(uint256 landId, uint256 amount) internal {
        IWETH9WithdrawTo(ConfigAddresses.getSoftTokenAddress()).withdrawTo(landOwnerOf(landId), amount);
    }

}