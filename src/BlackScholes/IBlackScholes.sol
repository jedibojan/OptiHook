// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

interface IBlackScholes {
  struct PricesAndGreeks {
    uint callPrice;
    uint putPrice;
    int callDelta;
    int putDelta;
    uint vega;
  }
}
