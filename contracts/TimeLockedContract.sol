// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract TimeLockedContract {

    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositTime;

    event Deposited(address indexed sender, uint256 amount);
    event TimeLocked(address indexed sender, uint256 amount, uint256 depositTime);

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");

        uint256 amount = msg.value;
        balances[msg.sender] += amount;
        emit Deposited(msg.sender, amount);

        depositTime[msg.sender] = block.timestamp; // Lock deposit for 24 hours

        emit TimeLocked(msg.sender, amount, depositTime[msg.sender]);

    }

    function withdraw() external {
        require(balances[msg.sender] > 0, "No deposit found");
        require(block.timestamp > depositTime[msg.sender] + 5 * 60, "Time locked");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] -= amount;

        (bool success,) =payable(msg.sender).call{value: amount}("");      
        require(success, "Withdrawal failed");          
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function isLocked() external view returns (bool) {
        return block.timestamp <= depositTime[msg.sender] + 5 * 60; // 5 minutes
    }

}