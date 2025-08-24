.PHONY: deploy-anvil deploy-local deploy-sepolia deploy-mainnet help

# Default target
help:
	@echo "Available deployment commands:"
	@echo "  make deploy-anvil    - Deploy to local Anvil node"
	@echo ""
	@echo "Make sure to set your environment variables:"
	@echo "  DEPLOYER_PRIVATE_KEY - Your wallet's private key"
	@echo "  OWNER_ADDRESS       - The address that will own the token"

# Deploy to local Anvil node
deploy-anvil:
	forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast