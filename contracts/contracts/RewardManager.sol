// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardManager {
    address public owner;
    bool public initialized;
    IERC20 public rewardToken;
    
    // Array holding all participants
    address[] public participants;

    // Mapping to store percentage shares for each address
    mapping(address => uint256) public percentageShares;
    
    // Total percentage (should be 10000)
    uint256 public totalPercentage;
    
    event EarningsUpdated(address indexed user, uint256 amount);
    event ClaimProcessed(address indexed user, uint256 amount);
    event Initialized();
    
    constructor(address _owner, address _rewardToken) {
        owner = _owner;
        initialized = false;
        rewardToken = IERC20(_rewardToken);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyInitialized() {
        require(initialized, "Contract not initialized");
        _;
    }
    
    modifier sufficientEarnings(uint256 amount) {
        require(getUserEarnings(msg.sender) >= amount, "Insufficient earnings");
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
    
    function claim(uint256 amount) external onlyInitialized sufficientEarnings(amount) {
        require(amount > 0, "Amount must be greater than 0");
        
        require(rewardToken.transfer(msg.sender, amount), "Transfer failed");
        
        emit ClaimProcessed(msg.sender, amount);
    }
    
    function getUserEarnings(address user) public view returns (uint256) {
        uint256 value = rewardToken.balanceOf(address(this));
        uint256 userShare = (value * percentageShares[user]) / 10000;
        return userShare;
    }
} 