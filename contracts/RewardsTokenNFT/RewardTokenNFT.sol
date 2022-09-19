// SPDX-License-Identifier: ISC

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./tinyImports.sol";


contract NFTRewardClaim is ERC721, ReentrancyGuard, AccessControl, TinyImports {
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
           _grantRole(ADMIN_ROLE, 0xce1dfc3F67B028Ed19a97974F8cD2bAF6fba1672);
           _grantRole(MINTER_ROLE, 0xce1dfc3F67B028Ed19a97974F8cD2bAF6fba1672);
    }
    /*@Dev: This is the counter to track tokens.*/
    Counters.Counter public _tokenIdTracker;
    /*@Dev: This storage for the max tokens a user can buy.*/
     uint256 public _maxClaim;
    /*@Dev: This storage for the max tokens a user can buy.*/
     uint256 public _burnRequirement;
    /*@Dev: This storage for the maxSupply of tokens*/
     uint256 public _maxSupply;
     /*@Dev: This storage for Original NFT address.*/
     address public _TOKEN_ADDRESS;
    /*@Dev: This storage for game factory address.*/
     address public _ACCESS_ADDRESS;

     /*@Dev: These are the errors for reverts.*/
     error TOKEN_CLAIMED();
     error MAXSUPPLY_REACHED();
     error BURN_YOUR_SPENDER_TOKENS();
     error NOT_YOUR_TOKEN();
    
    /*
    @Dev: Access controls - granted by deployer of contract.
    */
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");


    /*@Dev: This is a mapping to connect token Id token URI.*/
    mapping (uint256 => string) private _tokenURI;
    /*@Dev: Storage for for original token address*/
    TinyImports TOKEN = TinyImports(_TOKEN_ADDRESS);
    /*@Dev: Storage for game factory address*/
    Access GAME_FACTORY = Access(_ACCESS_ADDRESS);
    event revealed(uint256[] tokenIds);
    
    /*
    @Dev: This is the function for the delayed reveal of the NFT's. Will implement VRF in future.
    @Params: tokenIds are the tokens that are being revealed uris are the URIs.
    */
    function delayedReveal(uint256[] calldata tokenIds, string[] calldata uris) external onlyRole(MINTER_ROLE){
        for (uint i = 0; i < tokenIds.length; i++) {
        _tokenURI[tokenIds[i]] =  uris[i];
        emit revealed(tokenIds);
        }
    }
    
    /*
    @Dev: Override to set URIs.
    */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "invalid token ID");
        return _tokenURI[tokenId];
    }

        
    /*
    @Dev: Function to claim tokens if user has burned enough ERC20 to earn them.
    @Notice: This function makes a call to the other contract to check if the owner of the gift token has burned tokens.
    @Params: Number of tokens if how many tokens the user can mint. 
    @Notice The user is only allowed to mint so many based on _maxClaim initalized in the constructor.
    @Params: Token I woner refers to the original NFT minted "gift card" checks if the sender owns that token.
    */
    function Claim(uint16 numberOfTokens, uint256 tokenIown) external nonReentrant {
      require(ERC721(_TOKEN_ADDRESS).ownerOf(tokenIown) == msg.sender, "INVALID_SENDER");   
      if(balanceOf(msg.sender) + numberOfTokens <= _maxClaim) {
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
    /*
    @Dev:Checks if the game deployer deployed a contract address. If yes it can move those tokens.
    */
       function GET(address input) public view returns (bool) {
        return GAME_FACTORY.isGame(input);
    }
   
    function isApprovedForAll(address _owner, address _operator) public override view returns (bool isOperator) {
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
