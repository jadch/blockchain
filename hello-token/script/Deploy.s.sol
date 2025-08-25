// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {TestToken} from "../src/TestToken.sol";
import {Faucet} from "../src/Faucet.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Deploy is Script {
    function run() external {
        uint256 private_key = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address owner = vm.envAddress("OWNER_ADDRESS");

        vm.startBroadcast(private_key);
        uint256 totalSupply = 1_000_000_000e18;

        // Deploy token
        TestToken token = new TestToken("MyFirstToken", "MFT", owner, totalSupply);

        // Deploy faucet
        Faucet faucet = new Faucet(owner, IERC20(address(token)), 100e18, 1 hours);

        // Fund the faucet with 10% of total supply
        token.transfer(address(faucet), totalSupply / 10);

        vm.stopBroadcast();

        console.log("TestToken deployed at:", address(token));
        console.log("Faucet deployed at:", address(faucet));
    }
}
