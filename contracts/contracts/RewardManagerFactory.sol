// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RewardManager.sol";

contract RewardManagerFactory {
    address public owner;
    address[] public deployedContracts;
    mapping(address => bool) public isDeployed;
    mapping(address => bool) public isUsed;
    
    event RewardManagerDeployed(address indexed contractAddress);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    function deployRewardManager() external onlyOwner returns (address) {
        RewardManager newContract = new RewardManager();
        address contractAddress = address(newContract);
        
        deployedContracts.push(contractAddress);
        isDeployed[contractAddress] = true;
        isUsed[contractAddress] = false;
        
        emit RewardManagerDeployed(contractAddress);
        return contractAddress;
    }
    
    function getLatestUnusedContract() external view returns (address) {
        for (uint i = deployedContracts.length; i > 0; i--) {
            address contractAddress = deployedContracts[i - 1];
            if (isDeployed[contractAddress] && !isUsed[contractAddress]) {
                return contractAddress;
            }
        }
        return address(0);
    }
    
    function markContractAsUsed(address contractAddress) external onlyOwner {
        require(isDeployed[contractAddress], "Contract not deployed");
        isUsed[contractAddress] = true;
    }
    
    function getAllDeployedContracts() external view returns (address[] memory) {
        return deployedContracts;
    }
} 