pragma solidity ^0.8.0;

library LibRandomSelection {
    function randomSelection(uint256[] memory items, uint256 numItems) internal view returns (uint256[] memory) {
        require(numItems <= items.length, "Not enough items in the array.");

        uint256[] memory selectedItems = new uint256[](numItems);
        bool[] memory selected = new bool[](items.length);

        uint256 counter = 0;

        for (uint256 i = 0; i < numItems; i++) {
            uint256 index = _random(counter) % items.length;

            // Find a non-selected item
            while (selected[index]) {
                index = (index + 1) % items.length;
            }

            selectedItems[i] = items[index];
            selected[index] = true;
            counter++;
        }

        return selectedItems;
    }

    function randomSelectionWithExclusions(
        uint256[] memory items,
        uint256 numItems,
        uint256[] memory exclusions
    ) internal view returns (uint256[] memory) {
        require(numItems <= items.length, "numItems exceeds the number of items in the array.");
        require(exclusions.length <= items.length, "Exclusion list exceeds the number of items.");
        
        bool[] memory isExcluded = new bool[](items.length);
        uint256 availableItems = items.length;

        // Mark excluded items and count how many valid items remain
        for (uint256 i = 0; i < items.length; i++) {
            for (uint256 j = 0; j < exclusions.length; j++) {
                if (items[i] == exclusions[j]) {
                    isExcluded[i] = true;
                    availableItems--;
                    break;
                }
            }
        }

        // Ensure there are enough non-excluded items to select from
        if(numItems > availableItems) {
            return new uint256[](0);
        }

        uint256[] memory selectedItems = new uint256[](numItems);
        bool[] memory selected = new bool[](items.length);

        uint256 counter = 0;

        for (uint256 i = 0; i < numItems; i++) {
            uint256 index = _random(counter) % items.length;

            // Find a non-selected and non-excluded item
            while (selected[index] || isExcluded[index]) {
                index = (index + 1) % items.length;
            }

            selectedItems[i] = items[index];
            selected[index] = true;
            counter++;
        }

        return selectedItems;
    }

    function _random(uint256 salt) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.number, block.timestamp, msg.sender, salt)));
    }
}
