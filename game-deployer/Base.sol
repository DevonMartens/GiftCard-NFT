// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.4;

import "./Access.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";



contract Games is AccessControl, IERC721Receiver, Access, ReEntracyGuard {

/**  
================================================
|             Storage variables                |
================================================
**/

/*@Dev: Storage for the total NFT's wagered*/
uint256 public totalBet;

/*@Dev: Storage for the number of people in a game.*/
uint48 public people;
  
/*@Dev: Struct to store a token, that has been placed as a bet by the owner.*/ 
  struct Bet {
    uint24 tokenId;
    uint48 timestamp;
    address owner;
  }
/*@Dev: Struct to store the prediction of the game outcome.*/ 
  struct Game {
    bytes32 gameType;
    uint48 score;
    bytes32 winner;
  }

/**  
================================================
|             Storage for Errors              |
================================================
**/

  error IN_VAULT();
  error GAME_IN_PROGRESS_ALREADY();
  error BETS_PLACED();
  error ALL_BETS_MADE();

/**  
================================================
|  Storage for Constructor Init Variables      |
================================================
**/

  /*@Dev: Storage for variable setting game start time*/
  uint48 public _gameStart;
  /*@Dev: Storage for minium number of NFT'S to be wagered.*/
  uint48 public _minBet;
  /*@Dev: Storage for number of people allowed to play in a game.*/
  uint48 public _allowedUsers;
  /*@Dev: Storage for game type.*/
  bytes32 public _game; 
    /*
  @Dev: This will not have value until set i.e. 0 address. Confirmed at end of game.
  */

  address public confirmedWinner;


/**  
================================================
|                   Events                     |
================================================
**/

  event NFTAdded(address owner, uint256 tokenId, uint256 value);
  event NFTRemoved(address owner, uint256 tokenId, uint256 value);

/**  
================================================
|                  Mapping                      |
================================================
**/

  // maps tokenId to Bet
  mapping(uint256 => Bet) public vault; 
// mapping to allow those who have placed bets to set a struct on what they want to bet
  mapping(address => bool) public player; 

 //maps user to thier result of game guess
  mapping(address => Game) public Guess; 
  

   constructor(uint48 gameStart, uint48 _minBet, bytes32 game, uint48 allowedUsers) {
        gameStart =  _gameStart;
        minBet = _minBet;
        game = _game;
        allowedUsers = _allowedUsers;
  }

/**  
================================================
|                Game Functions                |
================================================
**/

   /*
   @Dev: Inputs address of NFT to bet and token Ids.
   @Notice: To play games with large bets you need to obtain a lot of tokens from one contract.
   */
  function bet(uint256[] calldata tokenIds, address calldata collectionAddress, uint48 score, bytes32 winner) external nonRenentrant {
    uint256 tokenId;
    totalBet += tokenIds.length;
    if(player[msg.sender] = true) {
      revert BETSPLACED();
    }
    if(people => _allowedUsers) {
      revert ALL_BETS_MADE();
    }
    require(GET(collectionAddress) == "INVALID_TOKEN");
    require(tokenIds.length == _minBet, "ADD_TOKENS");
    for (uint i = 0; i < tokenIds.length; i++) {
      tokenId = tokenIds[i];
      require(IERC721(collectionAddress).ownerOf(tokenId) == msg.sender, "INVALID_SENDER");
      if(vault[tokenId].tokenId == 0){
          revert IN_VAULT();
      }
      if(timestamp.now >= _gameStart){
          GAME_IN_PROGRESS_ALREADY();
      }

      IERC721(collectionAddress).transferFrom(msg.sender, address(this), tokenId);
      emit NFTAdded(msg.sender, tokenId, block.timestamp);

      vault[tokenId] = Bet({
        owner: msg.sender,
        tokenId: uint24(tokenId),
        timestamp: uint48(block.timestamp)
      });
        Guess[msg.sender] = Game({
          gameType: game;
         score: score;
         winner: winner;
      });
      player[msg.sender] = true;
      people++;
    }
  }

  /*
  @Dev:Checks if the deployer for the rewards contract deployed the contract producing the token that is being bet.
  @Notice: If yet the token can be placed as a bet.
  */

  function _winnerTakesTokens(address account, uint256[] calldata tokenIds,  address[] calldata orginalAddresses) external nonRentrant {
    require(msg.sender == confirmedWinner);  

    for (uint i = 0; i < tokenIds.length; i++) {
      tokenId = tokenIds[i];
      Bet memory bet = vault[tokenId];
      delete vault[tokenId];
      emit NFTRemoved(account, tokenId, block.timestamp);
      IERC721(orginalAddresses).transferFrom(address(this), account, tokenId);
    }
  }

  /*
  @Dev:Checks if the deployer for the rewards contract deployed the contract producing the token that is being bet.
  @Notice: If yet the token can be placed as a bet.
  */
  function GET(address input) public view returns (bool) {
        return REWARD_FACTORY.isReward(input);
    }
   

  function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
      require(from == address(0x0), "Cannot send nfts to Vault directly");
      return IERC721Receiver.onERC721Received.selector;
    }
  
}


