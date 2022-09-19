// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
// @Dev: imports base or contract to be deployed.
import "./Base.sol";
import "./Access.sol";
//@Dev: openzepplin imports.
import "@openzeppelin/contracts/access/AccessControl.sol";

contract GambleFactory is AccessControl, Access { 
    /**  
    ================================================
    |             Storage variables                |
    ================================================
    **/
    
    /*
    @Dev: storage for instance of game contract.
    */ 
    Games public gameContract;
 
    /*
    @Dev: Storage for roles.
    */ 
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    /*
    @Dev: storage for an array of games addresses deployed from this contract
    */ 
    address[] public DeployedGamesAddresses;
    /**  
    ================================================
    |             Constructor Input                |
    ================================================
    **/
   //constructor - admin roles added to deployer
   constructor() {
       _grantRole(ADMIN_ROLE, msg.sender);
       _grantRole(MINTER_ROLE, msg.sender);
       }

    /**  
    ================================================
    |                     Functions                |
    ================================================
    **/ 

    /*
    @Dev: View function to see array of approved addresses.
    @Notice: This is good to hit for approvals in moments contract.
    */   
    function ViewGamesContractList() public view returns (address  [] memory) {
        return DeployedGamesAddresses;
        }
    /*
    @Dev: Function to deploy a game contract
    @Notice: Accepts the function input arugment in the game contract as constructor arugments.
    @Notice: It takes all the addresses and pushes them into an array and a mapping.
    */   
    function DeployGame() public onlyRole(MINTER_ROLE) {
        gameContract = new Game();
        address newContract = address(new Game());
        DeployedGamesAddresses.push(newContract);
         isGame[newContract] =  true;
        }
    /*
    @Dev: Function to remove a contract from the allowed contract to be opened.
    @Dev: The arugments are the address of the game that should be removed and the position in the array.
    @Notice: There read functionality in the contract that can help double check the position in the array.
    @Notice: DeployedGamesAddresses accepts a uint as an argument and returns the game contract assiocated.
    */      
    
    function RemoveGameAddress(address noLongerApprovedAddress, uint256 arrayPositionOfAddress) external onlyRole(MINTER_ROLE) {
        delete DeployedGamesAddresses[arrayPositionOfAddress];
         isGames[noLongerApprovedAddress] =  false;
        }
    
}
