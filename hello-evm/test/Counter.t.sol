pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter c;

    function setUp() public {
        c = new Counter();
    }

    function testIncrement() public {
        c.increment();
        assertEq(c.count(), 1);
    }

    function testDecrementRevertsAtZero() public {
        vm.expectRevert(bytes("count already at 0"));
        c.decrement();
    }

    function testIncrementThenDecrement() public {
        c.increment();
        c.increment();
        c.decrement();
        assertEq(c.count(), 1);
    }
}
