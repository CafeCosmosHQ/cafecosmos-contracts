// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import { IAxiomV2Client } from "../../lib/axiom-v2-contracts/contracts/interfaces/client/IAxiomV2Client.sol";
import { System } from "@latticexyz/world/src/System.sol";
import {WaterController, WaterControllerData} from "../codegen/index.sol";
import {RootAccessOperator} from "./RootAccessOperator.sol";

contract WaterControllerSystem is IAxiomV2Client, System, RootAccessOperator {

    function InitialiseWaterController(address _axiomV2QueryAddress, uint64 _callbackSourceChainId, bytes32 _querySchema) public onlyOwner
    {
        WaterController.set(WaterControllerData({
            QUERY_SCHEMA: _querySchema,
            minDelta: 0,
            maxDelta: 0,
            SOURCE_CHAIN_ID: _callbackSourceChainId,
            numSamples: 0,
            blockInterval: 0,
            minYieldTime: 0,
            maxYieldTime: 0,
            endBlockSlippage: 0,
            waterYieldTime: 120,
            lastTWAP: block.basefee,
            lastUpdate: block.number
        }));

    }

     /// @notice Return the address of the AxiomV2Query contract.
    /// @return The address of the AxiomV2Query contract.
    function axiomV2QueryAddress() external view returns (address){
        //return ls().axiomV2QueryAddress;
    }

    function _validateAxiomV2Call(
        AxiomCallbackType, // callbackType,
        uint64 sourceChainId,
        address, // caller,
        bytes32 querySchema,
        uint256, // queryId,
        bytes calldata // extraData
    ) internal view {
        require(sourceChainId == WaterController.getSOURCE_CHAIN_ID(), "Source chain ID does not match");
        require(querySchema ==  WaterController.getQUERY_SCHEMA(), "Invalid query schema");
    }


    function _axiomV2Callback(
        uint64, // sourceChainId,
        address, // caller,
        bytes32, // querySchema,
        uint256, // queryId,
        bytes32[] calldata axiomResults,
        bytes calldata // extraData
    ) internal {
        uint256 avgFee = uint256(axiomResults[0]);
        uint256 startBlock = uint256(axiomResults[1]);
        uint256 endBlock = uint256(axiomResults[2]);
        uint256 numSamples = uint256(axiomResults[3]);

        require(WaterController.getNumSamples() == numSamples, "max samples don't match");
        require(WaterController.getLastUpdate() == startBlock, "start block doesn't match");
        require(WaterController.getBlockInterval() <= endBlock - startBlock, "not enough time has passed");
        require(endBlock >= block.number - WaterController.getEndBlockSlippage(), "end block is too late");
 
        _updateWaterYield(avgFee);
  }

 function _calculateWaterYieldTime(int256 delta) internal view returns (uint256) {
     uint numSamples = WaterController.getNumSamples();
    uint blockInterval = WaterController.getBlockInterval();
    uint minYieldTime = WaterController.getMinYieldTime();
    uint maxYieldTime = WaterController.getMaxYieldTime();
    int256 minDelta = WaterController.getMinDelta();
    int256 maxDelta = WaterController.getMaxDelta();
    uint endBlockSlippage = WaterController.getEndBlockSlippage();
        require(
            numSamples > 0 &&
                blockInterval > 0 &&
                minYieldTime > 0 &&
                maxYieldTime > minYieldTime &&
                endBlockSlippage > 0 &&
                maxDelta > minDelta,
            "WaterController misconfigured or missing config, use world.setWaterControllerParameters()"
        );

        delta = delta < minDelta ? minDelta : (delta > maxDelta ? maxDelta : delta);
        uint yieldTime = uint(
            int(maxYieldTime) -
                (((delta - minDelta) * (int(maxYieldTime - minYieldTime))) /
                    (maxDelta - minDelta))
        );

        return yieldTime;
    }

     function _updateWaterYield(uint256 twap) internal {
        int256 delta = int256(twap) - int256(WaterController.getLastTWAP());

        WaterController.setWaterYieldTime(_calculateWaterYieldTime(delta));
        WaterController.setLastTWAP(twap);
        WaterController.setLastUpdate(block.number);
    }

 
    /// @notice Whether the callback is made from an on-chain or off-chain query
    /// @param OnChain The callback is made from an on-chain query
    /// @param OffChain The callback is made from an off-chain query
    enum AxiomCallbackType {
        OnChain,
        OffChain
    }

    function setAxionV2QueryAddress(address _axiomV2QueryAddress) public onlyOwner {
       // ls().axiomV2QueryAddress = _axiomV2QueryAddress;
    }

    /// @inheritdoc IAxiomV2Client
    function axiomV2Callback(
        uint64 sourceChainId,
        address caller,
        bytes32 querySchema,
        uint256 queryId,
        bytes32[] calldata axiomResults,
        bytes calldata extraData
    ) override external {
        /*
        if (msg.sender != ls().axiomV2QueryAddress) {
            revert CallerMustBeAxiomV2Query();
        }*/
        emit AxiomV2Call(sourceChainId, caller, querySchema, queryId);

        _validateAxiomV2Call(AxiomCallbackType.OnChain, sourceChainId, caller, querySchema, queryId, extraData);
        _axiomV2Callback(sourceChainId, caller, querySchema, queryId, axiomResults, extraData);
    }

    /// @inheritdoc IAxiomV2Client
    function axiomV2OffchainCallback(
        uint64 sourceChainId,
        address caller,
        bytes32 querySchema,
        uint256 queryId,
        bytes32[] calldata axiomResults,
        bytes calldata extraData
    ) override external {
        /*
        if (msg.sender != ls().axiomV2QueryAddress) {
            revert CallerMustBeAxiomV2Query();
        }*/

        emit AxiomV2OffchainCall(sourceChainId, caller, querySchema, queryId);

        _validateAxiomV2Call(AxiomCallbackType.OffChain, sourceChainId, caller, querySchema, queryId, extraData);
        _axiomV2Callback(sourceChainId, caller, querySchema, queryId, axiomResults, extraData);
    }

    function getWaterYieldTime() public view returns (uint256) {
        return WaterController.getWaterYieldTime();
    }

    function setWaterControllerParameters(
        uint256 numSamples,
        uint256 blockInterval,
        uint256 minYieldTime,
        uint256 maxYieldTime,
        uint256 endBlockSlippage,
        int256 minDelta,
        int256 maxDelta
    ) public onlyOwner {

        WaterController.setNumSamples(numSamples);
         WaterController.setBlockInterval(blockInterval);
         WaterController.setMinYieldTime(minYieldTime);
         WaterController.setMaxYieldTime(maxYieldTime);
         WaterController.setEndBlockSlippage(endBlockSlippage);
         WaterController.setMinDelta(minDelta);
         WaterController.setMaxDelta(maxDelta);
    }

}