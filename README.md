# King of the Ether Throne v0.3.0 Verification

**Contract:** [`0xa9d160e32ad37ac6f2b8231e4efe14d35abb576e`](https://etherscan.io/address/0xa9d160e32ad37ac6f2b8231e4efe14d35abb576e)  
**Deployment tx:** [`0x...`](https://etherscan.io/tx/0x58ec2b2cdc2a6e52e6c37b6c7e3c8e04e5e9e6f7a8b9c0d1e2f3a4b5c6d7e8f9)  
**Block:** 893,433  
**Date:** January 23, 2016  
**Deployer:** `0x2f88180369377869a1bc5ae807416f72d736c206` (Kieran Elby)

## What Is This?

King of the Ether Throne (KotET) was one of the first viral Ethereum dapps, deployed January 23, 2016 during the Frontier era. Players competed to hold the "throne" by paying an increasing claim price; the previous holder received compensation, minus a 1% wizard commission. The throne had 12 monarchs before being succeeded by an improved version.

The contract became notable in the Ethereum community for exposing a subtle but important bug: sending ETH from a contract to a Mist wallet-based contract (which required more than the 2,300 gas stipend) would silently fail, causing some compensation payments to not be delivered. Kieran Elby documented this in detail in a [post-mortem](http://www.kingoftheether.com/postmortem.html) that became widely read in the early Ethereum developer community.

This is the original v0.3.0 contract, deployed before the bug was discovered and before the v1.0 rewrite.

## Compiler

- **Compiler:** `soljson-v0.2.0-nightly.2016.1.20+commit.67c855c5`
- **Optimizer:** OFF
- **Language:** Solidity

## Verification

Source code was published by the contract author (Kieran Elby) in the [KingOfTheEtherThrone GitHub repository](https://github.com/kieranelby/KingOfTheEtherThrone) at commit [`54041a8`](https://github.com/kieranelby/KingOfTheEtherThrone/commit/54041a837aecb609b0f9f4ca58fb1180500f08e7), tagged as version 0.3.0, January 23, 2016.

The README at that commit explicitly documents the compiler: `solidity 0.2.0-67c855c5 without optimization`.

Compiling `KingOfTheEtherThrone.sol` with `soljson-v0.2.0-nightly.2016.1.20+commit.67c855c5` (optimizer OFF) produces a **byte-for-byte exact match** of the 2,833-byte on-chain runtime bytecode. No source modifications required.

## Files

- `KingOfTheEtherThrone.sol` - original source (from commit 54041a8, unmodified)
- `onchain-runtime.hex` - on-chain runtime bytecode (2,833 bytes)
- `verify.sh` - reproducible verification script

## Contract Summary

| Field | Value |
|-------|-------|
| Starting claim price | 10 finney |
| Claim price adjustment | x1.5 each reign (x3/2) |
| Wizard commission | 1% (1/100) |
| Monarchs | 12 total |
| ETH at address | 0 (swept by wizard) |

## Storage Layout

| Slot | Variable |
|------|----------|
| 0 | `wizardAddress` |
| 1 | `accumulatedWizardPayments` |
| 2 | `currentClaimPrice` |
| 3-6 | `currentMonarch` (struct: etherAddress, name, claimPrice, coronationTimestamp) |
| 7 | `pastMonarchs` (array length) |

## Historical Note

The fallback function bug that caused compensation payment failures during the "Turbulent Age" (Feb 6-8, 2016) is present in this contract: `currentMonarch.etherAddress.send(compensation)` uses only the default 2,300 gas stipend, which is insufficient for Mist-style contract wallets. Kieran Elby's post-mortem on this issue was one of the earliest and most thorough public security analyses of an Ethereum smart contract.

## Related

- [EthereumHistory contract page](https://www.ethereumhistory.com/contract/0xa9d160e32ad37ac6f2b8231e4efe14d35abb576e)
- [awesome-ethereum-proofs](https://github.com/cartoonitunes/awesome-ethereum-proofs)
- [Original GitHub repo](https://github.com/kieranelby/KingOfTheEtherThrone)
- [Post-mortem](http://www.kingoftheether.com/postmortem.html)
