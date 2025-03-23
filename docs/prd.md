# OPTIHOOK Product Requirements Document v1.0

## 1. Title and Overview

OPTIHOOK is designed to simplify options trading in a decentralized, secure environment. This document outlines its key features, user roles, and detailed user stories to ensure a comprehensive understanding of development and implementation.

### 1.1 Document Title & Version

OPTIHOOK Product Requirements Document v1.0

### 1.2 Product Summary

OPTIHOOK is a decentralized, non-custodial options trading protocol built on the Ethereum blockchain, leveraging UniswapV4 hooks and its automated market maker (AMM) infrastructure. It enables users to:

- Buy and sell European-style options (exercisable only at expiration), including call (right to buy) and put (right to sell) types.
- Provide liquidity based on implied volatility ranges, earning trading fees.
- Mint fully collateralized options with cash settlement at expiration.

Liquidity providers (LPs) contribute assets within volatility ranges, and option prices are dynamically calculated on-chain using the Black-Scholes model, adapting to current volatility. Key features include:

- **Secure Settlement**: Uses Time Weighted Average Prices (TWAPs) from Uniswap to mitigate flash loan attacks.
- **Trade Sizes**: Minimum of 0.1 contracts, no maximum limit.
- **Settlement**: Anyone can execute post-expiration for an incentive.

OPTIHOOK targets traders, LPs, AI agents, administrators, and settlers, offering a robust platform for options trading and risk management in decentralized finance (DeFi).

## 2. User Personas

### 2.1 Key User Types

- **Traders**: Buy, sell, and mint options by locking collateral; claim payouts post-settlement.
- **Liquidity Providers (LPs)**: Supply and remove liquidity within volatility ranges to facilitate trading and earn fees.
- **AI Agents (Bots)**: Automate trading, liquidity provision, and risk management strategies.
- **Administrators**: Manage protocol parameters and ensure operational integrity.
- **Settlers**: Execute settlement for expired options.

### 2.2 Basic Persona Details

#### Traders
- **Role**: Engage in buying, selling, and minting European-style options.
- **Permissions**: Access trading interfaces, view market data (e.g., underlying asset, strike price, expiration date, premium), and execute trades.

#### Liquidity Providers (LPs)
- **Role**: Enable trade execution by providing liquidity within volatility ranges, earning fees.
- **Permissions**: Add/remove liquidity, specify volatility ranges, view positions, and claim fees.

#### AI Agents (Bots)
- **Role**: Optimize trading, liquidity provision, and delta-hedging for profit and risk management.
- **Permissions**: Interact via APIs for trading, liquidity management, and data retrieval.

#### Administrators
- **Role**: Oversee protocol configuration and maintenance.
- **Permissions**: Set strike prices, manage expiration times, and perform emergency interventions.

#### Settlers
- **Role**: Execute settlement for expired options markets.
- **Permissions**: Call the settlement function for expired markets.

### 2.3 Role-based Access

- **Traders**: Execute trades; no liquidity provision or protocol modification rights.
- **Liquidity Providers**: Manage liquidity positions; no trading on behalf of others or administrative control.
- **AI Agents**: Perform trader and LP actions via APIs; no administrative access.
- **Administrators**: Adjust protocol parameters; restricted from trading or providing liquidity.
- **Settlers**: Execute settlement for expired options markets.

## 3. User Stories and Acceptance Criteria

| ID     | Title                      | Description                                                  | Acceptance Criteria                                                                 |
|--------|----------------------------|--------------------------------------------------------------|-------------------------------------------------------------------------------------|
| US-001 | Mint New Options           | Mint call or put option tokens by locking collateral.        | Select market; lock underlying/base asset; mint tokens; collateral locked until expiration. |
| US-002 | Buy Options from AMM       | Buy option tokens from AMM by paying base asset.             | Select market; specify amount; calculate price; approve transfer; execute swap.     |
| US-003 | Sell Options to AMM        | Sell option tokens to AMM for base asset.                    | Select market; specify amount; calculate price; approve transfer; execute swap.     |
| US-004 | Claim Settlement Payout    | Claim cash settlement after expiration and settlement.       | Market expired; hold tokens; call claim; calculate payout; transfer base asset; burn tokens. |
| US-005 | Add Liquidity              | Add liquidity to options market within volatility range.     | Select market; specify range; provide capital; calculate tokens; approve transfer; receive LP tokens. |
| US-006 | Remove Liquidity           | Remove liquidity and receive back tokens and fees.           | Select market; specify LP tokens; calculate share; burn tokens; receive assets and fees. |
| US-007 | Execute Settlement         | Execute settlement for expired options market.               | Market expired; call function; check TWAP; process if normal; reject if anomalous.  |
| US-008 | Create New Options Market  | Create new market for specific assets, strike, expiration, type. | Pair allowed; strike allowed; date follows rules; specify type; create AMM pool.    |
| US-009 | Set Strike Prices          | Set allowed strike prices for asset pairs as owner.          | Have owner role; specify pair and prices; update system.                            |
| US-010 | Manage Asset Pair Registry | Add/remove allowed asset pairs as owner.                     | Have owner role; add/remove pairs; prevent new markets for removed pairs.           |

## 4. Additional Notes

### 4.1 Considerations and Challenges

Developing OPTIHOOK required understanding UniswapV4 hooks for customizing pool behavior to support volatility-based liquidity, differing from traditional price-range models. Research into protocols like Opyn informed mechanics such as collateral-locked oToken minting, shaping OPTIHOOK’s design. A key challenge was collateral management, resolved by integrating it with the AMM pool for LPs while allowing individual minting for traders. The settlement process, inspired by Deribit and secured with Uniswap TWAPs, ensures robustness against attacks. The focus on AI agents as primary users drove the inclusion of automated strategy support in user stories.

### 4.2 Conclusion

This PRD offers a comprehensive framework for OPTIHOOK, detailing all functionalities for a decentralized options trading protocol. It aligns with DeFi principles, addresses user needs through personas and stories, and incorporates security measures like TWAP checks. The document provides clear, testable requirements, ready for development.

## 5. Key Citations

- Uniswap V4 Overview Documentation
- Opyn V2 FAQ Documentation
- DeFi Pulse Opyn Project Stats