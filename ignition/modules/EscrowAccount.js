const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("EscrowAccount", (m) => {
  // Define constructor parameters if required (e.g., seller address, ERC-20 token address)
  const buyer = m.getAccount(1); // Assuming seller is the second account
  const seller = m.getAccount(2); // Assuming seller is the third account
  const tokenAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"; // Replace with actual deployed ERC-20 token address

  // Deploy the Escrow contract
  const escrow = m.contract("EscrowAccount", [buyer, seller, tokenAddress]);

  return { escrow };
});