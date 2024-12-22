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

struct LandQuestData {
  uint256 numberOfTasks;
  uint256 numberOfCompletedTasks;
  bool claimed;
  bool active;
  uint256 expiresAt;
}

library LandQuest {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "LandQuest", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746200000000000000000000000000004c616e64517565737400000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0062050020200101200000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (uint256, uint256, uint256)
  Schema constant _keySchema = Schema.wrap(0x006003001f1f1f00000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint256, uint256, bool, bool, uint256)
  Schema constant _valueSchema = Schema.wrap(0x006205001f1f60601f0000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](3);
    keyNames[0] = "landId";
    keyNames[1] = "questGroupId";
    keyNames[2] = "questId";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](5);
    fieldNames[0] = "numberOfTasks";
    fieldNames[1] = "numberOfCompletedTasks";
    fieldNames[2] = "claimed";
    fieldNames[3] = "active";
    fieldNames[4] = "expiresAt";
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
   * @notice Get numberOfTasks.
   */
  function getNumberOfTasks(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (uint256 numberOfTasks) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get numberOfTasks.
   */
  function _getNumberOfTasks(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (uint256 numberOfTasks) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set numberOfTasks.
   */
  function setNumberOfTasks(uint256 landId, uint256 questGroupId, uint256 questId, uint256 numberOfTasks) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((numberOfTasks)), _fieldLayout);
  }

  /**
   * @notice Set numberOfTasks.
   */
  function _setNumberOfTasks(uint256 landId, uint256 questGroupId, uint256 questId, uint256 numberOfTasks) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((numberOfTasks)), _fieldLayout);
  }

  /**
   * @notice Get numberOfCompletedTasks.
   */
  function getNumberOfCompletedTasks(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (uint256 numberOfCompletedTasks) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get numberOfCompletedTasks.
   */
  function _getNumberOfCompletedTasks(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (uint256 numberOfCompletedTasks) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set numberOfCompletedTasks.
   */
  function setNumberOfCompletedTasks(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId,
    uint256 numberOfCompletedTasks
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((numberOfCompletedTasks)), _fieldLayout);
  }

  /**
   * @notice Set numberOfCompletedTasks.
   */
  function _setNumberOfCompletedTasks(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId,
    uint256 numberOfCompletedTasks
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((numberOfCompletedTasks)), _fieldLayout);
  }

  /**
   * @notice Get claimed.
   */
  function getClaimed(uint256 landId, uint256 questGroupId, uint256 questId) internal view returns (bool claimed) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get claimed.
   */
  function _getClaimed(uint256 landId, uint256 questGroupId, uint256 questId) internal view returns (bool claimed) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set claimed.
   */
  function setClaimed(uint256 landId, uint256 questGroupId, uint256 questId, bool claimed) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((claimed)), _fieldLayout);
  }

  /**
   * @notice Set claimed.
   */
  function _setClaimed(uint256 landId, uint256 questGroupId, uint256 questId, bool claimed) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((claimed)), _fieldLayout);
  }

  /**
   * @notice Get active.
   */
  function getActive(uint256 landId, uint256 questGroupId, uint256 questId) internal view returns (bool active) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get active.
   */
  function _getActive(uint256 landId, uint256 questGroupId, uint256 questId) internal view returns (bool active) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set active.
   */
  function setActive(uint256 landId, uint256 questGroupId, uint256 questId, bool active) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((active)), _fieldLayout);
  }

  /**
   * @notice Set active.
   */
  function _setActive(uint256 landId, uint256 questGroupId, uint256 questId, bool active) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((active)), _fieldLayout);
  }

  /**
   * @notice Get expiresAt.
   */
  function getExpiresAt(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (uint256 expiresAt) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get expiresAt.
   */
  function _getExpiresAt(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (uint256 expiresAt) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set expiresAt.
   */
  function setExpiresAt(uint256 landId, uint256 questGroupId, uint256 questId, uint256 expiresAt) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((expiresAt)), _fieldLayout);
  }

  /**
   * @notice Set expiresAt.
   */
  function _setExpiresAt(uint256 landId, uint256 questGroupId, uint256 questId, uint256 expiresAt) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((expiresAt)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (LandQuestData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

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
  function _get(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal view returns (LandQuestData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

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
    uint256 landId,
    uint256 questGroupId,
    uint256 questId,
    uint256 numberOfTasks,
    uint256 numberOfCompletedTasks,
    bool claimed,
    bool active,
    uint256 expiresAt
  ) internal {
    bytes memory _staticData = encodeStatic(numberOfTasks, numberOfCompletedTasks, claimed, active, expiresAt);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId,
    uint256 numberOfTasks,
    uint256 numberOfCompletedTasks,
    bool claimed,
    bool active,
    uint256 expiresAt
  ) internal {
    bytes memory _staticData = encodeStatic(numberOfTasks, numberOfCompletedTasks, claimed, active, expiresAt);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(uint256 landId, uint256 questGroupId, uint256 questId, LandQuestData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.numberOfTasks,
      _table.numberOfCompletedTasks,
      _table.claimed,
      _table.active,
      _table.expiresAt
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(uint256 landId, uint256 questGroupId, uint256 questId, LandQuestData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.numberOfTasks,
      _table.numberOfCompletedTasks,
      _table.claimed,
      _table.active,
      _table.expiresAt
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

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
    returns (uint256 numberOfTasks, uint256 numberOfCompletedTasks, bool claimed, bool active, uint256 expiresAt)
  {
    numberOfTasks = (uint256(Bytes.getBytes32(_blob, 0)));

    numberOfCompletedTasks = (uint256(Bytes.getBytes32(_blob, 32)));

    claimed = (_toBool(uint8(Bytes.getBytes1(_blob, 64))));

    active = (_toBool(uint8(Bytes.getBytes1(_blob, 65))));

    expiresAt = (uint256(Bytes.getBytes32(_blob, 66)));
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
  ) internal pure returns (LandQuestData memory _table) {
    (
      _table.numberOfTasks,
      _table.numberOfCompletedTasks,
      _table.claimed,
      _table.active,
      _table.expiresAt
    ) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint256 landId, uint256 questGroupId, uint256 questId) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint256 landId, uint256 questGroupId, uint256 questId) internal {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 numberOfTasks,
    uint256 numberOfCompletedTasks,
    bool claimed,
    bool active,
    uint256 expiresAt
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(numberOfTasks, numberOfCompletedTasks, claimed, active, expiresAt);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 numberOfTasks,
    uint256 numberOfCompletedTasks,
    bool claimed,
    bool active,
    uint256 expiresAt
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(numberOfTasks, numberOfCompletedTasks, claimed, active, expiresAt);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(
    uint256 landId,
    uint256 questGroupId,
    uint256 questId
  ) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](3);
    _keyTuple[0] = bytes32(uint256(landId));
    _keyTuple[1] = bytes32(uint256(questGroupId));
    _keyTuple[2] = bytes32(uint256(questId));

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