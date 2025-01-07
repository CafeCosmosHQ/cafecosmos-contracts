 // SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import {ConfigAddresses, LandInfo} from  "../codegen/index.sol";
import {LibToken} from "../libraries/LibToken.sol";
import {LibLandManagement} from "../libraries/LibLandManagement.sol";
import {LandAccessOperator} from "./LandAccessOperator.sol";
import "../interfaces/IITems.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/ILandNFTs.sol";

contract LandTokensSystem is LandAccessOperator, System {
   
    function tokenBalanceOf(uint256 landId) public view returns (uint256) {
        return LibToken.balanceOfLandOwner(landId);
    }
    
    // function depositTokens(uint256 landId, uint256 amount) public {
    //     // IERC20 softToken = IERC20(ConfigAddresses.getSoftTokenAddress());
    //     // softToken.transferFrom(msg.sender, address(this), amount);
    //     // LibLandManagement.increaseLandTokenBalance(landId, amount); 
    // }

    // function withdrawTokens(uint256 landId, uint256 amount) public onlyLandOperator(landId) {
    //     // require(LandInfo.getTokenBalance(landId) >= amount, "Land: insufficient token balance");
    //     // IERC20 softToken = IERC20(ConfigAddresses.getSoftTokenAddress());
    //     // ILandNFTs landNFTs = ILandNFTs(ConfigAddresses.getLandNFTsAddress());
    //     // LibLandManagement.decreaseLandTokenBalance(landId, amount);
    //     // softToken.transfer(landNFTs.ownerOf(landId), amount);
    // }
}