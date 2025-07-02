// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract RewardManager {
    address public owner;
    bool public initialized;
    
    // Mapping to store earnings for each address
    mapping(address => uint256) public userEarnings;
    
    // Array holding all participants
    address[] public participants;

    // Mapping to store percentage shares for each address
    mapping(address => uint256) public percentageShares;
    
    // Total percentage (should be 10000)
    uint256 public totalPercentage;
    
    event EarningsUpdated(address indexed user, uint256 amount);
    event ClaimProcessed(address indexed user, uint256 amount);
    event Initialized();
    
    constructor(address _owner) {
        owner = _owner;
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
            participants.push(addresses[i]);
        }
        
        require(total == 10000, "Total percentage must be 10000");
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
        uint256 received = msg.value;
        for (uint256 i = 0; i < participants.length; i++) {
            address user = participants[i];
            uint256 userShare = (received * percentageShares[user]) / 10000;
            userEarnings[user] += userShare;
            emit EarningsUpdated(user, userShare);
        }
    }
} 