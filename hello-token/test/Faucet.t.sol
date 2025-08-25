// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Faucet.sol";
import "../src/TestToken.sol";

contract FacuetTest is Test {
    TestToken token;
    Faucet faucet;

    address owner = address(this);
    address alice = address(0x111);
    address bob = address(0x222);

    uint256 constant DRIP = 100e18; // token uses 18 decimals
    uint256 constant COOLDOWN = 1 days;

    function setUp() public {
        token = new TestToken("MyFirstToken", "MFT", owner, 1_000_000e18);
        faucet = new Faucet(owner, token, DRIP, COOLDOWN);
        token.transfer(address(faucet), 10_000e18);
    }

    function testFirstClaimSucceeds() public {
        assertEq(token.balanceOf(alice), 0);
        vm.prank(alice);

        faucet.claim();
        assertEq(token.balanceOf(alice), DRIP);
        assertEq(token.balanceOf(address(faucet)), 10_000e18 - DRIP);
        assertEq(faucet.lastClaimAt(alice), block.timestamp);
        assertEq(faucet.nextEligibleAt(alice), block.timestamp + COOLDOWN);
    }

    function testSecondClaimFailsDuringCooldown() public {
        vm.startPrank(alice);
        faucet.claim();

        vm.expectRevert(
            abi.encodeWithSelector(Faucet.CooldownActive.selector, block.timestamp, block.timestamp + COOLDOWN)
        );
        faucet.claim();
        vm.stopPrank();

        assertEq(token.balanceOf(alice), DRIP);
        assertEq(token.balanceOf(address(faucet)), 10_000e18 - DRIP);
        assertEq(faucet.lastClaimAt(alice), block.timestamp);
        assertEq(faucet.nextEligibleAt(alice), block.timestamp + COOLDOWN);
    }

    function testSecondClaimSucceedsAfterCooldown() public {
        vm.startPrank(alice);
        faucet.claim();

        vm.warp(block.timestamp + COOLDOWN + 1);
        faucet.claim();

        assertEq(token.balanceOf(alice), DRIP * 2);
        vm.stopPrank();
    }

    function testInsufficientFaucetBalanceRevert() public {
        vm.prank(owner);
        faucet.setDripAmount(10_000e18 + 1);

        vm.expectRevert(abi.encodeWithSelector(Faucet.InsufficientFaucetBalance.selector, 10_000e18, 10_000e18 + 1));
        vm.prank(alice);
        faucet.claim();
    }

    function testClaimPausedRevert() public {
        vm.prank(owner);
        faucet.setPaused(true);

        vm.expectRevert(abi.encodeWithSelector(Faucet.ClaimIsPaused.selector));
        vm.prank(alice);
        faucet.claim();
    }

    function testOnlyOwnerCanUpdateParams() public {
        vm.prank(owner);
        faucet.setDripAmount(50e18);
        faucet.setCooldown(12 hours);

        assertEq(faucet.dripAmount(), 50e18);
        assertEq(faucet.cooldownInSeconds(), 12 hours);

        vm.startPrank(alice);
        vm.expectRevert();
        faucet.setDripAmount(100e18);
        vm.expectRevert();
        faucet.setCooldown(1 days);
        vm.stopPrank();

        assertEq(faucet.dripAmount(), 50e18);
        assertEq(faucet.cooldownInSeconds(), 12 hours);
    }

    function testEachAddressHasOwnCooldown() public {
        vm.prank(alice);
        faucet.claim();

        vm.prank(bob);
        faucet.claim();

        assertEq(token.balanceOf(alice), DRIP);
        assertEq(token.balanceOf(bob), DRIP);
    }
}
