// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.4;

import "./Access.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";



contract Games is AccessControl, IERC721Receiver, Access, ReEntracyGuard {

  uint256 public totalBet;

  //number of people in a game
  uint48 public people;
  
  // struct to store a token, that has been placed as a bet by the owner.
  struct Bet {
    uint24 tokenId;
    uint48 timestamp;
    address owner;
  }
// struct to store a token, that has been placed as a bet by the owner.
  struct Game {
    bytes32 gameType;
    uint48 score;
    bytes32 winner;
  }
  //storage for errors
  error IN_VAULT();
  error GAME_IN_PROGRESS_ALREADY();
  error BETS_PLACED();
  error ALL_BETS_MADE();

  //storage for variable setting game start time
  uint48 _gameStart;
  uint48 _minBet;
  uint48 _allowedUsers;

  event NFTAdded(address owner, uint256 tokenId, uint256 value);
  event NFTRemoved(address owner, uint256 tokenId, uint256 value);



  // maps tokenId to Bet
  mapping(uint256 => Bet) public vault; 
// mapping to allow those who have placed bets to set a struct on what they want to bet
  mapping(address => bool) public player; 

 //maps user to thier result of game guess
  mapping(address => Game) public Guess; 
  
  /*
  @Dev: This will not have value until set i.e. 0 address
  */
  
  address public confirmedWinner;

   constructor(uint48 gameStart, uint48 _minBet, uint48 allowedUsers) {
        gameStart =  _gameStart;
        minBet = _minBet;
        allowedUsers = _allowedUsers;
  }
   /*
   @Dev: Inputs address of NFT to bet and token Ids.
   @Notice: To play games with large bets you need to obtain a lot of tokens from one contract.
   */
  function bet(uint256[] calldata tokenIds, address calldata collectionAddress, bytes32 game, uint48 score, bytes32 winner) external nonRenentrant {
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

  function _winnerTakesTokens(address account, uint256[] calldata tokenIds,  address[] calldata orginalAddresses) external {
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


