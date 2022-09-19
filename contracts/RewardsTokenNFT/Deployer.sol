// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
// @Dev: imports base or contract to be deployed.
import "./RewardTokenNFT.sol";
import "./Access.sol";
//@Dev: openzepplin imports.
import "@openzeppelin/contracts/access/AccessControl.sol";

contract RewardsNFTFactory is AccessControl, Access { 
    /**  
    ================================================
    |             Storage variables                |
    ================================================
    **/
    
    /*
    @Dev: storage for instance of reward contract.
    */ 
    Rewardss public rewardContract;
 
    /*
    @Dev: Storage for roles.
    */ 
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    /*
    @Dev: storage for an array of rewards addresses deployed from this contract
    */ 
    address[] public DeployedRewardsAddresses;
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
    function ViewRewardsContractList() public view returns (address  [] memory) {
        return DeployedRewardsAddresses;
        }
    /*
    @Dev: Function to deploy a rewards contract
    @Notice: Accepts the function input arugment in the rewards contract as constructor arugments.
    @Notice: It takes all the addresses and pushes them into an array and a mapping.
    */   

    function DeployRewards(string name, string symbol, uint256 maxSupply, uint256 maxClaim, address mainToken, address accessToken, uint256 burnReq) public onlyRole(MINTER_ROLE) {
        rewardContract = new Reward();
        address newContract = address(new Reward(name, symbol, maxSupply, maxClaim, mainToken, accessToken, burnReq));
        DeployedRewardsAddresses.push(newContract);
         isReward[newContract] =  true;
        }
    /*
    @Dev: Function to remove a contract from the allowed contract to be opened.
    @Dev: The arugments are the address of the reward NFT that should be removed and the position in the array.
    @Notice: There read functionality in the contract that can help double check the position in the array.
    @Notice: DeployedRewardsAddresses accepts a uint as an argument and returns the reward contract assiocated.
    */      
    
    function RemoveRewardAddress(address noLongerApprovedAddress, uint256 arrayPositionOfAddress) external onlyRole(MINTER_ROLE) {
        delete DeployedRewardsAddresses[arrayPositionOfAddress];
         isRewards[noLongerApprovedAddress] =  false;
        }
    
}
