// SPDX-License-Identifier: ISC

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./tinyImports.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract SpendingToken is 
ERC20,
AccessControl, 
TinyImports,
ReentrancyGuard {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant SPENDER_ROLE = keccak256("SPENDER_ROLE ");
    

    constructor(address _TOKEN_ADDRESS) 
    ERC20("SpendingToken", "SPGC") 
    {
        TOKEN_ADDRESS = _TOKEN_ADDRESS;
         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    //storage for token address 
    TinyImports TOKEN = TinyImports(TOKEN_ADDRESS);
    //storage for sale token
    TinyImports NFT_REWARD = TinyImports(SALE_TOKEN);
    address public TOKEN_ADDRESS;
    //storage for sale token
    address public SALE_TOKEN;


    //will likely be needed in another contract but can stay here for now.
    function GetBalance(uint256 tokenId) public view returns (uint) {
        return TOKEN.TokenIdToBalance(tokenId);
    }

    function GetToken(uint256 balance) public view returns (uint) {
        return TOKEN.BalanceToTokenId(balance);
    }

    function WhoOwnsTheERC721(address owner) public view returns (uint) {
         return TOKEN.TokenOwner(owner);
    }
    //sale token amount is set in another contract we take it in here
    function canPurchse(uint burnAmount) public view returns (bool) {
         NFT_REWARD.purchaseAmount(burnAmount);
         return true;
    }
    function LastOwnerGiveTokens(address owner) public view returns (address) {
         return TOKEN.LastOwnerNewOwner(owner);
    }
    
   function GiveMyTokens(address to, uint256 amount, uint256 tokenId) public nonReentrant {
         require(tokenId == WhoOwnsTheERC721(msg.sender));
         require(amount == GetBalance(tokenId));
         address owner = LastOwnerGiveTokens(msg.sender);
         _transfer(owner, to, amount);
}
    
 function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual onlyRole(MINTER_ROLE) override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
   
   function transfer(address to, uint256 amount) public virtual onlyRole(MINTER_ROLE) override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }



    function mint(address to, uint256 amount, uint256 tokenId) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
        require(tokenId == WhoOwnsTheERC721(msg.sender));
        //adds amount to mapping
        TokenIdToBalance[tokenId] +=  amount;
    }
    
    function burn(address to, uint256 amount, uint tokenId) public onlyRole(SPENDER_ROLE) {
        require(tokenId == WhoOwnsTheERC721(msg.sender));
        require(canPurchse(amount) == true);
        _burn(to, amount);
        //subtracts token amount
        TokenIdToBalance[tokenId] -=  amount;
        //in the context of this contract
        approvedToGet[tokenId] = true;
    }
    //change sale token address
    function setSaleToken(address newTokenForSaleAddress) public onlyRole(MINTER_ROLE) {
        SALE_TOKEN = newTokenForSaleAddress;
    }

}