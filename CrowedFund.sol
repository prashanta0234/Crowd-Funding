// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0<0.9.0;

contract CrowedFund{
    address public manager;
    uint public RaisedAmount;
    uint public minimumcontribution;
    uint public deadLine;
    uint public noOfContributors;
    mapping(address=>uint) public contributors;
    constructor(uint _time,uint _amount,uint _contributaion){
        manager=msg.sender;
        deadLine=block.timestamp+_time;
        RaisedAmount=_amount;
        minimumcontribution=_contributaion;
    }
    modifier isManger(){
        require(manager==msg.sender,"Sorry You are not Manager");
        _;
    }
    function sendCrypto() payable public{
        require(block.timestamp<deadLine,"Time is Over");
        require(msg.value>= minimumcontribution,"Please send minimum Balance");
        if(contributors[msg.sender]==0){
            noOfContributors++;
        }
        contributors[msg.sender]=msg.value;
        RaisedAmount+=msg.value;
    }
    function checkBalance() public view isManger returns(uint _balance){
        _balance=address(this).balance;
    }

}