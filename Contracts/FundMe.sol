//Get funds from users
//Withdraw funds
//set a minimum funding values

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "./PriceConverter.sol";
contract FundMe
{

    using PriceConvertor for uint256;

    address[] public funders;
    mapping(address => uint) public addressToamountFunded;

    uint256 public minimumUSD = 50*1e18;

    address public owner;

    constructor()
    {
        owner = msg.sender;
    }

    function fund() public payable
    {

        require(msg.value.getConversionRate() >= minimumUSD,"Didn't Sent Enough");
        funders.push(msg.sender);
        addressToamountFunded[msg.sender] = msg.value;

    }

    function withdraw() public onlyOwner
    {
        
        for(uint256 i = 0; i< funders.length;i++)
        {
            address funder = funders[i];
            addressToamountFunded[funder] = 0;
        }

        funders = new address[](0);

        //transfer
        //payable(msg.sender).transfer(address(this).balance);// converting to payable address
        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess,"Send failed");
        //call

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Send failed");

    }

    modifier onlyOwner
    {
        require(msg.sender == owner,"Sender is not owner");
        _;
    }

    

}