// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address public owner;

    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) 
    {
        owner = msg.sender;
    }

    /**
     * @dev Trigger a flash loan
     * @param _token The asset to borrow
     * @param _amount Amount to borrow
     */
    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        bytes memory params = ""; // Add trade data here
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            _token,
            _amount,
            params,
            referralCode
        );
    }

    /**
     * @dev Aave calls this function after sending the flash loan amount
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE LOGIC GOES HERE
        // Example: Swap 'asset' on DEX A, then swap back on DEX B
        
        // 2. Ensure we have enough to repay the loan + premium (fee)
        uint256 amountToRepay = amount + premium;
        require(IERC20(asset).balanceOf(address(this)) >= amountToRepay, "Arbitrage not profitable");

        // 3. Approve Aave to pull the repayment
        IERC20(asset).approve(address(POOL), amountToRepay);

        return true;
    }

    function withdraw(address _token) external {
        require(msg.sender == owner, "Only owner");
        IERC20 token = IERC20(_token);
        token.transfer(owner, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
