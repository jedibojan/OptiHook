// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {StrikePrices} from "../src/StrikePrices.sol";

contract StrikePricesTest is Test {
    using StrikePrices for *;

    uint256[] private currentPrices = [
        1035 * 10**18,
        1984 * 10**18
        // 1125 * 10**18,
        // 13625 * 10**17,
        // 1800 * 10**18,
        // 2250 * 10**18,
        // 2825 * 10**18,
        // 2940 * 10**18,
        // 3575 * 10**18,
        // 3755 * 10**18,
        // 4500 * 10**18,
        // 5650 * 10**18,
        // 7150 * 10**18,
        // 9000 * 10**18,
        // 11250 * 10**18,
        // 1000 * 10**18,
        // 2000 * 10**18,
        // 4000 * 10**18,
        // 28000 * 10**18,
        // 1560323 * 10**18
    ];

    uint32[] private timeIntervals = [
        2 days,      // 2 days
        14 days,     // 2 weeks
        60 days,     // 2 months
        180 days,     // 6 months
        200 days     // 6.5 months
    ];

    function testPrintStrikePrices() public view {
        uint32 currentTimestamp = uint32(block.timestamp);

        for (uint256 i = 0; i < currentPrices.length; i++) {
            uint256 currentPrice = currentPrices[i];
            console2.log("\n=== Current Price:", currentPrice / 10**18, "===");

            for (uint256 j = 0; j < timeIntervals.length; j++) {
                uint32 expirationTime = currentTimestamp + timeIntervals[j];
                // console2.log("\nTime to expiration:", timeIntervals[j] / 1 days, "days");

                uint256[] memory strikes = StrikePrices.getStrikePrices(currentPrice, expirationTime);
                
                // console2.log("Number of strikes:", strikes.length);
                // console2.log("Strike prices:");
                // for (uint256 k = 0; k < strikes.length; k++) {
                //     console2.log(strikes[k] / 10**18);
                // }
            }
        }
    }
} 