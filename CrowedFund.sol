// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0<0.9.0;

contract CrowedFund{
    address public manager;
    uint public RaisedAmount;
    uint public minimumcontribution;
    uint public deadLine;
    uint public noOfContributors;
    uint public amount;
    mapping(address=>uint) public contributors;
    // for creating Request
    struct Request{
        string description;
        address payable recipent;
        uint value;
        bool complited;
        uint numOfVoters;
        mapping(address=>bool) voters;
    }
    // for request
    mapping(uint=>Request) public requests;
    uint public noOfRequest;

    constructor(uint _time,uint _Raisedamount,uint _MinumumContribution){
        manager=msg.sender;
        deadLine=block.timestamp+_time;
        RaisedAmount=_Raisedamount;
        minimumcontribution=_MinumumContribution;
    }
    modifier isManger(){
        require(manager==msg.sender,"Sorry You are not Manager");
        _;
    }
    modifier isContributor(){
        require(contributors[msg.sender]!=0,"Sorry You are not eligible");
        _;

    }
    function sendCrypto() payable public{
        require(block.timestamp<deadLine,"Time is Over");
        require(msg.value>= minimumcontribution,"Please send minimum Balance");
        if(contributors[msg.sender]==0){
            noOfContributors++;
        }
        contributors[msg.sender]=msg.value;
        amount+=msg.value;
    }
    function checkBalance() public isManger  view returns(uint _balance){
        _balance=address(this).balance;
    }
    function refund() public isContributor{
        require(block.timestamp>deadLine && RaisedAmount> amount,"Sorry refund not Possible");
       
        address payable user=payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;
    }
    function makeARequest(string memory _description,uint _amount,address _recipent)  public isManger{
        Request storage newRequest=requests[noOfRequest];
        noOfRequest++;
        newRequest.description=_description;
        newRequest.value=_amount;
        newRequest.recipent=payable(_recipent);
        newRequest.complited=false;
        newRequest.numOfVoters=0;

    }
    function vote(uint _requestId) public isContributor{
       Request storage votingRequest= requests[_requestId];
       require(votingRequest.voters[msg.sender]==false,"You already vated");
       votingRequest.voters[msg.sender]=true;
       votingRequest.numOfVoters++;
    }
    function makePayment(uint _noOfRequest) public isManger{
        require(RaisedAmount<amount);
        Request storage thisRequest=requests[_noOfRequest];
        require(thisRequest.complited==false,"This account already paid");
        require(thisRequest.numOfVoters>noOfContributors/2);
        thisRequest.recipent.transfer(thisRequest.value);
        thisRequest.complited=true;
        
    }

}