// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PredictionMarket {
    struct Market {
        string question;
        uint256 endTime;
        bool isResolved;
        bool outcome;
        uint256 totalYesBets;
        uint256 totalNoBets;
    }

    mapping(uint256 => Market) public markets;
    mapping(uint256 => mapping(address => mapping(bool => uint256))) public userBets;
    
    uint256 public marketId;
    address public owner;
    
    event MarketCreated(uint256 indexed marketId, string question, uint256 endTime);
    event BetPlaced(uint256 indexed marketId, address indexed user, bool prediction, uint256 amount);
    event MarketResolved(uint256 indexed marketId, bool outcome);
    event RewardsClaimed(uint256 indexed marketId, address indexed user, uint256 amount);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // Function 1: Place a bet on a market
    function placeBet(uint256 _marketId, bool _prediction) external payable {
        Market storage market = markets[_marketId];
        
        require(!market.isResolved, "Market is already resolved");
        require(block.timestamp < market.endTime, "Market has ended");
        require(msg.value > 0, "Bet amount must be greater than 0");
        
        userBets[_marketId][msg.sender][_prediction] += msg.value;
        
        if (_prediction) {
            market.totalYesBets += msg.value;
        } else {
            market.totalNoBets += msg.value;
        }
        
        emit BetPlaced(_marketId, msg.sender, _prediction, msg.value);
    }
    
    // Function 2: Resolve market and distribute rewards
    function resolveMarket(uint256 _marketId, bool _outcome) external onlyOwner {
        Market storage market = markets[_marketId];
        
        require(!market.isResolved, "Market is already resolved");
        require(block.timestamp >= market.endTime, "Market has not ended yet");
        
        market.isResolved = true;
        market.outcome = _outcome;
        
        emit MarketResolved(_marketId, _outcome);
    }
    
    // Helper functions
    function createMarket(string calldata _question, uint256 _duration) external onlyOwner {
        require(_duration > 0, "Duration must be greater than 0");
        
        uint256 endTime = block.timestamp + _duration;
        markets[marketId] = Market({
            question: _question,
            endTime: endTime,
            isResolved: false,
            outcome: false,
            totalYesBets: 0,
            totalNoBets: 0
        });
        
        emit MarketCreated(marketId, _question, endTime);
        marketId++;
    }
    
    function claimRewards(uint256 _marketId) external {
        Market storage market = markets[_marketId];
        require(market.isResolved, "Market is not resolved yet");
        
        uint256 userBet = userBets[_marketId][msg.sender][market.outcome];
        require(userBet > 0, "No winning bets found");
        
        uint256 totalBets = market.totalYesBets + market.totalNoBets;
        uint256 winningBets = market.outcome ? market.totalYesBets : market.totalNoBets;
        
        uint256 reward = (userBet * totalBets) / winningBets;
        userBets[_marketId][msg.sender][market.outcome] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: reward}("");
        require(success, "Transfer failed");
        
        emit RewardsClaimed(_marketId, msg.sender, reward);
    }
    
    function getMarketInfo(uint256 _marketId) external view returns (
        string memory question,
        uint256 endTime,
        bool isResolved,
        bool outcome,
        uint256 totalYesBets,
        uint256 totalNoBets
    ) {
        Market storage market = markets[_marketId];
        return (
            market.question,
            market.endTime,
            market.isResolved,
            market.outcome,
            market.totalYesBets,
            market.totalNoBets
        );
    }
}