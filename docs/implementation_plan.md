# Implementation Plan

This document outlines a detailed, step-by-step plan for implementing the project, adhering to a Test Driven Development (TDD) methodology. The project consists of several smart contracts and mechanisms to create a decentralized options market system, including expiration times, strike prices, options valuation, liquidity provision, swaps, and hedging.

---

## **ExpDates Smart Contract**
- **Purpose**: Manages the available expiration times for option markets, allowing the system to define when options expire.
- **Key Features**:
  - Algorithmic creation of available expiration times based on European options rules.
  - Ability to query available expiration times.
- **Implementation Details**:
  - Use OpenZeppelin's `Ownable` for access control.
  - Store expiration times as timestamps (e.g., `uint256`) in an array or mapping.
  - Ensure expiration times are in the future.
- **Functions**:
  - `getExpirationTimes()`: Returns an array of all available expiration times (view function).
  - `isExpirationTimeAvailable(uint256 timestamp)`: Checks if a specific expiration time exists (view function).
- **TDD Approach**:
  - Write tests:
    - Querying returns the correct list of expiration times.
    - Availability check returns true/false correctly.
  - Implement the contract to pass all tests.

---

## **StrikePrices Smart Contract**
- **Purpose**: Manages the available strike prices for option markets, defining the price levels at which options can be exercised.
- **Key Features**:
  - Restricted access to adding/removing strike prices (e.g., only the owner).
  - Strike prices should be more condensed around current ATM price
  - Ability to query available strike prices.
- **Implementation Details**:
  - Use OpenZeppelin's `Ownable` for access control.
  - Store strike prices as `uint256` values in an array or mapping.
  - Ensure strike prices are positive numbers.
- **Functions**:
  - `addStrikePrices(uint256 price)`: Adds strike prices, callable only by the owner.
  - `updateStrikePrices(uint256 price)`: Updates strike prices, callable only by the owner.
  - `getStrikePrices()`: Returns an array of all available strike prices (view function).
  - `isStrikePriceAvailable(uint256 price)`: Checks if a specific strike price exists (view function).
- **TDD Approach**:
  - Write tests:
    - Adding a strike price by the owner succeeds.
    - Adding by a non-owner fails.
    - Updating strike prices by the owner succeeds.
    - Updating strike prices by non-owner reverts.
    - Querying returns the correct list of strike prices.
    - Availability check returns true/false correctly.
  - Implement the contract to pass all tests.

---

## **BlackScholes Smart Contract**
- **Purpose**: Provides options valuation using the Black-Scholes model to calculate call and put option prices.
- **Key Features**:
  - Computes option prices based on standard Black-Scholes inputs.
  - Handles Solidity's lack of floating-point arithmetic with fixed-point numbers.
- **Implementation Details**:
  - Use a fixed-point arithmetic library (e.g., ABDK Math 64.64) for precise calculations.
  - Implement an approximation for the cumulative distribution function (CDF) of the standard normal distribution (e.g., Hart or polynomial approximation).
  - Input parameters:
    - `S`: Underlying asset price (e.g., in wei).
    - `K`: Strike price (e.g., in wei).
    - `T`: Time to expiration in seconds (converted to years internally).
    - `r`: Risk-free rate (e.g., scaled by 1e18, where 0.05 = 5e16).
    - `sigma`: Volatility (e.g., scaled by 1e18, where 0.2 = 2e17).
  - Convert `T` to years: `T_years = T * 1e18 / (365.25 * 86400)` using fixed-point arithmetic.
  - Implement the Black-Scholes formulas:
    - Call: `C = S * N(d1) - K * e^(-r * T_years) * N(d2)`
    - Put: `P = K * e^(-r * T_years) * N(-d2) - S * N(-d1)`
    - Where:
      - `d1 = (ln(S/K) + (r + sigma^2 / 2) * T_years) / (sigma * sqrt(T_years))`
      - `d2 = d1 - sigma * sqrt(T_years)`
- **Functions**:
  - `getCallPrice(uint256 S, uint256 K, uint256 T, uint256 r, uint256 sigma)`: Returns the call option price (view function).
  - `getPutPrice(uint256 S, uint256 K, uint256 T, uint256 r, uint256 sigma)`: Returns the put option price (view function).
- **TDD Approach**:
  - Write tests:
    - Test call and put prices with known inputs against expected outputs (e.g., benchmarked from external Black-Scholes calculators).
    - Test edge cases (e.g., T = 0, sigma = 0).
    - Ensure precision within acceptable bounds given fixed-point arithmetic.
  - Implement the contract to pass all tests.

---

## **Hook Smart Contract**
- **Purpose**: Serves as the core contract managing liquidity provision and option swaps across various markets, integrating with `ExpDates`, `StrikePrices`, and `BlackScholes`.

### Add/Remove Liquidity on Options Markets
- **Purpose**: Allows liquidity providers (LPs) to add and remove liquidity in implied volatility ranges, using `BlackScholes` for pricing.
- **Key Features**:
  - LPs provide collateral and specify volatility ranges for fee eligibility.
  - Collateral ensures the pool can mint options.
