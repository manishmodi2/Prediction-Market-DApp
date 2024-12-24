# Prediction Market DApp

A decentralized prediction market application built on Ethereum that allows users to create markets, place bets on binary outcomes (Yes/No), and claim rewards.

## Table of Contents
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Smart Contract Deployment](#smart-contract-deployment)
- [Frontend Setup](#frontend-setup)
- [Usage Guide](#usage-guide)
- [Contract Functions](#contract-functions)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)

## Features
- Create prediction markets with custom questions and durations
- Place bets on binary outcomes (Yes/No)
- Automatic reward distribution based on proportional betting
- User-friendly interface with MetaMask integration
- Real-time updates and notifications
- Responsive design for all devices

## Technology Stack
- Solidity ^0.8.0 (Smart Contract)
- Web3.js (Blockchain Interaction)
- HTML/CSS/JavaScript (Frontend)
- MetaMask (Wallet Connection)

## Prerequisites
- Node.js v14+ and npm
- MetaMask browser extension
- Basic understanding of Ethereum and smart contracts
- Some ETH for testing (can use testnet)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/prediction-market-dapp.git
cd prediction-market-dapp
```

2. Install dependencies:
```bash
npm install
```

## Smart Contract Deployment

1. Configure your deployment network in `truffle-config.js` or `hardhat.config.js`

2. Deploy the contract:
```bash
npx truffle migrate --network <your-network>
# or
npx hardhat run scripts/deploy.js --network <your-network>
```

3. Copy the deployed contract address and ABI

## Frontend Setup

1. Update the contract address in `index.html`:
```javascript
const contractAddress = 'YOUR_CONTRACT_ADDRESS_HERE';
```

2. Add your contract ABI in the `contractABI` array

3. Serve the frontend:
```bash
npx http-server ./
```

## Usage Guide

### Connecting Wallet
1. Click "Connect Wallet" button
2. Approve MetaMask connection
3. Your wallet address will appear when connected

### Creating a Market
1. Enter your prediction market question
2. Set the duration in hours
3. Click "Create Market"
4. Confirm the transaction in MetaMask

### Placing Bets
1. Find the market you want to bet on
2. Enter the amount of ETH you want to bet
3. Click either "Bet Yes" or "Bet No"
4. Confirm the transaction in MetaMask

### Claiming Rewards
1. Wait for the market to be resolved
2. Find your winning market
3. Click "Claim Rewards"
4. Confirm the transaction in MetaMask

## Contract Functions

### Core Functions
```solidity
function placeBet(uint256 _marketId, bool _prediction) external payable
function resolveMarket(uint256 _marketId, bool _outcome) external onlyOwner
```

### Helper Functions
```solidity
function createMarket(string calldata _question, uint256 _duration) external onlyOwner
function claimRewards(uint256 _marketId) external
function getMarketInfo(uint256 _marketId) external view returns (...)
```

## Security Considerations

1. Owner Controls:
   - Only the contract owner can create and resolve markets
   - Implement a DAO or oracle system for decentralized resolution

2. Time Constraints:
   - Markets have fixed end times
   - Bets cannot be placed after market end time
   - Resolution only possible after end time

3. Fund Safety:
   - Funds are locked in contract until market resolution
   - Proportional reward distribution
   - Reentrancy protection

## Contributing

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.