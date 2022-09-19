// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Access {

    /*
    @Dev: Mapping to connect contract addresses with a true value
    */ 

    
    
    mapping(address => bool) public isGames;
//will use to check if address is rewards when deployer is created
    mapping(address => bool) public isRewards;


}