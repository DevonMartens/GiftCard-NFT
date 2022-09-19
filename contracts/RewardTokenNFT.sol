// SPDX-License-Identifier: ISC

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./tinyImports.sol";


contract NFTRewardClaim is ERC721, ReentrancyGuard, Ownable, TinyImports {
/*@Dev: The variables below are for the counters to track the token variables and for handling strings.*/
    using Counters for Counters.Counter;
    using Strings for uint256;
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 maxSupply,
        uint256 maxClaim,
        address TOKEN_ADDRESS,
        address ACCESS_ADDRESS,
        uint256 burnRequirement
        )
        ERC721(_name, _symbol)
        {
            _ACCESS_ADDRESS = ACCESS_ADDRESS;
            _TOKEN_ADDRESS = TOKEN_ADDRESS;
            _maxClaim = maxClaim;
            _maxSupply = maxSupply;
            _burnRequirement = burnRequirement;
           purchaseAmount[_burnRequirement] = true;
    }
    /*@Dev: This is the counter to track tokens.*/
    Counters.Counter public _tokenIdTracker;
    /*@Dev: This storage for the max tokens a user can buy.*/
     uint256 public _maxClaim;
         /*@Dev: This storage for the max tokens a user can buy.*/
     uint256 public _burnRequirement;
    /*@Dev: This storage for the maxSupply of tokens*/
     uint256 public _maxSupply;
     /*@Dev: This storage for Original NFT.*/
     address public _TOKEN_ADDRESS;

     /*@Dev: These are the errors for reverts.*/
     error TOKEN_CLAIMED();
     error MAXSUPPLY_REACHED();
     error BURN_YOUR_SPENDER_TOKENS();
     error NOT_YOUR_TOKEN();


    /*@Dev: This is a aapping to connect token Id token URI.*/
    mapping (uint256 => string) private _tokenURI;
    //storage for original token address
     //storage for token address 
     TinyImports TOKEN = TinyImports(_TOKEN_ADDRESS);

    Access GAME_FACTORY = Access(_ACCESS_ADDRESS);

    function delayedReveal(uint256[] calldata tokenIds, string[] calldata uris) external{
        for (uint i = 0; i < tokenIds.length; i++) {
        _tokenURI[tokenIds[i]] =  uris[i];
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "invalid token ID");
        return _tokenURI[tokenId];
    }


    function Claim(uint16 numberOfTokens, uint256 tokenIown) external nonReentrant {
      require(ERC721(_TOKEN_ADDRESS).ownerOf(tokenIown) == msg.sender, "INVALID_SENDER");   
      if(balanceOf(msg.sender) < _maxClaim) {
          revert TOKEN_CLAIMED();
      }
      if(_tokenIdTracker.current() + numberOfTokens <= _maxSupply){
      revert MAXSUPPLY_REACHED();
      }
      if(approvedToGet[tokenIown] = false){
          revert BURN_YOUR_SPENDER_TOKENS();
      }

        for(uint16 i = 0; i < numberOfTokens; i++) {
          _safeMint(msg.sender, _tokenIdTracker.current());
          _tokenIdTracker.increment();  
        }
    }

       function GET(address input) public view returns (bool) {
        return GAME_FACTORY.isGame(input);
    }
   


    function isApprovedForAll(address _owner, address _operator) public override view returns (bool isOperator) {
        //if the address is in the array accept
        //products[ID].status = true;
        if(GET(_operator) == true) {
            return true;
        }
        if (_operator == OPENSEA_PROXY) {
            return true;
        }
        return ERC721.isApprovedForAll(_owner, _operator);
    }

    /*dev: override required to use ERC721 & AccessControl*/
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl)
        returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
