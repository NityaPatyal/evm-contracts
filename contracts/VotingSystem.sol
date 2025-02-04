// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Voting System Contract
/// @notice This contract allows users to vote on proposals. The admin can register voters, create proposals, and start/stop the voting process.
/// @dev The contract uses custom errors for better gas efficiency and events for tracking important actions.

contract VotingSystem {
    address public immutable admin; // The address of the admin (deployer)

    bool public votingActive = false; // Boolean to track if voting is active or not

    /// @dev A struct that holds details about a proposal
    /// @param name The name of the proposal
    /// @param voteCount The number of votes the proposal has received
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    // Mappings
    mapping(address => bool) public voters; // Tracks which addresses are registered voters
    mapping(uint256 => Proposal) public proposals; // Tracks proposals by their index
    mapping(address => mapping(uint256 => bool)) public voted; // Tracks whether a voter has voted for a specific proposal

    uint256 public proposalCount; // Keeps track of the number of proposals

    // **Custom Errors** (Gas Efficient)
    error OnlyAdminAllowed(); // Error when a non-admin tries to perform an admin action
    error VotingNotActive(); // Error when trying to vote while voting is not active
    error AlreadyVoted(); // Error when a user tries to vote more than once for a proposal
    error NotRegisteredVoter(); // Error when a non-registered voter tries to vote
    error InvalidProposal(); // Error when a proposal ID is invalid
    error NoProposalsAvailable(); // Error when there are no proposals to vote on

    // **Events** (For Better Tracking)
    event VotingStarted(); // Emitted when voting starts
    event VotingStopped(); // Emitted when voting stops
    event VoterRegistered(address indexed voter); // Emitted when a new voter is registered
    event ProposalCreated(uint256 indexed proposalId, string name); // Emitted when a new proposal is created
    event WinnerDeclared(string name, uint256 votes); // Emitted when a winning proposal is declared
    event Voted(address user, uint256 proposalId); // Emitted when a user votes on a proposal

    // Modifiers
    /// @dev Ensures that only the admin can call the function
    modifier onlyAdmin() {
        if (msg.sender != admin) revert OnlyAdminAllowed();
        _;
    }

    /// @dev Ensures that the function is only called when voting is active
    modifier onlyWhenVotingActive() {
        if (!votingActive) revert VotingNotActive();
        _;
    }

    /// @dev Ensures that a user can only vote once on a specific proposal
    modifier onlyOnce(uint256 proposalId) {
        if (voted[msg.sender][proposalId]) revert AlreadyVoted();
        _;
    }

    constructor() {
        admin = msg.sender; // Deployer becomes the admin
    }

    /// @notice Toggles the voting state (active/inactive)
    /// @dev Only the admin can toggle the voting state
    function toggleVoting() public onlyAdmin {
        votingActive = !votingActive;
        if (votingActive) {
            emit VotingStarted();
        } else {
            emit VotingStopped();
        }
    }

    /// @notice Registers a new voter
    /// @dev Only the admin can register voters
    /// @param voter The address of the voter to register
    function addVoter(address voter) public onlyAdmin {
        voters[voter] = true;
        emit VoterRegistered(voter);
    }

    /// @notice Creates a new proposal
    /// @dev Only the admin can create proposals
    /// @param name The name of the proposal
    function createProposal(string memory name) public onlyAdmin {
        proposals[proposalCount] = Proposal(name, 0);
        emit ProposalCreated(proposalCount, name);

        proposalCount++;
    }

    /// @notice Allows a registered voter to vote on a proposal
    /// @dev A voter can only vote once per proposal and only when voting is active
    /// @param proposalId The ID of the proposal to vote for
    function vote(uint256 proposalId) public onlyWhenVotingActive onlyOnce(proposalId) {
        if (!voters[msg.sender]) revert NotRegisteredVoter();
        if (proposalId >= proposalCount) revert InvalidProposal();

        // Cast the vote
        proposals[proposalId].voteCount++;
        voted[msg.sender][proposalId] = true; // Mark as voted for this proposal

        emit Voted(msg.sender, proposalId);
    }

    /// @notice Returns the vote count for a specific proposal
    /// @param proposalId The ID of the proposal
    /// @return The number of votes the proposal has received
    function getProposalVotes(
        uint256 proposalId
    ) public view returns (uint256) {
        require(proposalId < proposalCount, "Invalid proposal ID");
        return proposals[proposalId].voteCount;
    }

    /// @notice Returns the name of the proposal with the most votes
    /// @dev Reverts if no proposals are available
    /// @return The name of the winning proposal
    function winningProposal() public view returns (string memory) {
        if (proposalCount == 0) revert NoProposalsAvailable();

        uint256 maxVotes = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < proposalCount; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningIndex = i;
            }
        }

        return proposals[winningIndex].name;
    }
}
