pragma solidity ^0.8.0;
// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)

//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {IWETH9, IWETH9WithdrawTo} from  "../interfaces/IWETH9.sol";
 
 
contract SoftToken is ERC20Pausable, Ownable, IWETH9, IWETH9WithdrawTo {

    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }
    
    function withdraw(uint wad) public {
        require(balanceOf(msg.sender) >= wad, "Insufficient balance");
        _burn(msg.sender, wad);
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function withdrawTo(address to, uint256 wad) public {
        require(balanceOf(msg.sender) >= wad, "Insufficient balance");
        _burn(msg.sender, wad);
        payable(to).transfer(wad);
        emit Withdrawal(to, wad);
    }
}
