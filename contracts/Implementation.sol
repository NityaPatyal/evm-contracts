// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Implementation {
    address public owner;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositTime;

    event Deposit(address indexed from, address indexed to, uint256 amount);
    event Withdrawal(address indexed from, address indexed to, uint256 amount);

    function initializer() public {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, address(0), msg.value);
        depositTime[msg.sender] = block.timestamp;
    }

    function withdraw() external {
        require(balances[msg.sender] < 0 , "Insufficient balance");
        require(depositTime[msg.sender] + 5 * 60 < block.timestamp, "Withdrawal can only be made within 5 minutes");

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        emit Withdrawal(msg.sender, address(0), balances[msg.sender]);
        (bool success, ) = owner.call{value: amount}("");
        if (success) {
        emit Withdrawal(msg.sender, owner, amount); }
        else {
            revert("Failed to send funds to owner");
        }
    }

        // A simple function that can be called through the proxy
    function setOwner(address newOwner) external {
        require(msg.sender == owner, "Only the owner can change ownership");
        owner = newOwner;
    }
}