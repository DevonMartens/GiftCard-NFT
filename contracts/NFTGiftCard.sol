// SPDX-License-Identifier: ISC

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "erc721a/contracts/ERC721A.sol";

contract NFTGiftCard is ERC721A, 
Ownable 
//SpendingToken 
{
    constructor(string memory _name, string memory _symbol, string memory baseTokenURI, uint32 maxTokenSupply)
      ERC721A(_name, _symbol){}

}