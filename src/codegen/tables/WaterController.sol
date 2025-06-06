// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

struct WaterControllerData {
  bytes32 QUERY_SCHEMA;
  int256 minDelta;
  int256 maxDelta;
  uint64 SOURCE_CHAIN_ID;
  uint256 numSamples;
  uint256 blockInterval;
  uint256 minYieldTime;
  uint256 maxYieldTime;
  uint256 endBlockSlippage;
  uint256 lastTWAP;
  uint256 waterYieldTime;
  uint256 lastUpdate;
}

library WaterController {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "WaterController", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746200000000000000000000000000005761746572436f6e74726f6c6c657200);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x01680c0020202008202020202020202000000000000000000000000000000000);

  // Hex-encoded key schema of ()
  Schema constant _keySchema = Schema.wrap(0x0000000000000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (bytes32, int256, int256, uint64, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
  Schema constant _valueSchema = Schema.wrap(0x01680c005f3f3f071f1f1f1f1f1f1f1f00000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](0);
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](12);
    fieldNames[0] = "QUERY_SCHEMA";
    fieldNames[1] = "minDelta";
    fieldNames[2] = "maxDelta";
    fieldNames[3] = "SOURCE_CHAIN_ID";
    fieldNames[4] = "numSamples";
    fieldNames[5] = "blockInterval";
    fieldNames[6] = "minYieldTime";
    fieldNames[7] = "maxYieldTime";
    fieldNames[8] = "endBlockSlippage";
    fieldNames[9] = "lastTWAP";
    fieldNames[10] = "waterYieldTime";
    fieldNames[11] = "lastUpdate";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get QUERY_SCHEMA.
   */
  function getQUERY_SCHEMA() internal view returns (bytes32 QUERY_SCHEMA) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Get QUERY_SCHEMA.
   */
  function _getQUERY_SCHEMA() internal view returns (bytes32 QUERY_SCHEMA) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (bytes32(_blob));
  }

  /**
   * @notice Set QUERY_SCHEMA.
   */
  function setQUERY_SCHEMA(bytes32 QUERY_SCHEMA) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((QUERY_SCHEMA)), _fieldLayout);
  }

  /**
   * @notice Set QUERY_SCHEMA.
   */
  function _setQUERY_SCHEMA(bytes32 QUERY_SCHEMA) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((QUERY_SCHEMA)), _fieldLayout);
  }

  /**
   * @notice Get minDelta.
   */
  function getMinDelta() internal view returns (int256 minDelta) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (int256(uint256(bytes32(_blob))));
  }

  /**
   * @notice Get minDelta.
   */
  function _getMinDelta() internal view returns (int256 minDelta) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (int256(uint256(bytes32(_blob))));
  }

  /**
   * @notice Set minDelta.
   */
  function setMinDelta(int256 minDelta) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((minDelta)), _fieldLayout);
  }

  /**
   * @notice Set minDelta.
   */
  function _setMinDelta(int256 minDelta) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((minDelta)), _fieldLayout);
  }

  /**
   * @notice Get maxDelta.
   */
  function getMaxDelta() internal view returns (int256 maxDelta) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (int256(uint256(bytes32(_blob))));
  }

  /**
   * @notice Get maxDelta.
   */
  function _getMaxDelta() internal view returns (int256 maxDelta) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (int256(uint256(bytes32(_blob))));
  }

  /**
   * @notice Set maxDelta.
   */
  function setMaxDelta(int256 maxDelta) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((maxDelta)), _fieldLayout);
  }

  /**
   * @notice Set maxDelta.
   */
  function _setMaxDelta(int256 maxDelta) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((maxDelta)), _fieldLayout);
  }

  /**
   * @notice Get SOURCE_CHAIN_ID.
   */
  function getSOURCE_CHAIN_ID() internal view returns (uint64 SOURCE_CHAIN_ID) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint64(bytes8(_blob)));
  }

  /**
   * @notice Get SOURCE_CHAIN_ID.
   */
  function _getSOURCE_CHAIN_ID() internal view returns (uint64 SOURCE_CHAIN_ID) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint64(bytes8(_blob)));
  }

  /**
   * @notice Set SOURCE_CHAIN_ID.
   */
  function setSOURCE_CHAIN_ID(uint64 SOURCE_CHAIN_ID) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((SOURCE_CHAIN_ID)), _fieldLayout);
  }

  /**
   * @notice Set SOURCE_CHAIN_ID.
   */
  function _setSOURCE_CHAIN_ID(uint64 SOURCE_CHAIN_ID) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((SOURCE_CHAIN_ID)), _fieldLayout);
  }

  /**
   * @notice Get numSamples.
   */
  function getNumSamples() internal view returns (uint256 numSamples) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get numSamples.
   */
  function _getNumSamples() internal view returns (uint256 numSamples) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set numSamples.
   */
  function setNumSamples(uint256 numSamples) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((numSamples)), _fieldLayout);
  }

  /**
   * @notice Set numSamples.
   */
  function _setNumSamples(uint256 numSamples) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((numSamples)), _fieldLayout);
  }

  /**
   * @notice Get blockInterval.
   */
  function getBlockInterval() internal view returns (uint256 blockInterval) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get blockInterval.
   */
  function _getBlockInterval() internal view returns (uint256 blockInterval) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set blockInterval.
   */
  function setBlockInterval(uint256 blockInterval) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((blockInterval)), _fieldLayout);
  }

  /**
   * @notice Set blockInterval.
   */
  function _setBlockInterval(uint256 blockInterval) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((blockInterval)), _fieldLayout);
  }

  /**
   * @notice Get minYieldTime.
   */
  function getMinYieldTime() internal view returns (uint256 minYieldTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get minYieldTime.
   */
  function _getMinYieldTime() internal view returns (uint256 minYieldTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set minYieldTime.
   */
  function setMinYieldTime(uint256 minYieldTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((minYieldTime)), _fieldLayout);
  }

  /**
   * @notice Set minYieldTime.
   */
  function _setMinYieldTime(uint256 minYieldTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((minYieldTime)), _fieldLayout);
  }

  /**
   * @notice Get maxYieldTime.
   */
  function getMaxYieldTime() internal view returns (uint256 maxYieldTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get maxYieldTime.
   */
  function _getMaxYieldTime() internal view returns (uint256 maxYieldTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set maxYieldTime.
   */
  function setMaxYieldTime(uint256 maxYieldTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((maxYieldTime)), _fieldLayout);
  }

  /**
   * @notice Set maxYieldTime.
   */
  function _setMaxYieldTime(uint256 maxYieldTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((maxYieldTime)), _fieldLayout);
  }

  /**
   * @notice Get endBlockSlippage.
   */
  function getEndBlockSlippage() internal view returns (uint256 endBlockSlippage) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get endBlockSlippage.
   */
  function _getEndBlockSlippage() internal view returns (uint256 endBlockSlippage) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set endBlockSlippage.
   */
  function setEndBlockSlippage(uint256 endBlockSlippage) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((endBlockSlippage)), _fieldLayout);
  }

  /**
   * @notice Set endBlockSlippage.
   */
  function _setEndBlockSlippage(uint256 endBlockSlippage) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((endBlockSlippage)), _fieldLayout);
  }

  /**
   * @notice Get lastTWAP.
   */
  function getLastTWAP() internal view returns (uint256 lastTWAP) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 9, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get lastTWAP.
   */
  function _getLastTWAP() internal view returns (uint256 lastTWAP) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 9, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set lastTWAP.
   */
  function setLastTWAP(uint256 lastTWAP) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 9, abi.encodePacked((lastTWAP)), _fieldLayout);
  }

  /**
   * @notice Set lastTWAP.
   */
  function _setLastTWAP(uint256 lastTWAP) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 9, abi.encodePacked((lastTWAP)), _fieldLayout);
  }

  /**
   * @notice Get waterYieldTime.
   */
  function getWaterYieldTime() internal view returns (uint256 waterYieldTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 10, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get waterYieldTime.
   */
  function _getWaterYieldTime() internal view returns (uint256 waterYieldTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 10, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set waterYieldTime.
   */
  function setWaterYieldTime(uint256 waterYieldTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 10, abi.encodePacked((waterYieldTime)), _fieldLayout);
  }

  /**
   * @notice Set waterYieldTime.
   */
  function _setWaterYieldTime(uint256 waterYieldTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 10, abi.encodePacked((waterYieldTime)), _fieldLayout);
  }

  /**
   * @notice Get lastUpdate.
   */
  function getLastUpdate() internal view returns (uint256 lastUpdate) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 11, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get lastUpdate.
   */
  function _getLastUpdate() internal view returns (uint256 lastUpdate) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 11, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set lastUpdate.
   */
  function setLastUpdate(uint256 lastUpdate) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 11, abi.encodePacked((lastUpdate)), _fieldLayout);
  }

  /**
   * @notice Set lastUpdate.
   */
  function _setLastUpdate(uint256 lastUpdate) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 11, abi.encodePacked((lastUpdate)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get() internal view returns (WaterControllerData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get() internal view returns (WaterControllerData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    bytes32 QUERY_SCHEMA,
    int256 minDelta,
    int256 maxDelta,
    uint64 SOURCE_CHAIN_ID,
    uint256 numSamples,
    uint256 blockInterval,
    uint256 minYieldTime,
    uint256 maxYieldTime,
    uint256 endBlockSlippage,
    uint256 lastTWAP,
    uint256 waterYieldTime,
    uint256 lastUpdate
  ) internal {
    bytes memory _staticData = encodeStatic(
      QUERY_SCHEMA,
      minDelta,
      maxDelta,
      SOURCE_CHAIN_ID,
      numSamples,
      blockInterval,
      minYieldTime,
      maxYieldTime,
      endBlockSlippage,
      lastTWAP,
      waterYieldTime,
      lastUpdate
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes32 QUERY_SCHEMA,
    int256 minDelta,
    int256 maxDelta,
    uint64 SOURCE_CHAIN_ID,
    uint256 numSamples,
    uint256 blockInterval,
    uint256 minYieldTime,
    uint256 maxYieldTime,
    uint256 endBlockSlippage,
    uint256 lastTWAP,
    uint256 waterYieldTime,
    uint256 lastUpdate
  ) internal {
    bytes memory _staticData = encodeStatic(
      QUERY_SCHEMA,
      minDelta,
      maxDelta,
      SOURCE_CHAIN_ID,
      numSamples,
      blockInterval,
      minYieldTime,
      maxYieldTime,
      endBlockSlippage,
      lastTWAP,
      waterYieldTime,
      lastUpdate
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(WaterControllerData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.QUERY_SCHEMA,
      _table.minDelta,
      _table.maxDelta,
      _table.SOURCE_CHAIN_ID,
      _table.numSamples,
      _table.blockInterval,
      _table.minYieldTime,
      _table.maxYieldTime,
      _table.endBlockSlippage,
      _table.lastTWAP,
      _table.waterYieldTime,
      _table.lastUpdate
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(WaterControllerData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.QUERY_SCHEMA,
      _table.minDelta,
      _table.maxDelta,
      _table.SOURCE_CHAIN_ID,
      _table.numSamples,
      _table.blockInterval,
      _table.minYieldTime,
      _table.maxYieldTime,
      _table.endBlockSlippage,
      _table.lastTWAP,
      _table.waterYieldTime,
      _table.lastUpdate
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  )
    internal
    pure
    returns (
      bytes32 QUERY_SCHEMA,
      int256 minDelta,
      int256 maxDelta,
      uint64 SOURCE_CHAIN_ID,
      uint256 numSamples,
      uint256 blockInterval,
      uint256 minYieldTime,
      uint256 maxYieldTime,
      uint256 endBlockSlippage,
      uint256 lastTWAP,
      uint256 waterYieldTime,
      uint256 lastUpdate
    )
  {
    QUERY_SCHEMA = (Bytes.getBytes32(_blob, 0));

    minDelta = (int256(uint256(Bytes.getBytes32(_blob, 32))));

    maxDelta = (int256(uint256(Bytes.getBytes32(_blob, 64))));

    SOURCE_CHAIN_ID = (uint64(Bytes.getBytes8(_blob, 96)));

    numSamples = (uint256(Bytes.getBytes32(_blob, 104)));

    blockInterval = (uint256(Bytes.getBytes32(_blob, 136)));

    minYieldTime = (uint256(Bytes.getBytes32(_blob, 168)));

    maxYieldTime = (uint256(Bytes.getBytes32(_blob, 200)));

    endBlockSlippage = (uint256(Bytes.getBytes32(_blob, 232)));

    lastTWAP = (uint256(Bytes.getBytes32(_blob, 264)));

    waterYieldTime = (uint256(Bytes.getBytes32(_blob, 296)));

    lastUpdate = (uint256(Bytes.getBytes32(_blob, 328)));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths,
    bytes memory
  ) internal pure returns (WaterControllerData memory _table) {
    (
      _table.QUERY_SCHEMA,
      _table.minDelta,
      _table.maxDelta,
      _table.SOURCE_CHAIN_ID,
      _table.numSamples,
      _table.blockInterval,
      _table.minYieldTime,
      _table.maxYieldTime,
      _table.endBlockSlippage,
      _table.lastTWAP,
      _table.waterYieldTime,
      _table.lastUpdate
    ) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    bytes32 QUERY_SCHEMA,
    int256 minDelta,
    int256 maxDelta,
    uint64 SOURCE_CHAIN_ID,
    uint256 numSamples,
    uint256 blockInterval,
    uint256 minYieldTime,
    uint256 maxYieldTime,
    uint256 endBlockSlippage,
    uint256 lastTWAP,
    uint256 waterYieldTime,
    uint256 lastUpdate
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        QUERY_SCHEMA,
        minDelta,
        maxDelta,
        SOURCE_CHAIN_ID,
        numSamples,
        blockInterval,
        minYieldTime,
        maxYieldTime,
        endBlockSlippage,
        lastTWAP,
        waterYieldTime,
        lastUpdate
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    bytes32 QUERY_SCHEMA,
    int256 minDelta,
    int256 maxDelta,
    uint64 SOURCE_CHAIN_ID,
    uint256 numSamples,
    uint256 blockInterval,
    uint256 minYieldTime,
    uint256 maxYieldTime,
    uint256 endBlockSlippage,
    uint256 lastTWAP,
    uint256 waterYieldTime,
    uint256 lastUpdate
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(
      QUERY_SCHEMA,
      minDelta,
      maxDelta,
      SOURCE_CHAIN_ID,
      numSamples,
      blockInterval,
      minYieldTime,
      maxYieldTime,
      endBlockSlippage,
      lastTWAP,
      waterYieldTime,
      lastUpdate
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple() internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    return _keyTuple;
  }
}
