// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {TestToken} from "../src/TestToken.sol";

contract Deploy is Script {
	function run() external {
		uint256 private_key = vm.envUint("DEPLOYER_PRIVATE_KEY");
		address owner = vm.envAddress("OWNER_ADDRESS");

		vm.startBroadcast(private_key);
		new TestToken("MyFirstToken", "MFT", owner, 1e10);
		vm.stopBroadcast();
	}
}