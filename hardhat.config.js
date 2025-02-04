require("@nomicfoundation/hardhat-toolbox");
require("solidity-docgen");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  docgen: {
    outputDir: "./docs/contracts",
    pages: "items",
    exclude: ["./test"],
  },
};