- **Implementation Details**:
  - Define option pools for each combination of:
    - `K`: Strike price from `StrikePrices`.
    - `T`: Expiration time from `ExpDates`.
    - `type`: Call or put.
  - Each pool tracks:
    - `total_collateral`: Sum of collateral from all LPs (underlying asset for calls, base asset for puts).
    - `total_options_outstanding`: Number of options minted and not burned.
    - `premium_balance`: Base asset accumulated from premiums.
    - `sigma_current`: Current implied volatility (e.g., scaled by 1e18).
    - LP positions: Struct with `owner`, `[sigma_min, sigma_max]`, `collateral` (C), `accumulated_fees`.
  - Collateral requirements:
    - Calls: `total_collateral >= total_options_outstanding * 1` (underlying per option).
    - Puts: `total_collateral >= total_options_outstanding * K` (base asset).
  - Fees are distributed to LPs whose volatility range includes `sigma_current` at trade time.
- **Functions**:
  - `addLiquidity(uint256 K, uint256 T, bool isCall, uint256 collateral, uint256 sigma_min, uint256 sigma_max)`:
    - LP transfers collateral (underlying for calls, base for puts).
    - Record position with `[sigma_min, sigma_max]`, `collateral`.
    - Update `total_collateral += collateral`.
  - `removeLiquidity(uint256 positionId)`:
    - Check `total_collateral - collateral >= total_options_outstanding * requirement`.
    - If true, transfer `collateral` and `accumulated_fees` to LP, update `total_collateral`.
    - Revert if undercollateralized.
- **TDD Approach**:
  - Write tests:
    - Adding liquidity increases `total_collateral` and records position.
    - Removing liquidity succeeds when collateral requirement is met, fails otherwise.
    - Fees accumulate correctly for active LPs.
  - Implement to pass all tests.

### Implement Swaps (Buy and Sell Options)
- **Purpose**: Enables users to buy options from the pool and sell options back, with collateral locked appropriately.
- **Key Features**:
  - Buying: Users pay a premium, pool mints options.
  - Selling: Users lock collateral to mint options, then sell to the pool.
  - `sigma_current` adjusts based on trade activity.
- **Implementation Details**:
  - Use `BlackScholes` to compute prices with `sigma_current`.
  - Buying options:
    - Price = `getOptionPrice(S, K, T - block.timestamp, r, sigma_current, type)`.
    - Check collateral sufficiency post-trade.
    - Adjust `sigma_current` upward based on trade size.
  - Selling options:
    - User locks collateral, mints options, transfers to pool.
    - Pool burns options, pays premium.
    - Adjust `sigma_current` downward.
  - Volatility adjustment: `sigma_current += k * amount / total_collateral` (buy), `-=` (sell), where `k` is a constant.
  - Fee distribution: A portion of the premium (e.g., 0.3%) goes to active LPs.
- **Functions**:
  - `buyOption(uint256 K, uint256 T, bool isCall, uint256 amount)`:
    - Compute premium `P`.
    - User pays `P`, pool mints `amount` options.
    - `total_options_outstanding += amount`, `premium_balance += P`.
    - `sigma_current += k * amount / total_collateral`.
    - Distribute fees to active LPs.
  - `sellOption(uint256 K, uint256 T, bool isCall, uint256 amount)`:
    - User locks collateral, mints `amount` options, transfers to pool.
    - Compute premium `P`, pool pays `P` from `premium_balance`.
    - Pool burns options, `total_options_outstanding -= amount`.
    - `premium_balance -= P`, `sigma_current -= k * amount / total_collateral`.
    - Distribute fees.
- **TDD Approach**:
  - Write tests:
    - Buying increases `total_options_outstanding`, adjusts `sigma_current` up.
    - Selling with proper collateral succeeds, adjusts `sigma_current` down.
    - Collateral checks prevent undercollateralization.
    - Fees distribute correctly.
  - Implement to pass all tests.

---

## **Hedging Mechanisms**
- **Purpose**: Mitigate the pool's risk from selling options, focusing on delta hedging, with exploration of gamma hedging.
- **Key Features**:
  - Delta hedging neutralizes directional risk from option positions.
  - Optional exploration of gamma hedging for LPs.
- **Implementation Details**:
  - **Delta Hedging**:
    - For calls: Delta is positive (0 to 1), pool is short, net delta = `-total_options_outstanding * delta_call`.
    - Hedge: Hold `total_options_outstanding * delta_call` underlying (use collateral or premiums to adjust).
    - For puts: Delta is negative (-1 to 0), net delta = `-total_options_outstanding * delta_put`.
    - Hedge: Short `-total_options_outstanding * delta_put` underlying (requires external mechanism).
    - Compute delta using `BlackScholes` partial derivatives or approximation.
    - Periodically adjust holdings (e.g., via a DEX integration, simplified for this project).
  - **Gamma Hedging** (Exploration):
    - Gamma measures delta's sensitivity to underlying price changes.
    - Requires additional option positions or dynamic rebalancing, possibly too complex for initial scope.
    - Document feasibility for on-chain implementation.
- **Functions**:
  - `calculateDelta(uint256 S, uint256 K, uint256 T, uint256 r, uint256 sigma, bool isCall)`: Returns delta (view function).
  - `hedgePosition(uint256 K, uint256 T, bool isCall)`: Adjusts underlying holdings based on delta (simplified).
- **TDD Approach**:
  - Write tests:
    - Delta calculations match expected values.
    - Hedging adjusts position correctly for calls (puts optional).
    - Gamma exploration documented if implemented.
  - Implement to pass tests, simplify hedging execution if needed.

---

This markdown-formatted implementation plan provides a clear and structured guide for developing the options market system, ensuring each component is built and tested methodically.