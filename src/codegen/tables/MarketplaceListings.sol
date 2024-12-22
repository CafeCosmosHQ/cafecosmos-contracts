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

struct MarketplaceListingsData {
  uint256 owner;
  uint256 itemId;
  uint256 unitPrice;
  uint256 quantity;
  bool exists;
}

library MarketplaceListings {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "MarketplaceListi", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746200000000000000000000000000004d61726b6574706c6163654c69737469);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0081050020202020010000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (uint256)
  Schema constant _keySchema = Schema.wrap(0x002001001f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint256, uint256, uint256, uint256, bool)
  Schema constant _valueSchema = Schema.wrap(0x008105001f1f1f1f600000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "listingId";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](5);
    fieldNames[0] = "owner";
    fieldNames[1] = "itemId";
    fieldNames[2] = "unitPrice";
    fieldNames[3] = "quantity";
    fieldNames[4] = "exists";
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
   * @notice Get owner.
   */
  function getOwner(uint256 listingId) internal view returns (uint256 owner) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get owner.
   */
  function _getOwner(uint256 listingId) internal view returns (uint256 owner) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set owner.
   */
  function setOwner(uint256 listingId, uint256 owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((owner)), _fieldLayout);
  }

  /**
   * @notice Set owner.
   */
  function _setOwner(uint256 listingId, uint256 owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((owner)), _fieldLayout);
  }

  /**
   * @notice Get itemId.
   */
  function getItemId(uint256 listingId) internal view returns (uint256 itemId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get itemId.
   */
  function _getItemId(uint256 listingId) internal view returns (uint256 itemId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set itemId.
   */
  function setItemId(uint256 listingId, uint256 itemId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((itemId)), _fieldLayout);
  }

  /**
   * @notice Set itemId.
   */
  function _setItemId(uint256 listingId, uint256 itemId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((itemId)), _fieldLayout);
  }

  /**
   * @notice Get unitPrice.
   */
  function getUnitPrice(uint256 listingId) internal view returns (uint256 unitPrice) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get unitPrice.
   */
  function _getUnitPrice(uint256 listingId) internal view returns (uint256 unitPrice) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set unitPrice.
   */
  function setUnitPrice(uint256 listingId, uint256 unitPrice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((unitPrice)), _fieldLayout);
  }

  /**
   * @notice Set unitPrice.
   */
  function _setUnitPrice(uint256 listingId, uint256 unitPrice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((unitPrice)), _fieldLayout);
  }

  /**
   * @notice Get quantity.
   */
  function getQuantity(uint256 listingId) internal view returns (uint256 quantity) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get quantity.
   */
  function _getQuantity(uint256 listingId) internal view returns (uint256 quantity) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set quantity.
   */
  function setQuantity(uint256 listingId, uint256 quantity) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((quantity)), _fieldLayout);
  }

  /**
   * @notice Set quantity.
   */
  function _setQuantity(uint256 listingId, uint256 quantity) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((quantity)), _fieldLayout);
  }

  /**
   * @notice Get exists.
   */
  function getExists(uint256 listingId) internal view returns (bool exists) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get exists.
   */
  function _getExists(uint256 listingId) internal view returns (bool exists) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set exists.
   */
  function setExists(uint256 listingId, bool exists) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((exists)), _fieldLayout);
  }

  /**
   * @notice Set exists.
   */
  function _setExists(uint256 listingId, bool exists) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((exists)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(uint256 listingId) internal view returns (MarketplaceListingsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

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
  function _get(uint256 listingId) internal view returns (MarketplaceListingsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

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
    uint256 listingId,
    uint256 owner,
    uint256 itemId,
    uint256 unitPrice,
    uint256 quantity,
    bool exists
  ) internal {
    bytes memory _staticData = encodeStatic(owner, itemId, unitPrice, quantity, exists);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    uint256 listingId,
    uint256 owner,
    uint256 itemId,
    uint256 unitPrice,
    uint256 quantity,
    bool exists
  ) internal {
    bytes memory _staticData = encodeStatic(owner, itemId, unitPrice, quantity, exists);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(uint256 listingId, MarketplaceListingsData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.owner,
      _table.itemId,
      _table.unitPrice,
      _table.quantity,
      _table.exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(uint256 listingId, MarketplaceListingsData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.owner,
      _table.itemId,
      _table.unitPrice,
      _table.quantity,
      _table.exists
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  ) internal pure returns (uint256 owner, uint256 itemId, uint256 unitPrice, uint256 quantity, bool exists) {
    owner = (uint256(Bytes.getBytes32(_blob, 0)));

    itemId = (uint256(Bytes.getBytes32(_blob, 32)));

    unitPrice = (uint256(Bytes.getBytes32(_blob, 64)));

    quantity = (uint256(Bytes.getBytes32(_blob, 96)));

    exists = (_toBool(uint8(Bytes.getBytes1(_blob, 128))));
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
  ) internal pure returns (MarketplaceListingsData memory _table) {
    (_table.owner, _table.itemId, _table.unitPrice, _table.quantity, _table.exists) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint256 listingId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint256 listingId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 owner,
    uint256 itemId,
    uint256 unitPrice,
    uint256 quantity,
    bool exists
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(owner, itemId, unitPrice, quantity, exists);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 owner,
    uint256 itemId,
    uint256 unitPrice,
    uint256 quantity,
    bool exists
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(owner, itemId, unitPrice, quantity, exists);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(uint256 listingId) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(listingId));

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