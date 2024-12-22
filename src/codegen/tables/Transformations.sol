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

struct TransformationsData {
  uint256 next;
  uint256 yield;
  uint256 inputNext;
  uint256 yieldQuantity;
  uint256 unlockTime;
  uint256 timeout;
  uint256 timeoutYield;
  uint256 timeoutYieldQuantity;
  uint256 timeoutNext;
  bool isRecipe;
  bool isWaterCollection;
  uint256 xp;
  bool exists;
}

library Transformations {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "Transformations", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746200000000000000000000000000005472616e73666f726d6174696f6e7300);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x01430d0020202020202020202001012001000000000000000000000000000000);

  // Hex-encoded key schema of (uint256, uint256)
  Schema constant _keySchema = Schema.wrap(0x004002001f1f0000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool, bool, uint256, bool)
  Schema constant _valueSchema = Schema.wrap(0x01430d001f1f1f1f1f1f1f1f1f60601f60000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](2);
    keyNames[0] = "base";
    keyNames[1] = "input";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](13);
    fieldNames[0] = "next";
    fieldNames[1] = "yield";
    fieldNames[2] = "inputNext";
    fieldNames[3] = "yieldQuantity";
    fieldNames[4] = "unlockTime";
    fieldNames[5] = "timeout";
    fieldNames[6] = "timeoutYield";
    fieldNames[7] = "timeoutYieldQuantity";
    fieldNames[8] = "timeoutNext";
    fieldNames[9] = "isRecipe";
    fieldNames[10] = "isWaterCollection";
    fieldNames[11] = "xp";
    fieldNames[12] = "exists";
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
   * @notice Get next.
   */
  function getNext(uint256 base, uint256 input) internal view returns (uint256 next) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get next.
   */
  function _getNext(uint256 base, uint256 input) internal view returns (uint256 next) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set next.
   */
  function setNext(uint256 base, uint256 input, uint256 next) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((next)), _fieldLayout);
  }

  /**
   * @notice Set next.
   */
  function _setNext(uint256 base, uint256 input, uint256 next) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((next)), _fieldLayout);
  }

  /**
   * @notice Get yield.
   */
  function getYield(uint256 base, uint256 input) internal view returns (uint256 yield) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get yield.
   */
  function _getYield(uint256 base, uint256 input) internal view returns (uint256 yield) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set yield.
   */
  function setYield(uint256 base, uint256 input, uint256 yield) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((yield)), _fieldLayout);
  }

  /**
   * @notice Set yield.
   */
  function _setYield(uint256 base, uint256 input, uint256 yield) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((yield)), _fieldLayout);
  }

  /**
   * @notice Get inputNext.
   */
  function getInputNext(uint256 base, uint256 input) internal view returns (uint256 inputNext) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get inputNext.
   */
  function _getInputNext(uint256 base, uint256 input) internal view returns (uint256 inputNext) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set inputNext.
   */
  function setInputNext(uint256 base, uint256 input, uint256 inputNext) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((inputNext)), _fieldLayout);
  }

  /**
   * @notice Set inputNext.
   */
  function _setInputNext(uint256 base, uint256 input, uint256 inputNext) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((inputNext)), _fieldLayout);
  }

  /**
   * @notice Get yieldQuantity.
   */
  function getYieldQuantity(uint256 base, uint256 input) internal view returns (uint256 yieldQuantity) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get yieldQuantity.
   */
  function _getYieldQuantity(uint256 base, uint256 input) internal view returns (uint256 yieldQuantity) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set yieldQuantity.
   */
  function setYieldQuantity(uint256 base, uint256 input, uint256 yieldQuantity) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((yieldQuantity)), _fieldLayout);
  }

  /**
   * @notice Set yieldQuantity.
   */
  function _setYieldQuantity(uint256 base, uint256 input, uint256 yieldQuantity) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((yieldQuantity)), _fieldLayout);
  }

  /**
   * @notice Get unlockTime.
   */
  function getUnlockTime(uint256 base, uint256 input) internal view returns (uint256 unlockTime) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get unlockTime.
   */
  function _getUnlockTime(uint256 base, uint256 input) internal view returns (uint256 unlockTime) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set unlockTime.
   */
  function setUnlockTime(uint256 base, uint256 input, uint256 unlockTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((unlockTime)), _fieldLayout);
  }

  /**
   * @notice Set unlockTime.
   */
  function _setUnlockTime(uint256 base, uint256 input, uint256 unlockTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((unlockTime)), _fieldLayout);
  }

  /**
   * @notice Get timeout.
   */
  function getTimeout(uint256 base, uint256 input) internal view returns (uint256 timeout) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get timeout.
   */
  function _getTimeout(uint256 base, uint256 input) internal view returns (uint256 timeout) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set timeout.
   */
  function setTimeout(uint256 base, uint256 input, uint256 timeout) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((timeout)), _fieldLayout);
  }

  /**
   * @notice Set timeout.
   */
  function _setTimeout(uint256 base, uint256 input, uint256 timeout) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((timeout)), _fieldLayout);
  }

  /**
   * @notice Get timeoutYield.
   */
  function getTimeoutYield(uint256 base, uint256 input) internal view returns (uint256 timeoutYield) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get timeoutYield.
   */
  function _getTimeoutYield(uint256 base, uint256 input) internal view returns (uint256 timeoutYield) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set timeoutYield.
   */
  function setTimeoutYield(uint256 base, uint256 input, uint256 timeoutYield) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((timeoutYield)), _fieldLayout);
  }

  /**
   * @notice Set timeoutYield.
   */
  function _setTimeoutYield(uint256 base, uint256 input, uint256 timeoutYield) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((timeoutYield)), _fieldLayout);
  }

  /**
   * @notice Get timeoutYieldQuantity.
   */
  function getTimeoutYieldQuantity(uint256 base, uint256 input) internal view returns (uint256 timeoutYieldQuantity) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get timeoutYieldQuantity.
   */
  function _getTimeoutYieldQuantity(uint256 base, uint256 input) internal view returns (uint256 timeoutYieldQuantity) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set timeoutYieldQuantity.
   */
  function setTimeoutYieldQuantity(uint256 base, uint256 input, uint256 timeoutYieldQuantity) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((timeoutYieldQuantity)), _fieldLayout);
  }

  /**
   * @notice Set timeoutYieldQuantity.
   */
  function _setTimeoutYieldQuantity(uint256 base, uint256 input, uint256 timeoutYieldQuantity) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((timeoutYieldQuantity)), _fieldLayout);
  }

  /**
   * @notice Get timeoutNext.
   */
  function getTimeoutNext(uint256 base, uint256 input) internal view returns (uint256 timeoutNext) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get timeoutNext.
   */
  function _getTimeoutNext(uint256 base, uint256 input) internal view returns (uint256 timeoutNext) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set timeoutNext.
   */
  function setTimeoutNext(uint256 base, uint256 input, uint256 timeoutNext) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((timeoutNext)), _fieldLayout);
  }

  /**
   * @notice Set timeoutNext.
   */
  function _setTimeoutNext(uint256 base, uint256 input, uint256 timeoutNext) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((timeoutNext)), _fieldLayout);
  }

  /**
   * @notice Get isRecipe.
   */
  function getIsRecipe(uint256 base, uint256 input) internal view returns (bool isRecipe) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 9, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get isRecipe.
   */
  function _getIsRecipe(uint256 base, uint256 input) internal view returns (bool isRecipe) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 9, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set isRecipe.
   */
  function setIsRecipe(uint256 base, uint256 input, bool isRecipe) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 9, abi.encodePacked((isRecipe)), _fieldLayout);
  }

  /**
   * @notice Set isRecipe.
   */
  function _setIsRecipe(uint256 base, uint256 input, bool isRecipe) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 9, abi.encodePacked((isRecipe)), _fieldLayout);
  }

  /**
   * @notice Get isWaterCollection.
   */
  function getIsWaterCollection(uint256 base, uint256 input) internal view returns (bool isWaterCollection) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 10, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get isWaterCollection.
   */
  function _getIsWaterCollection(uint256 base, uint256 input) internal view returns (bool isWaterCollection) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 10, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set isWaterCollection.
   */
  function setIsWaterCollection(uint256 base, uint256 input, bool isWaterCollection) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 10, abi.encodePacked((isWaterCollection)), _fieldLayout);
  }

  /**
   * @notice Set isWaterCollection.
   */
  function _setIsWaterCollection(uint256 base, uint256 input, bool isWaterCollection) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 10, abi.encodePacked((isWaterCollection)), _fieldLayout);
  }

  /**
   * @notice Get xp.
   */
  function getXp(uint256 base, uint256 input) internal view returns (uint256 xp) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 11, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get xp.
   */
  function _getXp(uint256 base, uint256 input) internal view returns (uint256 xp) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 11, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set xp.
   */
  function setXp(uint256 base, uint256 input, uint256 xp) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 11, abi.encodePacked((xp)), _fieldLayout);
  }

  /**
   * @notice Set xp.
   */
  function _setXp(uint256 base, uint256 input, uint256 xp) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 11, abi.encodePacked((xp)), _fieldLayout);
  }

  /**
   * @notice Get exists.
   */
  function getExists(uint256 base, uint256 input) internal view returns (bool exists) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 12, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get exists.
   */
  function _getExists(uint256 base, uint256 input) internal view returns (bool exists) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 12, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set exists.
   */
  function setExists(uint256 base, uint256 input, bool exists) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 12, abi.encodePacked((exists)), _fieldLayout);
  }

  /**
   * @notice Set exists.
   */
  function _setExists(uint256 base, uint256 input, bool exists) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setStaticField(_tableId, _keyTuple, 12, abi.encodePacked((exists)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(uint256 base, uint256 input) internal view returns (TransformationsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

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
  function _get(uint256 base, uint256 input) internal view returns (TransformationsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

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
    uint256 base,
    uint256 input,
    uint256 next,
    uint256 yield,
    uint256 inputNext,
    uint256 yieldQuantity,
    uint256 unlockTime,
    uint256 timeout,
    uint256 timeoutYield,
    uint256 timeoutYieldQuantity,
    uint256 timeoutNext,
    bool isRecipe,
    bool isWaterCollection,
    uint256 xp,
    bool exists
  ) internal {
    bytes memory _staticData = encodeStatic(
      next,
      yield,
      inputNext,
      yieldQuantity,
      unlockTime,
      timeout,
      timeoutYield,
      timeoutYieldQuantity,
      timeoutNext,
      isRecipe,
      isWaterCollection,
      xp,
      exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    uint256 base,
    uint256 input,
    uint256 next,
    uint256 yield,
    uint256 inputNext,
    uint256 yieldQuantity,
    uint256 unlockTime,
    uint256 timeout,
    uint256 timeoutYield,
    uint256 timeoutYieldQuantity,
    uint256 timeoutNext,
    bool isRecipe,
    bool isWaterCollection,
    uint256 xp,
    bool exists
  ) internal {
    bytes memory _staticData = encodeStatic(
      next,
      yield,
      inputNext,
      yieldQuantity,
      unlockTime,
      timeout,
      timeoutYield,
      timeoutYieldQuantity,
      timeoutNext,
      isRecipe,
      isWaterCollection,
      xp,
      exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(uint256 base, uint256 input, TransformationsData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.next,
      _table.yield,
      _table.inputNext,
      _table.yieldQuantity,
      _table.unlockTime,
      _table.timeout,
      _table.timeoutYield,
      _table.timeoutYieldQuantity,
      _table.timeoutNext,
      _table.isRecipe,
      _table.isWaterCollection,
      _table.xp,
      _table.exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(uint256 base, uint256 input, TransformationsData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.next,
      _table.yield,
      _table.inputNext,
      _table.yieldQuantity,
      _table.unlockTime,
      _table.timeout,
      _table.timeoutYield,
      _table.timeoutYieldQuantity,
      _table.timeoutNext,
      _table.isRecipe,
      _table.isWaterCollection,
      _table.xp,
      _table.exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

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
      uint256 next,
      uint256 yield,
      uint256 inputNext,
      uint256 yieldQuantity,
      uint256 unlockTime,
      uint256 timeout,
      uint256 timeoutYield,
      uint256 timeoutYieldQuantity,
      uint256 timeoutNext,
      bool isRecipe,
      bool isWaterCollection,
      uint256 xp,
      bool exists
    )
  {
    next = (uint256(Bytes.getBytes32(_blob, 0)));

    yield = (uint256(Bytes.getBytes32(_blob, 32)));

    inputNext = (uint256(Bytes.getBytes32(_blob, 64)));

    yieldQuantity = (uint256(Bytes.getBytes32(_blob, 96)));

    unlockTime = (uint256(Bytes.getBytes32(_blob, 128)));

    timeout = (uint256(Bytes.getBytes32(_blob, 160)));

    timeoutYield = (uint256(Bytes.getBytes32(_blob, 192)));

    timeoutYieldQuantity = (uint256(Bytes.getBytes32(_blob, 224)));

    timeoutNext = (uint256(Bytes.getBytes32(_blob, 256)));

    isRecipe = (_toBool(uint8(Bytes.getBytes1(_blob, 288))));

    isWaterCollection = (_toBool(uint8(Bytes.getBytes1(_blob, 289))));

    xp = (uint256(Bytes.getBytes32(_blob, 290)));

    exists = (_toBool(uint8(Bytes.getBytes1(_blob, 322))));
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
  ) internal pure returns (TransformationsData memory _table) {
    (
      _table.next,
      _table.yield,
      _table.inputNext,
      _table.yieldQuantity,
      _table.unlockTime,
      _table.timeout,
      _table.timeoutYield,
      _table.timeoutYieldQuantity,
      _table.timeoutNext,
      _table.isRecipe,
      _table.isWaterCollection,
      _table.xp,
      _table.exists
    ) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint256 base, uint256 input) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint256 base, uint256 input) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 next,
    uint256 yield,
    uint256 inputNext,
    uint256 yieldQuantity,
    uint256 unlockTime,
    uint256 timeout,
    uint256 timeoutYield,
    uint256 timeoutYieldQuantity,
    uint256 timeoutNext,
    bool isRecipe,
    bool isWaterCollection,
    uint256 xp,
    bool exists
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        next,
        yield,
        inputNext,
        yieldQuantity,
        unlockTime,
        timeout,
        timeoutYield,
        timeoutYieldQuantity,
        timeoutNext,
        isRecipe,
        isWaterCollection,
        xp,
        exists
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 next,
    uint256 yield,
    uint256 inputNext,
    uint256 yieldQuantity,
    uint256 unlockTime,
    uint256 timeout,
    uint256 timeoutYield,
    uint256 timeoutYieldQuantity,
    uint256 timeoutNext,
    bool isRecipe,
    bool isWaterCollection,
    uint256 xp,
    bool exists
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(
      next,
      yield,
      inputNext,
      yieldQuantity,
      unlockTime,
      timeout,
      timeoutYield,
      timeoutYieldQuantity,
      timeoutNext,
      isRecipe,
      isWaterCollection,
      xp,
      exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(uint256 base, uint256 input) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(base));
    _keyTuple[1] = bytes32(uint256(input));

    return _keyTuple;
  }
}

/**
 * @notice Cast a value to a bool.
 * @dev Boolean values are encoded as uint8 (1 = true, 0 = false), but Solidity doesn't allow casting between uint8 and bool.
 * @param value The uint8 value to convert.
 * @return result The boolean value.
 */
function _toBool(uint8 value) pure returns (bool result) {
  assembly {
    result := value
  }
}