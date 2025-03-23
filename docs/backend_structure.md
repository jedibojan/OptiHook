# Backend Structure

This document outlines the backend architecture of the OPTIHOOK project, a fully blockchain-based decentralized options trading protocol deployed on the Ethereum network. The entire project operates as a backend system, leveraging smart contracts written in Solidity. Central to its design is the `v4-periphery` library from UniswapV4, which enables seamless integration with UniswapV4 pools, providing utilities and hooks to customize pool behavior for options trading. This structure ensures a secure, scalable, and efficient protocol tailored to decentralized financial markets.

## Introduction

OPTIHOOK is a backend blockchain application designed to facilitate decentralized options trading. It relies heavily on the `v4-periphery` library, a component of UniswapV4, to interact with UniswapV4's core contracts and extend their functionality through custom hooks and peripheral utilities. This integration allows OPTIHOOK to manage liquidity pools, execute swaps, and implement options-specific logic such as volatility-based pricing and time decay, all within a non-custodial, trustless environment on Ethereum.

## Core Components

### Smart Contracts

The backend consists of several smart contract categories, each fulfilling a specific role in the options trading ecosystem:

- **Options Hook Contract**:
  - Utilizes hook functions for functionality implementation
  - Handle the creation, trading, and management of European-style call and put options.
  - Lock collateral during option minting and release it upon settlement or expiration.
  - Allow liquidity providers (LPs) to deposit and withdraw assets within predefined volatility ranges.
  - Distribute trading fees to LPs proportional to their liquidity contributions.
  - Facilitate cash settlement of expired options using UniswapV4's Time Weighted Average Prices (TWAPs) to ensure fair pricing and mitigate manipulation risks.
  - Enable any user to trigger settlement after expiration, rewarding them with a small incentive.
  - Manage protocol governance, including setting strike prices, configuring asset pairs, and updating parameters like fee structures.

- **BlackScholes Contract**:
  - Used for options valuation

- **Expiration Times Contract**:
  - Generates available expiration times for creation of option markets

- **Strike Prices Contract**:
  - Provides available strike prices for creation of option markets

- **Pools Registry Contract**:
  - Keeps track of the pool keys allowed for base/underlying options pair market creation

### Integration with v4-periphery

The `v4-periphery` library is the backbone of OPTIHOOK's interaction with UniswapV4, providing a suite of tools and contracts that enhance the protocol's functionality. Key aspects of this integration include:

- **UniswapV4 Pool Management**:
  - The `v4-periphery` library enables the creation and management of UniswapV4 pools customized for options trading. It provides utilities to initialize pools with specific parameters, such as fee tiers and hook contracts, tailored to OPTIHOOK's needs.

- **Peripheral Contracts**:
  - OPTIHOOK leverages peripheral contracts from `v4-periphery` for critical operations:
    - **Swapping**: Facilitates asset swaps during options trading, ensuring efficient price discovery.
    - **Liquidity Operations**: Simplifies adding and removing liquidity, aligning with the protocol's volatility-driven model.
    - **Position Management**: Assists in tracking and managing LP positions within UniswapV4 pools.

- **Interfaces and Libraries**:
  - Standardized interfaces (e.g., `IPoolManager`, `IHook`) and libraries from `v4-periphery` ensure compatibility with UniswapV4's core contracts. These components provide reusable functions for tasks like fee calculation, pool state queries, and event emissions, enhancing the protocol's robustness and interoperability.

### Custom Hooks

A standout feature of `v4-periphery` is its support for custom hooks, which OPTIHOOK uses to implement options-specific logic within UniswapV4 pools:

- **Volatility-Based Liquidity Provision**:
  - Dynamically adjust pool pricing based on implied volatility, integrating the Black-Scholes model into the AMM framework for accurate option valuation.

These hooks are deployed as separate contracts and registered with UniswapV4 pools via `v4-periphery`, allowing OPTIHOOK to extend pool behavior beyond standard AMM functionality.

## Dependencies

Beyond `v4-periphery`, the backend incorporates several dependencies to support development, testing, and security:

- **Foundry**:
  - A powerful toolkit for smart contract development, including `forge` for compilation and testing, and `cast` for blockchain interactions.

- **forge-std**:
  - Foundry's standard library, offering testing utilities and helper functions to streamline contract verification.

- **OpenZeppelin**:
  - Provides secure implementations of ERC standards (e.g., ERC20, ERC721), access control mechanisms, and other utilities to ensure the protocol's safety and compliance.

- **UniswapV4 Core Libraries**:
  - Included as dependencies of `v4-periphery`, these libraries support low-level interactions with UniswapV4's core contracts, such as pool state management and fee handling.

## Deployment and Configuration

The backend's deployment and configuration are managed using Foundry's ecosystem:

- **Deployment Scripts**:
  - Located in the `script/` directory (e.g., `01_DeployOptions.s.sol`), these scripts deploy the smart contracts to Ethereum using `forge script`.

- **Configuration Files**:
  - **`foundry.toml`**: Defines compiler versions, optimization settings, and test configurations.
  - **Environment Variables**: Store sensitive data like private keys and RPC endpoints for secure deployment.

- **Testing Utilities**:
  - Scripts like `02_TimeTravel.s.sol` simulate blockchain state changes (e.g., advancing block timestamps) to test time-dependent features like settlement and time decay.

## Overview

The OPTIHOOK backend is a robust blockchain application that leverages the `v4-periphery` library to integrate seamlessly with UniswapV4. By utilizing peripheral contracts for swaps and liquidity management, and custom hooks for volatility and time decay, the protocol delivers a sophisticated options trading experience on Ethereum. The combination of Foundry, OpenZeppelin, and UniswapV4 dependencies ensures a secure, well-tested, and extensible architecture.

This structure separates concerns across trading, liquidity, settlement, and administration, with `v4-periphery` serving as the critical layer that ties these components to UniswapV4's decentralized infrastructure.