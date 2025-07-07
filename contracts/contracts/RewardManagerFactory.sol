// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RewardManager.sol";

contract RewardManagerFactory {
    address public owner;
    address public latestContract;
    address public rewardToken;
    
    event RewardManagerDeployed(address indexed contractAddress);
    
    constructor(address _rewardToken) {
        owner = msg.sender;
        rewardToken = _rewardToken;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    function deployRewardManager() external onlyOwner {
        RewardManager newContract = new RewardManager(msg.sender, rewardToken);
        address contractAddress = address(newContract);
        
        latestContract = contractAddress;
        
        emit RewardManagerDeployed(contractAddress);
    }
    
    function getDeployedContract() external view returns (address) {
        return latestContract;
    }
} 