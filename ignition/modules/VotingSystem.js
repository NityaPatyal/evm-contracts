const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("VotingSystemModule", (m) => {
  // Deploy the VotingSystem contract
  const votingContract = m.contract("VotingSystem");

  return { votingContract };
});