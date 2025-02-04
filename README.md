# Voting System Contract

## Introduction
The Voting System is a decentralized contract built on Ethereum that allows registered voters to participate in a secure and transparent voting process. The system is governed by an admin, who can manage the voting activity, register voters, and create proposals. Voters can cast their votes on available proposals, ensuring that each voter votes only once.

## Features
- Admin can start/stop the voting process.
- Admin can register voters and create proposals.
- Voters can cast a vote for a proposal.
- Only registered voters can vote, and each voter can only vote once.
- View the winning proposal after voting ends.

## Setup Instructions

### Prerequisites
- Node.js (v14 or above)
- npm

### Install Dependencies

```bash
npm install
```

### Running the Project

1. **Compile the Contracts**  
   First, compile the smart contracts to ensure they are correctly set up:
   ```bash
   npx hardhat compile

2. **Deploy the Contract**
    You can deploy the contract to the local Hardhat network:

    ```bash
    npx hardhat run scripts/deploy.js --network hardhat
    ```

    If you want to deploy it on a test network like Rinkeby, Goerli, or any other, you’ll need to configure your network in hardhat.config.js and run the following:

    ```bash
    npx hardhat run scripts/deploy.js --network <network-name>
    ```

3. **Interact with the Contract**
    After deploying the contract, you can interact with it via Hardhat console or through a frontend integration. For example, to interact with the contract in Hardhat's interactive console:

    ```bash
    npx hardhat console --network hardhat
    ```
    Inside the console, you can call contract methods like:

    ```javascript
    const votingSystem = await ethers.getContractAt("VotingSystem", "<deployed_contract_address>");
    await votingSystem.toggleVoting();
    ```