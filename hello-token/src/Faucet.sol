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

	
}
