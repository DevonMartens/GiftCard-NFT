// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract TinyImports {

    /*
    @Dev: Mapping to connect contract addresses with a true value
    */ 


    //NFT to Balance
    mapping(uint256 => uint256) public TokenIdToBalance;
    //tokens in NFT
    mapping(uint256 => uint256) public BalanceToTokenId;
    //checks for ownership
    mapping(address => uint256) public TokenOwner;
   //amount to burn
   mapping(uint256 => bool) public purchaseAmount;
   //NFT HolderApproved
   mapping(uint256 => bool) public approvedToGet;
   //last owner ner owner
   mapping(address => address) public LastOwnerNewOwner;


}