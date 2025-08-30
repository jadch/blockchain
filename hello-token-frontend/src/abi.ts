export const erc20Abi = [
	{
	  type: "function",
	  name: "symbol",
	  stateMutability: "view",
	  inputs: [],
	  outputs: [{ type: "string" }],
	},
	{
	  type: "function",
	  name: "decimals",
	  stateMutability: "view",
	  inputs: [],
	  outputs: [{ type: "uint8" }],
	},
	{
	  type: "function",
	  name: "balanceOf",
	  stateMutability: "view",
	  inputs: [{ name: "account", type: "address" }],
	  outputs: [{ type: "uint256" }],
	},
	{
	  type: "function",
	  name: "transfer",
	  stateMutability: "nonpayable",
	  inputs: [
		{ name: "to", type: "address" },
		{ name: "amount", type: "uint256" },
	  ],
	  outputs: [{ type: "bool" }],
	},
	{
	  type: "function",
	  name: "mint",
	  stateMutability: "nonpayable",
	  inputs: [
		{ name: "to", type: "address" },
		{ name: "amount", type: "uint256" },
	  ],
	  outputs: [],
	},
  ] as const;

  export const faucetAbi = [
	{
	type: "function",
	name: "claim",
	stateMutability: "nonpayable",
	inputs: [],
	outputs: [],
	},
	{
	type: "function",
	name: "dripAmount",
	stateMutability: "view",
	inputs: [],
	outputs: [{ type: "uint256" }],
	},
	{
	type: "function",
	name: "cooldown",
	stateMutability: "view",
	inputs: [],
	outputs: [{ type: "uint256" }],
	},
	{
	type: "function",
	name: "nextEligible",
	stateMutability: "view",
	inputs: [{ name: "user", type: "address" }],
	outputs: [{ type: "uint256" }],
	},
	] as const;