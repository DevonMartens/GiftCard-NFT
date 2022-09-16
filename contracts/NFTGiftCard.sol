// SPDX-License-Identifier: ISC

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NFTGiftCard is ERC721, ReentrancyGuard, Ownable {
/*@Dev: The variables below are for the counters to track the token variables and for handling strings.*/
    using Counters for Counters.Counter;
    using Strings for uint256;
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 maxSupply,
        uint256 maxPurchase,
        bytes32  root, 
        uint256 price)
        ERC721(_name, _symbol)
        {
            _root = root;
            _maxPurchase = maxPurchase;
            _maxSupply = maxSupply;
            _price = price;
    }

    /*@Dev: This is the counter to track tokens.*/
    Counters.Counter public _tokenIdTracker;
    /*@Dev: This storage for the root.*/
    bytes32 public _root;
    /*@Dev: This storage for the max tokens a user can buy.*/
     uint256 public _maxPurchase;
    /*@Dev: This storage for the maxSupply of tokens*/
     uint256 public _maxSupply;
     /*@Dev: This storage for the price of the NFT.*/
     uint256 public _price;
     
     /*@Dev: These are the errors for reverts.*/
     error INSUFFICENT_FUNDS();
     error USER_PURCHASEMAX_REACHED();
     error MAXSUPPLY_REACHED();
     error INVALID_ADDRESS();


    /*@Dev: This is a aapping to connect token Id token URI.*/
    mapping (uint256 => string) private _tokenURI;

/*
     @Dev: Function to mint a token to an address via wallet.
     @Parms: numberOfTokens: The amount of tokens a user wishes to mint to thier wallets.
     @Parms: proof: The hashed result of all addresses allowed to make purchases in this contract
     @Notice: Merkle proof will use the poof and address to determine if it is allowed.
     @Notice: External wallet cannot purchase more than limit set by admin.
     @Dev: The person purchasing the token does not need to pass in the proof we will handle this part for them.
*/




  function safeMint(uint16 numberOfTokens, bytes32[] memory proof) public payable nonReentrant {
      if(isValid(proof, keccak256(abi.encodePacked(msg.sender)))) {
      revert INVALID_ADDRESS();
      }
      if(balanceOf(msg.sender) < _maxPurchase) {
          revert USER_PURCHASEMAX_REACHED();
      }
      if(_tokenIdTracker.current() + numberOfTokens <= _maxSupply)
      revert MAXSUPPLY_REACHED();
      if(msg.value >= _price * numberOfTokens) {
          revert INSUFFICENT_FUNDS();
      } 
        for(uint16 i = 0; i < numberOfTokens; i++) {
          _safeMint(msg.sender, _tokenIdTracker.current());
          _tokenIdTracker.increment();
        }
    }

    /*@Dev: Checks if an address is allowed to the allowlist.*/
    function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
        return MerkleProof.verify(proof, _root, leaf);
    }

