// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract proxy {
    address public implementation;

    constructor (address implementationAddress) {
        implementation = implementationAddress;
    }

    // Fallback function to delegate calls to the implementation contract
    fallback() external {
        delegatecall(implementation);
    }

    function delegatecall(address implementationAddress) internal {
        // Low-level call to the implementation contract
        (bool success, ) = implementationAddress.delegatecall(msg.data);
        require(success, "Delegate call failed");

    }
}