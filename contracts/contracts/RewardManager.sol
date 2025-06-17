// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RewardManager {
    address public owner;
    bool public initialized;
    
    // Mapping to store earnings for each address
    mapping(address => uint256) public userEarnings;
    
    // Mapping to store percentage shares for each address
    mapping(address => uint256) public percentageShares;
    
    // Total percentage (should be 100)
    uint256 public totalPercentage;
    
    event EarningsUpdated(address indexed user, uint256 amount);
    event ClaimProcessed(address indexed user, uint256 amount);
    event Initialized();
    
    constructor() {
        owner = msg.sender;
        initialized = false;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyInitialized() {
        require(initialized, "Contract not initialized");
        _;
    }
    
    function initialize(
        address[] calldata addresses,
        uint256[] calldata percentages
    ) external onlyOwner {
        require(!initialized, "Already initialized");
        require(addresses.length == percentages.length, "Arrays length mismatch");
        
        uint256 total = 0;
        for (uint256 i = 0; i < addresses.length; i++) {
            percentageShares[addresses[i]] = percentages[i];
            total += percentages[i];
        }
        
        require(total == 100, "Total percentage must be 100");
        totalPercentage = total;
        initialized = true;
        
        emit Initialized();
    }
    
    function claim(uint256 amount) external onlyInitialized {
        require(amount > 0, "Amount must be greater than 0");
        require(userEarnings[msg.sender] >= amount, "Insufficient earnings");
        
        userEarnings[msg.sender] -= amount;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit ClaimProcessed(msg.sender, amount);
    }
    
    function getUserEarnings(address user) external view returns (uint256) {
        return userEarnings[user];
    }
    
    receive() external payable onlyInitialized {
        require(msg.value > 0, "Must send some ETH");
        
        for (uint256 i = 0; i < 100; i++) {
            address user = address(uint160(i)); // This is a placeholder - you'll need to implement proper address iteration
            if (percentageShares[user] > 0) {
                uint256 share = (msg.value * percentageShares[user]) / 100;
                userEarnings[user] += share;
                emit EarningsUpdated(user, share);
            }
        }
    }
} 