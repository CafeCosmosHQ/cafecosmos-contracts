// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import { CafeCosmosConfig, ConfigAddresses, LandInfo, LandInfoData, LandPermissions } from  "../codegen/index.sol";
import {ILandNFTs} from "../interfaces/ILandNFTs.sol";
import {WorldContextConsumerLib } from "@latticexyz/world/src/worldcontext.sol";

library LibLandAccess {

    error AccessByNoOperator(address owner, address caller);
    function checkLandOperator(uint256 landId) internal view returns(bool)  {
        address owner = getLandOwner(landId);
        if(!(WorldContextConsumerLib._msgSender() == owner || LandPermissions.getIsOperator(owner, landId, WorldContextConsumerLib._msgSender()))) {
            revert AccessByNoOperator(owner, WorldContextConsumerLib._msgSender());
        }
        /* using typed error to get the values of owner and caller
        require(
            WorldContextConsumerLib._msgSender() == owner || LandPermissions.getIsOperator(owner, landId, WorldContextConsumerLib._msgSender()),
            "LibLandAccess: You are not an operator to this land "
        ); */
        return true;
    }

    function checkLandOwner(uint256 landId) internal view {
        address owner = getLandOwner(landId);
        require(WorldContextConsumerLib._msgSender() == owner, "LibLandAccess: You are not the owner of this land");
    }

    function isLandOperator(uint256 landId, address operator) internal view returns(bool) {
        address owner = getLandOwner(landId);
        return WorldContextConsumerLib._msgSender() == owner || LandPermissions.getIsOperator(owner, landId, operator);
    }

    function getLandOwner(uint256 landId) internal view returns(address) {
        address landNFTsAddress = ConfigAddresses.getLandNFTsAddress();
        require(landNFTsAddress != address(0), "LibLandAccess: landNFTs address cannot be 0");
        return ILandNFTs(landNFTsAddress).ownerOf(landId);
    }
}