const { ethers } = require("hardhat"); 

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const TestToken = await ethers.getContractFactory("TestToken");
    const token = await TestToken.deploy(ethers.utils.parseEther("1000000"));
    console.log("Token deployed to:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });