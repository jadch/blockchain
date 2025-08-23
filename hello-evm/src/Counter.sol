pragma solidity ^0.8.13;

// cast call <address> "count()(uint256)" --rpc-url http://127.0.0.1:8545
// cast send <address> "increment()" --private-key <private_key> --rpc-url http://127.0.0.1:8545
// cast send <address> "decrement()" --private-key <private_key> --rpc-url http://127.0.0.1:8545

contract Counter {
    uint256 public count; // inits at 0

    event Increment(address indexed caller, uint256 newCount);
    event Decrement(address indexed caller, uint256 newCount);

    function increment() external {
        // unchecked to save gas, no realistic chance of overflow
        unchecked {
            count += 1;
        }
        emit Increment(msg.sender, count);
    }

    function decrement() external {
        // if the require condition fails:
        //  - transaction is reverted
        //  - state changes are rolled back
        require(count > 0, "count already at 0");

        unchecked {
            count -= 1;
        }
        emit Decrement(msg.sender, count);
    }
}
