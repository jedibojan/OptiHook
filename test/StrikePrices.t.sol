// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {StrikePrices} from "../src/StrikePrices.sol";

// 192, 273.2, 100, 400, 754, 9950, 11000, 2000, 10000000, 48000
contract StrikePricesTest is Test {
    using StrikePrices for *;

    uint256[] private currentPrices = [
        1035 * 10**18,
        1984 * 10**18,
        1125 * 10**18,
        13625 * 10**17,
        1800 * 10**18,
        2250 * 10**18,
        2825 * 10**18,
        2940 * 10**18,
        3575 * 10**18,
        3755 * 10**18,
        4500 * 10**18,
        5650 * 10**18,
        7150 * 10**18,
        9000 * 10**18,
        11250 * 10**18,
        1000 * 10**18,
        2000 * 10**18,
        4000 * 10**18,
        28000 * 10**18,
        1560323 * 10**18
    ];

    uint32[] private timeIntervals = [
        2 days     // 2 days
        // 14 days,     // 2 weeks
        // 60 days,     // 2 months
        // 180 days,     // 6 months
        // 200 days     // 6.5 months
    ];

    // Test values for Category 0 (0-3 days)
    uint256[] private testPrices = [
        192 * 10**18,      // 192
        2732 * 10**17,     // 273.2
        100 * 10**18,      // 100
        400 * 10**18,      // 400
        754 * 10**18,      // 754
        9950 * 10**18,     // 9950
        11000 * 10**18,    // 11000
        2000 * 10**18,     // 2000
        10000000 * 10**18, // 10000000
        48000 * 10**18     // 48000
    ];

    uint32 private constant TWO_DAYS = 2 days;

    // function testPrintStrikePrices() public view {
    //     uint32 currentTimestamp = uint32(block.timestamp);

    //     for (uint256 i = 0; i < currentPrices.length; i++) {
    //         uint256 currentPrice = currentPrices[i];
    //         console2.log("\n=== Current Price:", currentPrice / 10**18, "===");

    //         for (uint256 j = 0; j < timeIntervals.length; j++) {
    //             uint32 expirationTime = currentTimestamp + timeIntervals[j];
    //             console2.log("\nTime to expiration:", timeIntervals[j] / 1 days, "days");

    //             uint256[] memory strikes = StrikePrices.getStrikePrices(currentPrice, expirationTime);
            
                
    //             console2.log("Number of strikes:", strikes.length);
    //             console2.log("Strike prices:");
    //             for (uint256 k = 0; k < strikes.length; k++) {
    //                 console2.log(strikes[k] / 10**18);
    //             }
    //         }
    //     }
    // }

    function testCategory0StrikePrice192() public view {
        uint32 expirationTime = uint32(block.timestamp) + 2 days;
        uint256[] memory strikes = StrikePrices.getStrikePrices(192 * 10**18, expirationTime);
        assertEq(strikes.length, 17);
        uint256[] memory expectedStrikes = new uint256[](17);
        expectedStrikes[0] = 170 * 10**18;
        expectedStrikes[1] = 175 * 10**18;
        expectedStrikes[2] = 180 * 10**18;
        expectedStrikes[3] = 180 * 10**18;
        expectedStrikes[4] = 1825 * 10**17;
        expectedStrikes[5] = 185 * 10**18;
        expectedStrikes[6] = 1875 * 10**17;
        expectedStrikes[7] = 190 * 10**18;
        expectedStrikes[8] = 1925 * 10**17;
        expectedStrikes[9] = 195 * 10**18;
        expectedStrikes[10] = 1975 * 10**17;
        expectedStrikes[11] = 200 * 10**18;
        expectedStrikes[12] = 205 * 10**18;
        expectedStrikes[13] = 210 * 10**18;
        expectedStrikes[14] = 215 * 10**18;
        expectedStrikes[15] = 220 * 10**18;
        expectedStrikes[16] = 225 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i]);
        }
    }

    function testCategory0StrikePrice273_2() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2732 * 10**17, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 25);
        
        uint256[] memory expectedStrikes = new uint256[](25);
        expectedStrikes[0] = 235 * 10**18;
        expectedStrikes[1] = 240 * 10**18;
        expectedStrikes[2] = 245 * 10**18;
        expectedStrikes[3] = 250 * 10**18;
        expectedStrikes[4] = 255 * 10**18;
        expectedStrikes[5] = 260 * 10**18;
        expectedStrikes[6] = 260 * 10**18;
        expectedStrikes[7] = 2625 * 10**17;
        expectedStrikes[8] = 265 * 10**18;
        expectedStrikes[9] = 2675 * 10**17;
        expectedStrikes[10] = 270 * 10**18;
        expectedStrikes[11] = 2725 * 10**17;
        expectedStrikes[12] = 275 * 10**18;
        expectedStrikes[13] = 2775 * 10**17;
        expectedStrikes[14] = 280 * 10**18;
        expectedStrikes[15] = 2825 * 10**17;
        expectedStrikes[16] = 285 * 10**18;
        expectedStrikes[17] = 2875 * 10**17;
        expectedStrikes[18] = 290 * 10**18;
        expectedStrikes[19] = 295 * 10**18;
        expectedStrikes[20] = 300 * 10**18;
        expectedStrikes[21] = 305 * 10**18;
        expectedStrikes[22] = 310 * 10**18;
        expectedStrikes[23] = 315 * 10**18;
        expectedStrikes[24] = 320 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i]);
        }
    }

    function testCategory0StrikePrice100() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(100 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 875 * 10**17;
        expectedStrikes[1] = 90 * 10**18;
        expectedStrikes[2] = 925 * 10**17;
        expectedStrikes[3] = 95 * 10**18;
        expectedStrikes[4] = 95 * 10**18;
        expectedStrikes[5] = 9625 * 10**16;
        expectedStrikes[6] = 975 * 10**17;
        expectedStrikes[7] = 9875 * 10**16;
        expectedStrikes[8] = 100 * 10**18;
        expectedStrikes[9] = 10125 * 10**16;
        expectedStrikes[10] = 1025 * 10**17;
        expectedStrikes[11] = 10375 * 10**16;
        expectedStrikes[12] = 105 * 10**18;
        expectedStrikes[13] = 1075 * 10**17;
        expectedStrikes[14] = 110 * 10**18;
        expectedStrikes[15] = 1125 * 10**17;
        expectedStrikes[16] = 115 * 10**18;
        expectedStrikes[17] = 1175 * 10**17;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i]);
        }
    }

    function testCategory0StrikePrice400() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(400 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 350 * 10**18;
        expectedStrikes[1] = 360 * 10**18;
        expectedStrikes[2] = 370 * 10**18;
        expectedStrikes[3] = 380 * 10**18;
        expectedStrikes[4] = 380 * 10**18;
        expectedStrikes[5] = 385 * 10**18;
        expectedStrikes[6] = 390 * 10**18;
        expectedStrikes[7] = 395 * 10**18;
        expectedStrikes[8] = 400 * 10**18;
        expectedStrikes[9] = 405 * 10**18;
        expectedStrikes[10] = 410 * 10**18;
        expectedStrikes[11] = 415 * 10**18;
        expectedStrikes[12] = 420 * 10**18;
        expectedStrikes[13] = 430 * 10**18;
        expectedStrikes[14] = 440 * 10**18;
        expectedStrikes[15] = 450 * 10**18;
        expectedStrikes[16] = 460 * 10**18;
        expectedStrikes[17] = 470 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }

    function testCategory0StrikePrice754() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(754 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 13);
        
        uint256[] memory expectedStrikes = new uint256[](13);
        expectedStrikes[0] = 675 * 10**18;
        expectedStrikes[1] = 700 * 10**18;
        expectedStrikes[2] = 725 * 10**18;
        expectedStrikes[3] = 725 * 10**18;
        expectedStrikes[4] = 7375 * 10**17;
        expectedStrikes[5] = 750 * 10**18;
        expectedStrikes[6] = 7625 * 10**17;
        expectedStrikes[7] = 775 * 10**18;
        expectedStrikes[8] = 7875 * 10**17;
        expectedStrikes[9] = 800 * 10**18;
        expectedStrikes[10] = 825 * 10**18;
        expectedStrikes[11] = 850 * 10**18;
        expectedStrikes[12] = 875 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i]);
        }
    }

    function testCategory0StrikePrice9950() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(9950 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 8750 * 10**18;
        expectedStrikes[1] = 9000 * 10**18;
        expectedStrikes[2] = 9250 * 10**18;
        expectedStrikes[3] = 9500 * 10**18;
        expectedStrikes[4] = 9500 * 10**18;
        expectedStrikes[5] = 9625 * 10**18;
        expectedStrikes[6] = 9750 * 10**18;
        expectedStrikes[7] = 9875 * 10**18;
        expectedStrikes[8] = 10000 * 10**18;
        expectedStrikes[9] = 10125 * 10**18;
        expectedStrikes[10] = 10250 * 10**18;
        expectedStrikes[11] = 10375 * 10**18;
        expectedStrikes[12] = 10500 * 10**18;
        expectedStrikes[13] = 10750 * 10**18;
        expectedStrikes[14] = 11000 * 10**18;
        expectedStrikes[15] = 11250 * 10**18;
        expectedStrikes[16] = 11500 * 10**18;
        expectedStrikes[17] = 11750 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }

    function testCategory0StrikePrice11000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(11000 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 20);
        
        uint256[] memory expectedStrikes = new uint256[](20);
        expectedStrikes[0] = 9500 * 10**18;
        expectedStrikes[1] = 9750 * 10**18;
        expectedStrikes[2] = 10000 * 10**18;
        expectedStrikes[3] = 10250 * 10**18;
        expectedStrikes[4] = 10500 * 10**18;
        expectedStrikes[5] = 10500 * 10**18;
        expectedStrikes[6] = 10625 * 10**18;
        expectedStrikes[7] = 10750 * 10**18;
        expectedStrikes[8] = 10875 * 10**18;
        expectedStrikes[9] = 11000 * 10**18;
        expectedStrikes[10] = 11125 * 10**18;
        expectedStrikes[11] = 11250 * 10**18;
        expectedStrikes[12] = 11375 * 10**18;
        expectedStrikes[13] = 11500 * 10**18;
        expectedStrikes[14] = 11750 * 10**18;
        expectedStrikes[15] = 12000 * 10**18;
        expectedStrikes[16] = 12250 * 10**18;
        expectedStrikes[17] = 12500 * 10**18;
        expectedStrikes[18] = 12750 * 10**18;
        expectedStrikes[19] = 13000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }

    function testCategory0StrikePrice2000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2000 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 1750 * 10**18;
        expectedStrikes[1] = 1800 * 10**18;
        expectedStrikes[2] = 1850 * 10**18;
        expectedStrikes[3] = 1900 * 10**18;
        expectedStrikes[4] = 1900 * 10**18;
        expectedStrikes[5] = 1925 * 10**18;
        expectedStrikes[6] = 1950 * 10**18;
        expectedStrikes[7] = 1975 * 10**18;
        expectedStrikes[8] = 2000 * 10**18;
        expectedStrikes[9] = 2025 * 10**18;
        expectedStrikes[10] = 2050 * 10**18;
        expectedStrikes[11] = 2075 * 10**18;
        expectedStrikes[12] = 2100 * 10**18;
        expectedStrikes[13] = 2150 * 10**18;
        expectedStrikes[14] = 2200 * 10**18;
        expectedStrikes[15] = 2250 * 10**18;
        expectedStrikes[16] = 2300 * 10**18;
        expectedStrikes[17] = 2350 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }

    function testCategory0StrikePrice10000000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(10000000 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 8750000 * 10**18;
        expectedStrikes[1] = 9000000 * 10**18;
        expectedStrikes[2] = 9250000 * 10**18;
        expectedStrikes[3] = 9500000 * 10**18;
        expectedStrikes[4] = 9500000 * 10**18;
        expectedStrikes[5] = 9625000 * 10**18;
        expectedStrikes[6] = 9750000 * 10**18;
        expectedStrikes[7] = 9875000 * 10**18;
        expectedStrikes[8] = 10000000 * 10**18;
        expectedStrikes[9] = 10125000 * 10**18;
        expectedStrikes[10] = 10250000 * 10**18;
        expectedStrikes[11] = 10375000 * 10**18;
        expectedStrikes[12] = 10500000 * 10**18;
        expectedStrikes[13] = 10750000 * 10**18;
        expectedStrikes[14] = 11000000 * 10**18;
        expectedStrikes[15] = 11250000 * 10**18;
        expectedStrikes[16] = 11500000 * 10**18;
        expectedStrikes[17] = 11750000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }

    function testCategory0StrikePrice48000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(48000 * 10**18, uint32(block.timestamp + 2 days));
        assertEq(strikes.length, 10);
        
        uint256[] memory expectedStrikes = new uint256[](10);
        expectedStrikes[0] = 42500 * 10**18;
        expectedStrikes[1] = 45000 * 10**18;
        expectedStrikes[2] = 45000 * 10**18;
        expectedStrikes[3] = 46250 * 10**18;
        expectedStrikes[4] = 47500 * 10**18;
        expectedStrikes[5] = 48750 * 10**18;
        expectedStrikes[6] = 50000 * 10**18;
        expectedStrikes[7] = 52500 * 10**18;
        expectedStrikes[8] = 55000 * 10**18;
        expectedStrikes[9] = 57500 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }
} 