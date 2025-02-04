# Solidity API

## VotingSystem

This contract allows users to vote on proposals. The admin can register voters, create proposals, and start/stop the voting process.

_The contract uses custom errors for better gas efficiency and events for tracking important actions._

### admin

```solidity
address admin
```

### votingActive

```solidity
bool votingActive
```

### Proposal

_A struct that holds details about a proposal_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct Proposal {
  string name;
  uint256 voteCount;
}
```

### voters

```solidity
mapping(address => bool) voters
```

### proposals

```solidity
mapping(uint256 => struct VotingSystem.Proposal) proposals
```

### voted

```solidity
mapping(address => mapping(uint256 => bool)) voted
```

### proposalCount

```solidity
uint256 proposalCount
```

### OnlyAdminAllowed

```solidity
error OnlyAdminAllowed()
```

### VotingNotActive

```solidity
error VotingNotActive()
```

### AlreadyVoted

```solidity
error AlreadyVoted()
```

### NotRegisteredVoter

```solidity
error NotRegisteredVoter()
```

### InvalidProposal

```solidity
error InvalidProposal()
```

### NoProposalsAvailable

```solidity
error NoProposalsAvailable()
```

### VotingStarted

```solidity
event VotingStarted()
```

### VotingStopped

```solidity
event VotingStopped()
```

### VoterRegistered

```solidity
event VoterRegistered(address voter)
```

### ProposalCreated

```solidity
event ProposalCreated(uint256 proposalId, string name)
```

### WinnerDeclared

```solidity
event WinnerDeclared(string name, uint256 votes)
```

### Voted

```solidity
event Voted(address user, uint256 proposalId)
```

### onlyAdmin

```solidity
modifier onlyAdmin()
```

_Ensures that only the admin can call the function_

### onlyWhenVotingActive

```solidity
modifier onlyWhenVotingActive()
```

_Ensures that the function is only called when voting is active_

### onlyOnce

```solidity
modifier onlyOnce(uint256 proposalId)
```

_Ensures that a user can only vote once on a specific proposal_

### constructor

```solidity
constructor() public
```

### toggleVoting

```solidity
function toggleVoting() public
```

Toggles the voting state (active/inactive)

_Only the admin can toggle the voting state_

### addVoter

```solidity
function addVoter(address _voter) public
```

Registers a new voter

_Only the admin can register voters_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _voter | address | The address of the voter to register |

### createProposal

```solidity
function createProposal(string _name) public
```

Creates a new proposal

_Only the admin can create proposals_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _name | string | The name of the proposal |

### vote

```solidity
function vote(uint256 proposalId) public
```

Allows a registered voter to vote on a proposal

_A voter can only vote once per proposal and only when voting is active_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| proposalId | uint256 | The ID of the proposal to vote for |

### getProposalVotes

```solidity
function getProposalVotes(uint256 proposalId) public view returns (uint256)
```

Returns the vote count for a specific proposal

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| proposalId | uint256 | The ID of the proposal |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The number of votes the proposal has received |

### winningProposal

```solidity
function winningProposal() public view returns (string)
```

Returns the name of the proposal with the most votes

_Reverts if no proposals are available_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The name of the winning proposal |

