// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    address public admin;

    constructor(uint256 initialSupply) ERC20("SimpleToken", "STK") {
        admin = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    function mint(address account, uint256 amount) public {
        require(msg.sender == admin, "Only admin can mint");
        _mint(account, amount);
    }
}