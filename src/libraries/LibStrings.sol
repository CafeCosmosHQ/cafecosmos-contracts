// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

library LibStrings {
    
    function toLower(string memory str) internal pure returns (string memory) {
        bytes memory original = bytes(str);
        bytes memory result = new bytes(original.length);

        for (uint i = 0; i < original.length; i++) {
            bytes1 char = original[i];
            // Check if character is uppercase A-Z
            if (char >= 0x41 && char <= 0x5A) {
                // Convert to lowercase by adding 32
                result[i] = bytes1(uint8(char) + 32);
            } else {
                result[i] = char;
            }
        }
        return string(result);
    }

    function isAsciiOnly(string memory str) internal pure returns (bool) {
        bytes memory input = bytes(str);
        for (uint i = 0; i < input.length; i++) {
            // Check ASCII range (0x00 to 0x7F)
            if (input[i] > 0x7F) {
                return false;
            }
        }
        return true;
    }
    
     function isAlphanumeric(string memory str) internal pure returns (bool) {
        bytes memory input = bytes(str);

        for (uint i = 0; i < input.length; i++) {
            bytes1 char = input[i];
            bool isDigit    = (char >= 0x30 && char <= 0x39); // '0'-'9'
            bool isUpper    = (char >= 0x41 && char <= 0x5A); // 'A'-'Z'
            bool isLower    = (char >= 0x61 && char <= 0x7A); // 'a'-'z'

            if (!(isDigit || isUpper || isLower)) {
                return false; // If any character is not alphanumeric, return false immediately
            }
        }

        // If we reach here, all characters are alphanumeric
        return true;
    }
 

}