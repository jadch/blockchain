// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// ERC‑20 is the standard interface for fungible tokens on EVM chains
// OpenZeppelin already implements ERC20 required functions like transfer, approve, allowance, etc...
contract TestToken is ERC20, Ownable {
    constructor(string memory name_, string memory symbol_, address owner_, uint256 initialSupply)
        ERC20(name_, symbol_)
        Ownable(owner_)
    {
        if (initialSupply > 0) {
            _mint(owner_, initialSupply);
        }
    }

    function mint(address to, uint256 amount) external onlyOwner {
        // onlyOwner protects the mint function from being called by anyone other than the owner
        // the owner can send the tokens to any address
        _mint(to, amount);

        // TOLEARN: implement different models for minting, like: capped supply, mint schedule, governance controlled with multisig or timelock
    }
}
