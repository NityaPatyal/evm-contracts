const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VotingSystem Contract", function () {
  let VotingSystem, voting, owner, voter1, voter2;

  beforeEach(async function () {
    [owner, voter1, voter2] = await ethers.getSigners(); // Get test accounts

    VotingSystem = await ethers.getContractFactory("VotingSystem");
    voting = await VotingSystem.deploy();
    await voting.waitForDeployment();
  });

  it("Should deploy with correct admin", async function () {
    expect(await voting.admin()).to.equal(owner.address);
  });

  it("Should allow admin to start and stop voting", async function () {
    await voting.toggleVoting();
    expect(await voting.votingActive()).to.equal(true);

    await voting.toggleVoting();
    expect(await voting.votingActive()).to.equal(false);
  });

  it("Should allow admin to add voters", async function () {
    await voting.addVoter(voter1.address);
    expect(await voting.voters(voter1.address)).to.equal(true);
  });

  it("Should allow admin to create proposals", async function () {
    await voting.createProposal("Proposal 1");
    const proposal = await voting.proposals(0);

    expect(proposal.name).to.equal("Proposal 1");
    expect(proposal.voteCount).to.equal(0);
  });

  it("Should allow registered voters to vote", async function () {
    await voting.toggleVoting(); // Start voting
    await voting.addVoter(voter1.address);
    await voting.createProposal("Proposal 1");

    await voting.connect(voter1).vote(0); // Voter1 votes for proposal 0
    const proposal = await voting.proposals(0);

    expect(proposal.voteCount).to.equal(1);
    await expect(voting.connect(voter1).vote(0)).to.be.revertedWithCustomError(
        voting,
        "AlreadyVoted"
      );
  });

  it("Should not allow double voting", async function () {
    await voting.toggleVoting();
    await voting.addVoter(voter1.address);
    await voting.createProposal("Proposal 1");

    await voting.connect(voter1).vote(0);

    await expect(voting.connect(voter1).vote(0)).to.be.revertedWithCustomError(
      voting,
      "AlreadyVoted"
    );
  });

  it("Should not allow unregistered users to vote", async function () {
    await voting.toggleVoting();
    await voting.createProposal("Proposal 1");

    await expect(voting.connect(voter1).vote(0)).to.be.revertedWithCustomError(
      voting,
      "NotRegisteredVoter"
    );
  });

  it("Should declare the correct winning proposal", async function () {
    await voting.toggleVoting();
    await voting.addVoter(voter1.address);
    await voting.addVoter(voter2.address);

    await voting.createProposal("Proposal 1");
    await voting.createProposal("Proposal 2");

    await voting.connect(voter1).vote(0); // vote for proposal 0
    await voting.connect(voter2).vote(0); // vote for proposal 0
    await voting.connect(voter1).vote(1); // vote for proposal 1

    expect(await voting.winningProposal()).to.equal("Proposal 1");
  });
});
