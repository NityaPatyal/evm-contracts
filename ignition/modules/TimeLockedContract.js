const {buildModule} = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("TimeLockedContract", (m) => {
    
    // Deploy the TimeLockedContract contract
    const timeLockedContract = m.contract("TimeLockedContract", []);

    return { timeLockedContract };
});