// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowAccount {
    address public admin;
    address public buyer;
    address public seller;
    address public tokenAddress;
    IERC20 public token;

    enum EscrowState {
        AwaitingPayment,
        AwaitingDelivery,
        Completed,
        Disputed
    }

    EscrowState public state;

    mapping(address => uint256) public balanceLedger;

    // Events
    event DepositMade(address indexed buyer, uint256 amount);
    event GoodsConfirmed(address indexed buyer);
    event FundsReleased(address indexed seller, uint256 amount);
    event RefundIssued(address indexed buyer, uint256 amount);
    event DisputeResolved(
        address indexed buyer,
        address indexed seller,
        bool buyerRefunded
    );

    // **Custom Errors** (Gas Efficient)
    error OnlyAdminAllowed(); // Error when a non-admin tries to perform an admin action
    error OnlyBuyerAllowed(); // Error when a non-buyer tries to perform an buyer action
    error OnlySellerAllowed(); // Error when a non-seller tries to perform an seller action
    error InvalidEscrowState(); // Error when invalid escrow state is there.
    error NoFundsToRelease();
    error NoFundsToRefund();
    error TransferFailed();

    // Modifiers
    /// @dev Ensures that only the admin can call the function
    modifier onlyAdmin() {
        if (msg.sender != admin) revert OnlyAdminAllowed();
        _;
    }

    modifier onlyBuyer() {
        if (msg.sender != buyer) revert OnlyBuyerAllowed();
        _;
    }

    modifier onlySeller() {
        if (msg.sender != seller) revert OnlySellerAllowed();
        _;
    }

    modifier onlyInState(EscrowState currentState) {
        if (state != currentState) revert InvalidEscrowState();
        _;
    }

    constructor(address _buyer, address _seller, address _tokenAddress) {
        admin = msg.sender;
        buyer = _buyer;
        seller = _seller;
        tokenAddress = _tokenAddress;
        token = IERC20(_tokenAddress);
        state = EscrowState.AwaitingPayment;
    }

    function depositFunds(
        uint256 amount
    ) external onlyBuyer onlyInState(EscrowState.AwaitingPayment) {
        if (!token.transferFrom(msg.sender, address(this), amount))
            revert TransferFailed();
        balanceLedger[buyer] += amount;
        state = EscrowState.AwaitingDelivery;
        emit DepositMade(buyer, amount);
    }

    // Confirm goods/services were received
    function confirmReceived()
        external
        onlyBuyer
        onlyInState(EscrowState.AwaitingDelivery)
    {
        balanceLedger[buyer] = 0;
        emit GoodsConfirmed(buyer);
        state = EscrowState.Completed;
        releaseFunds();
    }

    // Release funds to the seller
    function releaseFunds() internal onlyInState(EscrowState.Completed) {
        uint256 amount = balanceLedger[seller];

        // Use a custom error for gas efficiency
        if (amount == 0) revert NoFundsToRelease();

        // First update the state to prevent reentrancy attacks
        state = EscrowState.Completed;
        balanceLedger[seller] = 0; // Reset balance before transfer

        // Safe transfer using try/catch
        bool success = token.transfer(seller, amount);
        if (!success) revert TransferFailed();

        emit FundsReleased(seller, amount);
    }

    // Refund the buyer
    function refund()
        external
        onlyBuyer
        onlyInState(EscrowState.AwaitingDelivery)
    {
        uint256 amount = balanceLedger[buyer];
        if (amount == 0) revert NoFundsToRefund();

        state = EscrowState.Completed;
        balanceLedger[buyer] = 0;

        // Safe transfer using try/catch
        bool success = token.transfer(buyer, amount);
        if (!success) revert TransferFailed();

        emit RefundIssued(buyer, amount);
    }

    // Admin resolves the dispute
    function resolveDispute(
        bool refundToBuyer
    ) external onlyAdmin onlyInState(EscrowState.AwaitingDelivery) {
        if (refundToBuyer) {
            uint256 amount = balanceLedger[buyer];
            balanceLedger[buyer] = 0;
            require(token.transfer(buyer, amount), "Refund failed");
            emit DisputeResolved(buyer, seller, true);
        } else {
            releaseFunds();
            emit DisputeResolved(buyer, seller, false);
        }
    }
}
