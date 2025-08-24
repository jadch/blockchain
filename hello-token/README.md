- After launching `anvil`, add the `DEPLOYER_PRIVATE_KEY` and `OWNER_ADDRESS` to the `.env`
file then launch ` make deploy-anvil`

You can then start interacting with the contract with the following commands:
- start with `export TOKEN=<deployed address>`

### Read balance
`cast call $TOKEN "balanceOf(address)(uint256)" $ADDR`
### Mint (owner only)
`cast send $TOKEN "mint(address,uint256)" $ADDR 100e18 --private-key $PK`
### Get token total balance
`cast call $TOKEN "totalSupply()" | xargs cast --to-dec`
### Transfer to another anvil account
`cast send $TOKEN "transfer(address,uint256)" <ADDRESS_TO_SEND_TO> 25e18 --private-key $PK`



## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
