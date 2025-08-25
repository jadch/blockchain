// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * ERC20 Faucet with per-address cooldown
 *
 * Anyone can claim `dripAmount` tokens once every `cooldown` seconds.
 * Owner can pause and adjust parameters. Faucet must be pre-funded.
 *
 * The TestToken and Faucet contracts would live side by side:
 * - ERC20 token contract: holds the ledger, with functions to read balances, transfer, approve, etc...
 * - Faucet contract: holds a token balance and enforces rules (cooldown, drip). Users call claim function to receive tokens
 */
contract Faucet is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    uint256 public dripAmount;
    uint256 public cooldownInSeconds;
    bool public paused;

    mapping(address => uint256) public lastClaimAt; // last claim timestamp for each address

    constructor(address owner_, IERC20 token_, uint256 dripAmount_, uint256 cooldownInSeconds_) Ownable(owner_) {
        token = token_;
        dripAmount = dripAmount_;
        cooldownInSeconds = cooldownInSeconds_;
    }

    event Claimed(address indexed claimant, uint256 amount, uint256 nextEligibleAt);
    event DripAmountUpdated(uint256 oldAmount, uint256 newAmount);
    event CooldownUpdated(uint256 oldCooldown, uint256 newCooldown);
    event Paused(bool isPaused);

    error ClaimIsPaused();
    error CooldownActive(uint256 timestamp, uint256 nextEligibleTimestamp);
    error InsufficientFaucetBalance(uint256 balance, uint256 required);

    function setDripAmount(uint256 newDripAmount) external onlyOwner {
        emit DripAmountUpdated(dripAmount, newDripAmount);
        dripAmount = newDripAmount;
    }

    function setCooldown(uint256 newCooldown) external onlyOwner {
        emit CooldownUpdated(cooldownInSeconds, newCooldown);
        cooldownInSeconds = newCooldown;
    }

    function setPaused(bool isPaused) external onlyOwner {
        paused = isPaused;
        emit Paused(isPaused);
    }

    function nextEligibleAt(address claimant) public view returns (uint256) {
        uint256 last = lastClaimAt[claimant];

        if (last == 0) {
            return 0;
        }
        return last + cooldownInSeconds;
    }

    function claim() external {
        if (paused) revert ClaimIsPaused();

        uint256 nowTimestamp = block.timestamp;
        uint256 nextEligibleTs = nextEligibleAt(msg.sender);

        if (nextEligibleTs != 0 && nowTimestamp < nextEligibleTs) {
            revert CooldownActive(nowTimestamp, nextEligibleTs);
        }

        uint256 balance = token.balanceOf(address(this));
        if (balance < dripAmount) {
            revert InsufficientFaucetBalance(balance, dripAmount);
        }

        lastClaimAt[msg.sender] = nowTimestamp;
        token.safeTransfer(msg.sender, dripAmount);

        emit Claimed(msg.sender, dripAmount, nowTimestamp + cooldownInSeconds);
    }
}
