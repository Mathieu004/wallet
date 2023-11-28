// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Owner.sol";

contract Wallet is Owner {

    struct Payement {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numPayements;
        mapping(uint => Payement) payements;
    }

    mapping(address => Balance) Wallets;

    function getBalance() public isOwner view returns(uint) {
        return address(this).balance;
    }

    function withDrawAllMoney(address payable _to) public {
        uint amount = Wallets[msg.sender].totalBalance;
        Wallets[msg.sender].totalBalance = 0;
        _to.transfer(amount);  
    }

    function withDrawMoney(address payable _to, uint _amount) public {
        uint amount = Wallets[msg.sender].totalBalance;
        require(_amount <= amount, "You dont avec enough money");
        Wallets[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }

    receive() external payable {
        Payement memory thisPayement = Payement(msg.value, block.timestamp);
        Wallets[msg.sender].totalBalance += msg.value;
        Wallets[msg.sender].payements[Wallets[msg.sender].numPayements]= thisPayement;
        Wallets[msg.sender].numPayements ++;
    }

}