// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoinReceiver is Ownable {
    IERC20 softToken;

    function setSoftToken(address softToken_) public onlyOwner {
        softToken = IERC20(softToken_);
    }


    function getSoftToken() public view returns (address) {
        return address(softToken);
    }

}
