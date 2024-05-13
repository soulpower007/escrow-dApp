// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

// Import the Hardhat console for debugging purposes.
import "hardhat/console.sol";

// Define a smart contract called EscrowList for managing escrow transactions.
contract EscrowList {
    // Define a structure for an escrow transaction.
    struct Transaction {
        uint256 id;           // Unique identifier for the transaction.
        address depositor;    // Address of the person who deposits funds.
        address mediater;     // Mediator's address who can approve the transaction.
        address beneficiary;  // Address of the beneficiary who receives funds if approved.
        uint256 amount;       // Amount of ether (in wei) held in escrow.
        uint256 timestamp;    // Block number when the transaction was created.
        bool isApproved;      // Status of the transaction approval.
    }
    // Declare an array to store all escrow transactions.
    Transaction[] public transactions;

    // Function to create a new escrow transaction.
    function newEscrow(address _mediater, address _beneficiary)
        external
        payable
    {
        // Ensure the transaction has some ether to lock in escrow.
        require(msg.value > 0);
        // Add the new transaction to the array.
        transactions.push(
            Transaction(
                transactions.length + 1,
                msg.sender,
                _mediater,
                _beneficiary,
                msg.value,
                block.number,
                false
            )
        );
    }

    // Function to retrieve a list of escrow transactions initiated by the sender.
    function getListEscrows() public view returns (Transaction[] memory) {
        uint256 length = 0;
        // Calculate the number of transactions by the sender.
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].depositor == msg.sender) {
                length++;
            }
        }
        Transaction[] memory temp = new Transaction[](length);
        length = 0;
        // Collect all transactions initiated by the sender.
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].depositor == msg.sender) {
                temp[length] = transactions[i];
                length++;
            }
        }
        return temp;
    }

    // Function to retrieve a list of escrow transactions that the caller can approve.
    function getListEscrowsToApprove()
        public
        view
        returns (Transaction[] memory)
    {
        uint256 length = 0;
        // Calculate the number of transactions that the mediator can approve.
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].mediater == msg.sender) {
                length++;
            }
        }
        Transaction[] memory temp = new Transaction[](length);
        length = 0;
        // Collect all transactions that the mediator can approve.
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].mediater == msg.sender) {
                temp[length] = transactions[i];
                length++;
            }
        }
        return temp;
    }

    // Event declaration for when an escrow transaction is approved.
    event EscrowApproved(uint256);

    // Function to approve an escrow transaction.
    function approveEscrow(uint256 _id) external {
        Transaction memory temp;
        // Locate the transaction by ID.
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].id == _id) {
                temp = transactions[i];
            }
        }
        // Check that the transaction exists.
        require(temp.id > 0, "Transaction not found");
        // Ensure that only the mediator can approve the transaction.
        require(msg.sender == temp.mediater, "Only the mediater can approve it");
        // Attempt to send the locked funds to the beneficiary.
        (bool sent, ) = payable(temp.beneficiary).call{value: temp.amount}("");
        require(sent, "Failed to send Ether");
        // Mark the transaction as approved.
        transactions[_id - 1].isApproved = true;
        emit EscrowApproved(_id);
    }

    // Function to retrieve details of a specific escrow transaction by ID.
    function getEscrow(uint256 _id)
        external
        view
        returns (Transaction memory temp)
    {
        // Locate the transaction by ID.
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].id == _id) {
                temp = transactions[i];
            }
        }
    }
}
