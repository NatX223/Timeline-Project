// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RewardManager.sol";

contract RewardManagerFactory {
    address public owner;
    address public latestContract;
    
    event RewardManagerDeployed(address indexed contractAddress);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    function deployRewardManager() external onlyOwner {
        RewardManager newContract = new RewardManager(msg.sender);
        address contractAddress = address(newContract);
        
        latestContract = contractAddress;
        
        emit RewardManagerDeployed(contractAddress);
    }
    
    function getDeployedContract() external view returns (address) {
        return latestContract;
    }
} 