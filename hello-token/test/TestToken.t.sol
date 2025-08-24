// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {TestToken} from "../src/TestToken.sol";

contract TestTokenTest is Test {
    TestToken token;
    address owner = address(this);
    address alice = address(0x111);
    address bob = address(0x222);

    function setUp() public {
        token = new TestToken("MyFirstToken", "MFT", owner, 1e10);
    }

    function testInitialMintAndTransfer() public {
        token.transfer(alice, 1e2);
        assertEq(token.balanceOf(alice), 1e2);
        assertEq(token.balanceOf(owner), 1e10 - 1e2);
        assertEq(token.totalSupply(), 1e10);
    }

    function testMint() public {
        token.mint(bob, 1e3);
        assertEq(token.balanceOf(bob), 1e3);

        vm.prank(alice);
        vm.expectRevert(); // Only owner can mint
        token.mint(bob, 1e5);

        assertEq(token.balanceOf(bob), 1e3);
    }

    function testApproveTransferFrom() public {
        token.transfer(alice, 1000);

        vm.prank(alice);
        token.approve(bob, 100);

        vm.prank(bob);
        token.transferFrom(alice, bob, 40);

        assertEq(token.allowance(alice, bob), 60);
        assertEq(token.balanceOf(alice), 960);
        assertEq(token.balanceOf(bob), 40);
    }
}
