import { createConfig, http } from "@wagmi/core";
import { mainnet, sepolia } from "@wagmi/core/chains";
import { walletConnect } from '@wagmi/connectors';

const anvil = {
	id: Number(import.meta.env.VITE_CHAIN_ID),
	name: "Anvil",
	nativeCurrency: {
		name: "Ether", symbol: "ETH", decimals: 18,
	},
	rpcUrls: {
		default: {
			http: [import.meta.env.VITE_RPC_URL],
		}
	}
}

export const chains = [anvil, sepolia, mainnet] as const;

export const config = createConfig({
	chains,
	transports: {
		[anvil.id]: http(anvil.rpcUrls.default.http[0]),
		[sepolia.id]: http(sepolia.rpcUrls.default.http[0] ?? "https://rpc.sepolia.org"),
		[mainnet.id]: http("https://cloudflare-eth.com"),
	},
	connectors: [
		walletConnect({
			projectId: import.meta.env.VITE_WC_PROJECT_ID!,
			showQrModal: true,
			metadata: {
			  name: "Hello Token",
			  description: "Minimal ERC20 dApp",
			  url: "http://localhost:5173",
			  icons: ["https://walletconnect.com/_next/static/media/walletconnect-logo.19f2e8e5.svg"],
			},
			
			// // Pass custom RPCs for non-standard chains (like Anvil)
			// rpcMap: Object.fromEntries(
			//   chains.map((c) => [c.id, c.rpcUrls.default.http[0]])
			// ),
		  }),
	]
})