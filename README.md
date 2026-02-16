# Flash Loan Arbitrage Core

A professional-grade smart contract template for interacting with Aave V3 Flash Loans. This repository demonstrates the "Atomic Transaction" pattern where capital is borrowed, utilized for a profitable trade, and repaid in a single block.

## How it Works


1. **Request:** The contract calls Aave's `flashLoanSimple()`.
2. **Execute:** Aave sends the requested assets to this contract.
3. **Arbitrage:** The `executeOperation()` function is triggered. You perform trades (e.g., Uniswap vs. Sushiswap).
4. **Repay:** The contract automatically returns the principal plus a 0.05% fee to Aave.

## Features
* **Aave V3 Integration:** Built for the latest liquidity protocol.
* **Profit Safety:** Ensures the transaction reverts if the arbitrage does not result in a net gain.
* **Gas Optimized:** Minimalist logic to maximize arbitrage margins.

## Setup
1. Define your DEX router addresses in `FlashLoan.sol`.
2. Deploy the contract on a network supported by Aave (e.g., Polygon, Arbitrum, Sepolia).
3. Fund the contract with enough tokens to cover the Flash Loan fee.
