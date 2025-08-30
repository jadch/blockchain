import React, { useState } from "react";
import {
  useAccount,
  useConnect,
  useDisconnect,
  useReadContract,
  useWriteContract,
} from "wagmi";
import { formatUnits, parseUnits } from "viem";
import { erc20Abi, faucetAbi } from "./abi";

const TOKEN = import.meta.env.VITE_TOKEN_ADDRESS as `0x${string}`;
const FAUCET = import.meta.env.VITE_FAUCET_ADDRESS as `0x${string}` | undefined;

function ConnectView() {
  const { connect, connectors, isPending } = useConnect();

  return (
    <div style={{ maxWidth: 520, margin: "40px auto", fontFamily: "Inter" }}>
      <h2>Connect a Wallet</h2>
      {connectors.map((c) => (
        <button
          key={c.id}
          onClick={() => connect({ connector: c })}
          disabled={isPending}
          style={{ marginRight: 8, marginBottom: 8 }}
        >
          {c.name}
        </button>
      ))}
      <p><i>Note: Tested with Rainbow wallet</i></p>
    </div>
  );
}

function DappView() {
  const { address, chainId } = useAccount();
  const { disconnect } = useDisconnect();

  // Token reads
  const symbol = useReadContract({
    address: TOKEN,
    abi: erc20Abi,
    functionName: "symbol",
  });
  const decimals = useReadContract({
    address: TOKEN,
    abi: erc20Abi,
    functionName: "decimals",
  });
  const balance = useReadContract({
    address: TOKEN,
    abi: erc20Abi,
    functionName: "balanceOf",
    args: [address || "0x0000000000000000000000000000000000000000"],
  });

  const { writeContractAsync, isPending: txPending } = useWriteContract();

  const dec = (decimals.data as number) ?? 18;
  const sym = (symbol.data as string) ?? "";

  // Local state for transfer/mint
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("0");

  // Faucet reads (optional if FAUCET is defined)
  const eligibleTs = useReadContract({
    address: FAUCET,
    abi: faucetAbi,
    functionName: "nextEligible",
    args: [address || "0x0000000000000000000000000000000000000000"],
    query: { enabled: !!FAUCET && !!address },
  });
  const drip = useReadContract({
    address: FAUCET,
    abi: faucetAbi,
    functionName: "dripAmount",
    query: { enabled: !!FAUCET },
  });

  function secondsLeft(): number {
    const now = Math.floor(Date.now() / 1000);
    const elig = Number((eligibleTs.data as bigint) || 0n);
    return Math.max(0, elig - now);
  }

  async function doTransfer() {
    if (!address) return;
    await writeContractAsync({
      address: TOKEN,
      abi: erc20Abi,
      functionName: "transfer",
      args: [to as `0x${string}`, parseUnits(amount, dec)],
    });
  }

  async function doMint() {
    if (!address) return;
    await writeContractAsync({
      address: TOKEN,
      abi: erc20Abi,
      functionName: "mint",
      args: [address as `0x${string}`, parseUnits(amount, dec)],
    });
  }

  async function doClaim() {
    if (!FAUCET) return;
    await writeContractAsync({
      address: FAUCET,
      abi: faucetAbi,
      functionName: "claim",
      args: [],
    });
  }

  return (
    <div style={{ maxWidth: 520, margin: "40px auto", fontFamily: "Inter" }}>
      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <div>
          <div>Address: {address}</div>
          <div>Chain: {chainId}</div>
        </div>
        <button onClick={() => disconnect()}>Disconnect</button>
      </div>

      <h2 style={{ marginTop: 24 }}>Token: {sym || "…"}</h2>
      <p>
        Balance:{" "}
        {balance.data
          ? `${formatUnits(balance.data as bigint, dec)} ${sym}`
          : "…"}
      </p>

      <div style={{ display: "grid", gap: 8, marginTop: 24 }}>
        <h3>Transfer</h3>
        <input
          placeholder="Recipient 0x..."
          value={to}
          onChange={(e) => setTo(e.target.value)}
        />
        <input
          placeholder={`Amount in ${sym || "units"}`}
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
        <button onClick={doTransfer} disabled={txPending}>
          Send
        </button>
      </div>

      <div style={{ display: "grid", gap: 8, marginTop: 24 }}>
        <h3>Mint (owner only)</h3>
        <input
          placeholder={`Amount in ${sym || "units"}`}
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
        <button onClick={doMint} disabled={txPending}>
          Mint to self
        </button>
        <small>Note: Reverts if your wallet isn’t the token owner.</small>
      </div>

      {FAUCET && (
        <div style={{ display: "grid", gap: 8, marginTop: 24 }}>
          <h3>Faucet</h3>
          <p>
            Drip:{" "}
            {drip.data
              ? `${formatUnits(drip.data as bigint, dec)} ${sym}`
              : "…"}
          </p>
          <p>
            Next eligible in:{" "}
            {eligibleTs.data ? `${secondsLeft()}s` : "—"}
          </p>
          <button onClick={doClaim} disabled={txPending || secondsLeft() > 0}>
            Claim
          </button>
          <small>If disabled, you’re on cooldown.</small>
        </div>
      )}
    </div>
  );
}

export default function App() {
  const { address } = useAccount();
  return address ? <DappView /> : <ConnectView />;
}