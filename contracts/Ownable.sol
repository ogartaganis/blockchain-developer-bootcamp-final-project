// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

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