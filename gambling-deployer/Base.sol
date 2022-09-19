// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.4;



contract Games is Ownable, IERC721Receiver {

  uint256 public totalStaked;
  
  // struct to store a token, that has been placed as a bet by the owner.
  struct Bet {
    uint24 tokenId;
    uint48 timestamp;
    address owner;
  }
// struct to store a token, that has been placed as a bet by the owner.
  struct Game {
    bytes32 sport;
    uint48 score;
    bytes32 winner;
  }
  //storage for errors
  error IN_VAULT();
  error GAME_IN_PROGRESS_ALREADY();

  //storage for variable setting game start time
  uint48 _gameStart;
  uint48 _minBet;

  event NFTAdded(address owner, uint256 tokenId, uint256 value);
  event NFTRemoved(address owner, uint256 tokenId, uint256 value);
//   event Claimed(address owner, uint256 amount);


  // maps tokenId to Bet
  mapping(uint256 => Bet) public vault; 
// mapping to allow those who have placed bets to set a struct on what they want to bet
  mapping(address => bool) public player; 



   constructor(uint48 gameStart) {
        gameStart = uint48 _gameStart;
        minBet = uint48 _minBet;

  }
   /*Dev: Inputs address of NFT to bet*/
  function bet(uint256[] calldata tokenIds, address calldata collectionAddress) external nonRenentrant {
    uint256 tokenId;
    totalStaked += tokenIds.length;
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

      IERC721(collectionAddress(msg.sender, address(this), tokenId);
      emit NFTAdded(msg.sender, tokenId, block.timestamp);

      vault[tokenId] = Bet({
        owner: msg.sender,
        tokenId: uint24(tokenId),
        timestamp: uint48(block.timestamp)
      });
      player
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

