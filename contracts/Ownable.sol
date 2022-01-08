// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

contract Ownable {

    address public owner;
  
    modifier onlyOwner {
      require(msg.sender == owner, "Ownable: You are not the owner, Bye.");
      _;
    }
  
    constructor () {
      owner = msg.sender;
    }
  }