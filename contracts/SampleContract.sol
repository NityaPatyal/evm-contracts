// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract SampleContract {

    address owner;
    mapping(address => uint256) public balances;
    
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed sender, uint256 amount);
    event ContractDestroyed();

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert("Failed to withdraw funds");
        }
        emit Withdrawn(msg.sender, amount);

    }

    function destroyContract() public onlyOwner{
        emit ContractDestroyed();
    // "selfdestruct" has been deprecated. Note that, starting from the Cancun hard fork, the underlying opcode no longer deletes the code and data associated with an account and only transfers its Ether to the beneficiary, unless executed in the same transaction in which the contract was created (see EIP-6780). Any use in newly deployed contracts is strongly discouraged even if the new behavior is taken into account. Future changes to the EVM might further reduce the functionality of the opcode
        selfdestruct(payable(msg.sender));
    }

    receive() external payable {
        deposit();
    }
}