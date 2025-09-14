.PHONY: deploy-anvil deploy-sepolia

# Default target
help:
	@echo "Available deployment commands:"
	@echo "  make deploy-anvil    - Deploy to local Anvil node"
	@echo ""
	@echo "Make sure to set your environment variables:"
	@echo "  DEPLOYER_PRIVATE_KEY - Your wallet's private key"
	@echo "  OWNER_ADDRESS       - The address that will own the token"

deploy-anvil:
	forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast

deploy-sepolia:
	source .env && forge script script/Deploy.s.sol --rpc-url $$SEPOLIA_RPC_URL --broadcast