// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";

contract EscrowList {
    struct Transaction {
        uint256 id;
        address depositor;
        address mediater;
        address beneficiary;
        uint256 amount;
        uint256 timestamp;
        bool isApproved;
    }
    Transaction[] public transactions;

    function newEscrow(address _mediater, address _beneficiary)
        external
        payable
    {
        require(msg.value > 0);
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

    function getListEscrows() public view returns (Transaction[] memory) {
        uint256 length = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].depositor == msg.sender) {
                length++;
            }
        }
        Transaction[] memory temp = new Transaction[](length);
        length = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].depositor == msg.sender) {
                temp[length] = transactions[i];
                length++;
            }
        }
        return temp;
    }

    function getListEscrowsToApprove()
        public
        view
        returns (Transaction[] memory)
    {
        uint256 length = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].mediater == msg.sender) {
                length++;
            }
        }
        Transaction[] memory temp = new Transaction[](length);
        length = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].mediater == msg.sender) {
                temp[length] = transactions[i];
                length++;
            }
        }
        return temp;
    }

    event EscrowApproved(uint256);

    function approveEscrow(uint256 _id) external {
        Transaction memory temp;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].id == _id) {
                temp = transactions[i];
            }
        }
        require(temp.id > 0, "Transaction not found");
        require(msg.sender == temp.mediater, "Only the mediater can approve it");
        (bool sent, ) = payable(temp.beneficiary).call{value: temp.amount}("");
        require(sent, "Failed to send Ether");
        transactions[_id - 1].isApproved = true;
        emit EscrowApproved(_id);
    }

    function getEscrow(uint256 _id)
        external
        view
        returns (Transaction memory temp)
    {
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].id == _id) {
                temp = transactions[i];
            }
        }
    }
}
