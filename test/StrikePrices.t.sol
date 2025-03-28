// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {StrikePrices} from "../src/StrikePrices.sol";

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
        // 2 days     // 2 days
        // 14 days     // 2 weeks
        // 60 days     // 2 months
        160 days     // 6 months
        // 200 days     // 6.5 months
    ];

    // Test values for Category 0 (0-3 days)
    uint256[] private testPrices = [
        192 * 10**18,      // 192
        2732 * 10**17,     // 273.2 // TODO: pay attention to this price. see what happens if you have much more decimals
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

    // TODO: fix the rounding problem with strike prices and then remove this test
    function testPrintStrikePrices() public view {
        uint32 currentTimestamp = uint32(block.timestamp);

        for (uint256 i = 0; i < currentPrices.length; i++) {
            uint256 currentPrice = currentPrices[i];
            console2.log("\n=== Current Price:", currentPrice / 10**18, "===");

            for (uint256 j = 0; j < timeIntervals.length; j++) {
                uint32 expirationTime = currentTimestamp + timeIntervals[j];
                console2.log("\nTime to expiration:", timeIntervals[j] / 1 days, "days");

                uint256[] memory strikes = StrikePrices.getStrikePrices(currentPrice, expirationTime);
            
                
                console2.log("Number of strikes:", strikes.length);
                console2.log("Strike prices:");
                for (uint256 k = 0; k < strikes.length; k++) {
                    console2.log(strikes[k] / 10**18);
                }
            }
        }
    }

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

    function testCategory1StrikePrice192() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(192 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 22);
        
        uint256[] memory expectedStrikes = new uint256[](22);
        // Fine-grained strikes from minStrike (135) to 110% of ATM (210)
        expectedStrikes[0] = 135 * 10**18;
        expectedStrikes[1] = 140 * 10**18;
        expectedStrikes[2] = 145 * 10**18;
        expectedStrikes[3] = 150 * 10**18;
        expectedStrikes[4] = 155 * 10**18;
        expectedStrikes[5] = 160 * 10**18;
        expectedStrikes[6] = 165 * 10**18;
        expectedStrikes[7] = 170 * 10**18;
        expectedStrikes[8] = 175 * 10**18;
        expectedStrikes[9] = 180 * 10**18;
        expectedStrikes[10] = 185 * 10**18;
        expectedStrikes[11] = 190 * 10**18;
        expectedStrikes[12] = 195 * 10**18;
        expectedStrikes[13] = 200 * 10**18;
        expectedStrikes[14] = 205 * 10**18;
        expectedStrikes[15] = 210 * 10**18;
        // Coarse-grained strikes from 220 to maxStrike (270) with 2x increment
        expectedStrikes[16] = 220 * 10**18;
        expectedStrikes[17] = 230 * 10**18;
        expectedStrikes[18] = 240 * 10**18;
        expectedStrikes[19] = 250 * 10**18;
        expectedStrikes[20] = 260 * 10**18;
        expectedStrikes[21] = 270 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], "Incorrect strike price");
        }
    }

    function testCategory1StrikePrice273_2() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2732 * 10**17, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 32);
        uint256[] memory expectedStrikes = new uint256[](32);
        expectedStrikes[0] = 190 * 10**18;
        expectedStrikes[1] = 195 * 10**18;
        expectedStrikes[2] = 200 * 10**18;
        expectedStrikes[3] = 205 * 10**18;
        expectedStrikes[4] = 210 * 10**18;
        expectedStrikes[5] = 215 * 10**18;
        expectedStrikes[6] = 220 * 10**18;
        expectedStrikes[7] = 225 * 10**18;
        expectedStrikes[8] = 230 * 10**18;
        expectedStrikes[9] = 235 * 10**18;
        expectedStrikes[10] = 240 * 10**18;
        expectedStrikes[11] = 245 * 10**18;
        expectedStrikes[12] = 250 * 10**18;
        expectedStrikes[13] = 255 * 10**18;
        expectedStrikes[14] = 260 * 10**18;
        expectedStrikes[15] = 265 * 10**18;
        expectedStrikes[16] = 270 * 10**18;
        expectedStrikes[17] = 275 * 10**18;
        expectedStrikes[18] = 280 * 10**18;
        expectedStrikes[19] = 285 * 10**18;
        expectedStrikes[20] = 290 * 10**18;
        expectedStrikes[21] = 295 * 10**18;
        expectedStrikes[22] = 300 * 10**18;
        expectedStrikes[23] = 305 * 10**18;
        expectedStrikes[24] = 315 * 10**18;
        expectedStrikes[25] = 325 * 10**18;
        expectedStrikes[26] = 335 * 10**18;
        expectedStrikes[27] = 345 * 10**18;
        expectedStrikes[28] = 355 * 10**18;
        expectedStrikes[29] = 365 * 10**18;
        expectedStrikes[30] = 375 * 10**18;
        expectedStrikes[31] = 385 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory1StrikePrice400() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(400 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 23);
        uint256[] memory expectedStrikes = new uint256[](23);
        expectedStrikes[0] = 280 * 10**18;
        expectedStrikes[1] = 290 * 10**18;
        expectedStrikes[2] = 300 * 10**18;
        expectedStrikes[3] = 310 * 10**18;
        expectedStrikes[4] = 320 * 10**18;
        expectedStrikes[5] = 330 * 10**18;
        expectedStrikes[6] = 340 * 10**18;
        expectedStrikes[7] = 350 * 10**18;
        expectedStrikes[8] = 360 * 10**18;
        expectedStrikes[9] = 370 * 10**18;
        expectedStrikes[10] = 380 * 10**18;
        expectedStrikes[11] = 390 * 10**18;
        expectedStrikes[12] = 400 * 10**18;
        expectedStrikes[13] = 410 * 10**18;
        expectedStrikes[14] = 420 * 10**18;
        expectedStrikes[15] = 430 * 10**18;
        expectedStrikes[16] = 440 * 10**18;
        expectedStrikes[17] = 460 * 10**18;
        expectedStrikes[18] = 480 * 10**18;
        expectedStrikes[19] = 500 * 10**18;
        expectedStrikes[20] = 520 * 10**18;
        expectedStrikes[21] = 540 * 10**18;
        expectedStrikes[22] = 560 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory1StrikePrice754() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(754 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 525 * 10**18;
        expectedStrikes[1] = 550 * 10**18;
        expectedStrikes[2] = 575 * 10**18;
        expectedStrikes[3] = 600 * 10**18;
        expectedStrikes[4] = 625 * 10**18;
        expectedStrikes[5] = 650 * 10**18;
        expectedStrikes[6] = 675 * 10**18;
        expectedStrikes[7] = 700 * 10**18;
        expectedStrikes[8] = 725 * 10**18;
        expectedStrikes[9] = 750 * 10**18;
        expectedStrikes[10] = 775 * 10**18;
        expectedStrikes[11] = 800 * 10**18;
        expectedStrikes[12] = 825 * 10**18;
        expectedStrikes[13] = 875 * 10**18;
        expectedStrikes[14] = 925 * 10**18;
        expectedStrikes[15] = 975 * 10**18;
        expectedStrikes[16] = 1025 * 10**18;
        expectedStrikes[17] = 1075 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory1StrikePrice9950() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(9950 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 23);
        uint256[] memory expectedStrikes = new uint256[](23);
        expectedStrikes[0] = 7000 * 10**18;
        expectedStrikes[1] = 7250 * 10**18;
        expectedStrikes[2] = 7500 * 10**18;
        expectedStrikes[3] = 7750 * 10**18;
        expectedStrikes[4] = 8000 * 10**18;
        expectedStrikes[5] = 8250 * 10**18;
        expectedStrikes[6] = 8500 * 10**18;
        expectedStrikes[7] = 8750 * 10**18;
        expectedStrikes[8] = 9000 * 10**18;
        expectedStrikes[9] = 9250 * 10**18;
        expectedStrikes[10] = 9500 * 10**18;
        expectedStrikes[11] = 9750 * 10**18;
        expectedStrikes[12] = 10000 * 10**18;
        expectedStrikes[13] = 10250 * 10**18;
        expectedStrikes[14] = 10500 * 10**18;
        expectedStrikes[15] = 10750 * 10**18;
        expectedStrikes[16] = 11000 * 10**18;
        expectedStrikes[17] = 11500 * 10**18;
        expectedStrikes[18] = 12000 * 10**18;
        expectedStrikes[19] = 12500 * 10**18;
        expectedStrikes[20] = 13000 * 10**18;
        expectedStrikes[21] = 13500 * 10**18;
        expectedStrikes[22] = 14000 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory1StrikePrice11000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(11000 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 25);
        uint256[] memory expectedStrikes = new uint256[](25);
        expectedStrikes[0] = 7750 * 10**18;
        expectedStrikes[1] = 8000 * 10**18;
        expectedStrikes[2] = 8250 * 10**18;
        expectedStrikes[3] = 8500 * 10**18;
        expectedStrikes[4] = 8750 * 10**18;
        expectedStrikes[5] = 9000 * 10**18;
        expectedStrikes[6] = 9250 * 10**18;
        expectedStrikes[7] = 9500 * 10**18;
        expectedStrikes[8] = 9750 * 10**18;
        expectedStrikes[9] = 10000 * 10**18;
        expectedStrikes[10] = 10250 * 10**18;
        expectedStrikes[11] = 10500 * 10**18;
        expectedStrikes[12] = 10750 * 10**18;
        expectedStrikes[13] = 11000 * 10**18;
        expectedStrikes[14] = 11250 * 10**18;
        expectedStrikes[15] = 11500 * 10**18;
        expectedStrikes[16] = 11750 * 10**18;
        expectedStrikes[17] = 12000 * 10**18;
        expectedStrikes[18] = 12500 * 10**18;
        expectedStrikes[19] = 13000 * 10**18;
        expectedStrikes[20] = 13500 * 10**18;
        expectedStrikes[21] = 14000 * 10**18;
        expectedStrikes[22] = 14500 * 10**18;
        expectedStrikes[23] = 15000 * 10**18;
        expectedStrikes[24] = 15500 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory1StrikePrice2000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2000 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 23);
        uint256[] memory expectedStrikes = new uint256[](23);
        expectedStrikes[0] = 1400 * 10**18;
        expectedStrikes[1] = 1450 * 10**18;
        expectedStrikes[2] = 1500 * 10**18;
        expectedStrikes[3] = 1550 * 10**18;
        expectedStrikes[4] = 1600 * 10**18;
        expectedStrikes[5] = 1650 * 10**18;
        expectedStrikes[6] = 1700 * 10**18;
        expectedStrikes[7] = 1750 * 10**18;
        expectedStrikes[8] = 1800 * 10**18;
        expectedStrikes[9] = 1850 * 10**18;
        expectedStrikes[10] = 1900 * 10**18;
        expectedStrikes[11] = 1950 * 10**18;
        expectedStrikes[12] = 2000 * 10**18;
        expectedStrikes[13] = 2050 * 10**18;
        expectedStrikes[14] = 2100 * 10**18;
        expectedStrikes[15] = 2150 * 10**18;
        expectedStrikes[16] = 2200 * 10**18;
        expectedStrikes[17] = 2300 * 10**18;
        expectedStrikes[18] = 2400 * 10**18;
        expectedStrikes[19] = 2500 * 10**18;
        expectedStrikes[20] = 2600 * 10**18;
        expectedStrikes[21] = 2700 * 10**18;
        expectedStrikes[22] = 2800 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory1StrikePrice10000000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(10000000 * 10**18, uint32(block.timestamp + 14 days));
        assertEq(strikes.length, 23);
        
        uint256[] memory expectedStrikes = new uint256[](23);
        expectedStrikes[0] = 7000000 * 10**18;
        expectedStrikes[1] = 7250000 * 10**18;
        expectedStrikes[2] = 7500000 * 10**18;
        expectedStrikes[3] = 7750000 * 10**18;
        expectedStrikes[4] = 8000000 * 10**18;
        expectedStrikes[5] = 8250000 * 10**18;
        expectedStrikes[6] = 8500000 * 10**18;
        expectedStrikes[7] = 8750000 * 10**18;
        expectedStrikes[8] = 9000000 * 10**18;
        expectedStrikes[9] = 9250000 * 10**18;
        expectedStrikes[10] = 9500000 * 10**18;
        expectedStrikes[11] = 9750000 * 10**18;
        expectedStrikes[12] = 10000000 * 10**18;
        expectedStrikes[13] = 10250000 * 10**18;
        expectedStrikes[14] = 10500000 * 10**18;
        expectedStrikes[15] = 10750000 * 10**18;
        expectedStrikes[16] = 11000000 * 10**18;
        expectedStrikes[17] = 11500000 * 10**18;
        expectedStrikes[18] = 12000000 * 10**18;
        expectedStrikes[19] = 12500000 * 10**18;
        expectedStrikes[20] = 13000000 * 10**18;
        expectedStrikes[21] = 13500000 * 10**18;
        expectedStrikes[22] = 14000000 * 10**18;
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice192() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(192 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 22);
        
        uint256[] memory expectedStrikes = new uint256[](22);
        expectedStrikes[0] = 100 * 10**18;
        expectedStrikes[1] = 110 * 10**18;
        expectedStrikes[2] = 120 * 10**18;
        expectedStrikes[3] = 130 * 10**18;
        expectedStrikes[4] = 140 * 10**18;
        expectedStrikes[5] = 150 * 10**18;
        expectedStrikes[6] = 160 * 10**18;
        expectedStrikes[7] = 170 * 10**18;
        expectedStrikes[8] = 180 * 10**18;
        expectedStrikes[9] = 190 * 10**18;
        expectedStrikes[10] = 200 * 10**18;
        expectedStrikes[11] = 210 * 10**18;
        expectedStrikes[12] = 220 * 10**18;
        expectedStrikes[13] = 230 * 10**18;
        expectedStrikes[14] = 230 * 10**18;
        expectedStrikes[15] = 250 * 10**18;
        expectedStrikes[16] = 270 * 10**18;
        expectedStrikes[17] = 290 * 10**18;
        expectedStrikes[18] = 310 * 10**18;
        expectedStrikes[19] = 330 * 10**18;
        expectedStrikes[20] = 350 * 10**18;
        expectedStrikes[21] = 370 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice273_2() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2732 * 10**17, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 31);
        
        uint256[] memory expectedStrikes = new uint256[](31);
        expectedStrikes[0] = 140 * 10**18;
        expectedStrikes[1] = 150 * 10**18;
        expectedStrikes[2] = 160 * 10**18;
        expectedStrikes[3] = 170 * 10**18;
        expectedStrikes[4] = 180 * 10**18;
        expectedStrikes[5] = 190 * 10**18;
        expectedStrikes[6] = 200 * 10**18;
        expectedStrikes[7] = 210 * 10**18;
        expectedStrikes[8] = 220 * 10**18;
        expectedStrikes[9] = 230 * 10**18;
        expectedStrikes[10] = 240 * 10**18;
        expectedStrikes[11] = 250 * 10**18;
        expectedStrikes[12] = 260 * 10**18;
        expectedStrikes[13] = 270 * 10**18;
        expectedStrikes[14] = 280 * 10**18;
        expectedStrikes[15] = 290 * 10**18;
        expectedStrikes[16] = 300 * 10**18;
        expectedStrikes[17] = 310 * 10**18;
        expectedStrikes[18] = 320 * 10**18;
        expectedStrikes[19] = 330 * 10**18;
        expectedStrikes[20] = 330 * 10**18;
        expectedStrikes[21] = 350 * 10**18;
        expectedStrikes[22] = 370 * 10**18;
        expectedStrikes[23] = 390 * 10**18;
        expectedStrikes[24] = 410 * 10**18;
        expectedStrikes[25] = 430 * 10**18;
        expectedStrikes[26] = 450 * 10**18;
        expectedStrikes[27] = 470 * 10**18;
        expectedStrikes[28] = 490 * 10**18;
        expectedStrikes[29] = 510 * 10**18;
        expectedStrikes[30] = 530 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice100() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(100 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 24);
        
        uint256[] memory expectedStrikes = new uint256[](24);
        expectedStrikes[0] = 50 * 10**18;
        expectedStrikes[1] = 55 * 10**18;
        expectedStrikes[2] = 60 * 10**18;
        expectedStrikes[3] = 65 * 10**18;
        expectedStrikes[4] = 70 * 10**18;
        expectedStrikes[5] = 75 * 10**18;
        expectedStrikes[6] = 80 * 10**18;
        expectedStrikes[7] = 85 * 10**18;
        expectedStrikes[8] = 90 * 10**18;
        expectedStrikes[9] = 95 * 10**18;
        expectedStrikes[10] = 100 * 10**18;
        expectedStrikes[11] = 105 * 10**18;
        expectedStrikes[12] = 110 * 10**18;
        expectedStrikes[13] = 115 * 10**18;
        expectedStrikes[14] = 120 * 10**18;
        expectedStrikes[15] = 120 * 10**18;
        expectedStrikes[16] = 130 * 10**18;
        expectedStrikes[17] = 140 * 10**18;
        expectedStrikes[18] = 150 * 10**18;
        expectedStrikes[19] = 160 * 10**18;
        expectedStrikes[20] = 170 * 10**18;
        expectedStrikes[21] = 180 * 10**18;
        expectedStrikes[22] = 190 * 10**18;
        expectedStrikes[23] = 200 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice400() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(400 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 24);
        
        uint256[] memory expectedStrikes = new uint256[](24);
        expectedStrikes[0] = 200 * 10**18;
        expectedStrikes[1] = 220 * 10**18;
        expectedStrikes[2] = 240 * 10**18;
        expectedStrikes[3] = 260 * 10**18;
        expectedStrikes[4] = 280 * 10**18;
        expectedStrikes[5] = 300 * 10**18;
        expectedStrikes[6] = 320 * 10**18;
        expectedStrikes[7] = 340 * 10**18;
        expectedStrikes[8] = 360 * 10**18;
        expectedStrikes[9] = 380 * 10**18;
        expectedStrikes[10] = 400 * 10**18;
        expectedStrikes[11] = 420 * 10**18;
        expectedStrikes[12] = 440 * 10**18;
        expectedStrikes[13] = 460 * 10**18;
        expectedStrikes[14] = 480 * 10**18;
        expectedStrikes[15] = 480 * 10**18;
        expectedStrikes[16] = 520 * 10**18;
        expectedStrikes[17] = 560 * 10**18;
        expectedStrikes[18] = 600 * 10**18;
        expectedStrikes[19] = 640 * 10**18;
        expectedStrikes[20] = 680 * 10**18;
        expectedStrikes[21] = 720 * 10**18;
        expectedStrikes[22] = 760 * 10**18;
        expectedStrikes[23] = 800 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice754() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(754 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 18);
        
        uint256[] memory expectedStrikes = new uint256[](18);
        expectedStrikes[0] = 400 * 10**18;
        expectedStrikes[1] = 450 * 10**18;
        expectedStrikes[2] = 500 * 10**18;
        expectedStrikes[3] = 550 * 10**18;
        expectedStrikes[4] = 600 * 10**18;
        expectedStrikes[5] = 650 * 10**18;
        expectedStrikes[6] = 700 * 10**18;
        expectedStrikes[7] = 750 * 10**18;
        expectedStrikes[8] = 800 * 10**18;
        expectedStrikes[9] = 850 * 10**18;
        expectedStrikes[10] = 900 * 10**18;
        expectedStrikes[11] = 900 * 10**18;
        expectedStrikes[12] = 1000 * 10**18;
        expectedStrikes[13] = 1100 * 10**18;
        expectedStrikes[14] = 1200 * 10**18;
        expectedStrikes[15] = 1300 * 10**18;
        expectedStrikes[16] = 1400 * 10**18;
        expectedStrikes[17] = 1500 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice9950() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(9950 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 24);
        
        uint256[] memory expectedStrikes = new uint256[](24);
        expectedStrikes[0] = 5000 * 10**18;
        expectedStrikes[1] = 5500 * 10**18;
        expectedStrikes[2] = 6000 * 10**18;
        expectedStrikes[3] = 6500 * 10**18;
        expectedStrikes[4] = 7000 * 10**18;
        expectedStrikes[5] = 7500 * 10**18;
        expectedStrikes[6] = 8000 * 10**18;
        expectedStrikes[7] = 8500 * 10**18;
        expectedStrikes[8] = 9000 * 10**18;
        expectedStrikes[9] = 9500 * 10**18;
        expectedStrikes[10] = 10000 * 10**18;
        expectedStrikes[11] = 10500 * 10**18;
        expectedStrikes[12] = 11000 * 10**18;
        expectedStrikes[13] = 11500 * 10**18;
        expectedStrikes[14] = 12000 * 10**18;
        expectedStrikes[15] = 12000 * 10**18;
        expectedStrikes[16] = 13000 * 10**18;
        expectedStrikes[17] = 14000 * 10**18;
        expectedStrikes[18] = 15000 * 10**18;
        expectedStrikes[19] = 16000 * 10**18;
        expectedStrikes[20] = 17000 * 10**18;
        expectedStrikes[21] = 18000 * 10**18;
        expectedStrikes[22] = 19000 * 10**18;
        expectedStrikes[23] = 20000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice11000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(11000 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 26);
        
        uint256[] memory expectedStrikes = new uint256[](26);
        expectedStrikes[0] = 5500 * 10**18;
        expectedStrikes[1] = 6000 * 10**18;
        expectedStrikes[2] = 6500 * 10**18;
        expectedStrikes[3] = 7000 * 10**18;
        expectedStrikes[4] = 7500 * 10**18;
        expectedStrikes[5] = 8000 * 10**18;
        expectedStrikes[6] = 8500 * 10**18;
        expectedStrikes[7] = 9000 * 10**18;
        expectedStrikes[8] = 9500 * 10**18;
        expectedStrikes[9] = 10000 * 10**18;
        expectedStrikes[10] = 10500 * 10**18;
        expectedStrikes[11] = 11000 * 10**18;
        expectedStrikes[12] = 11500 * 10**18;
        expectedStrikes[13] = 12000 * 10**18;
        expectedStrikes[14] = 12500 * 10**18;
        expectedStrikes[15] = 13000 * 10**18;
        expectedStrikes[16] = 13000 * 10**18;
        expectedStrikes[17] = 14000 * 10**18;
        expectedStrikes[18] = 15000 * 10**18;
        expectedStrikes[19] = 16000 * 10**18;
        expectedStrikes[20] = 17000 * 10**18;
        expectedStrikes[21] = 18000 * 10**18;
        expectedStrikes[22] = 19000 * 10**18;
        expectedStrikes[23] = 20000 * 10**18;
        expectedStrikes[24] = 21000 * 10**18;
        expectedStrikes[25] = 22000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice2000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2000 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 24);
        
        uint256[] memory expectedStrikes = new uint256[](24);
        expectedStrikes[0] = 1000 * 10**18;
        expectedStrikes[1] = 1100 * 10**18;
        expectedStrikes[2] = 1200 * 10**18;
        expectedStrikes[3] = 1300 * 10**18;
        expectedStrikes[4] = 1400 * 10**18;
        expectedStrikes[5] = 1500 * 10**18;
        expectedStrikes[6] = 1600 * 10**18;
        expectedStrikes[7] = 1700 * 10**18;
        expectedStrikes[8] = 1800 * 10**18;
        expectedStrikes[9] = 1900 * 10**18;
        expectedStrikes[10] = 2000 * 10**18;
        expectedStrikes[11] = 2100 * 10**18;
        expectedStrikes[12] = 2200 * 10**18;
        expectedStrikes[13] = 2300 * 10**18;
        expectedStrikes[14] = 2400 * 10**18;
        expectedStrikes[15] = 2400 * 10**18;
        expectedStrikes[16] = 2600 * 10**18;
        expectedStrikes[17] = 2800 * 10**18;
        expectedStrikes[18] = 3000 * 10**18;
        expectedStrikes[19] = 3200 * 10**18;
        expectedStrikes[20] = 3400 * 10**18;
        expectedStrikes[21] = 3600 * 10**18;
        expectedStrikes[22] = 3800 * 10**18;
        expectedStrikes[23] = 4000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice10000000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(10000000 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 24);
        
        uint256[] memory expectedStrikes = new uint256[](24);
        expectedStrikes[0] = 5000000 * 10**18;
        expectedStrikes[1] = 5500000 * 10**18;
        expectedStrikes[2] = 6000000 * 10**18;
        expectedStrikes[3] = 6500000 * 10**18;
        expectedStrikes[4] = 7000000 * 10**18;
        expectedStrikes[5] = 7500000 * 10**18;
        expectedStrikes[6] = 8000000 * 10**18;
        expectedStrikes[7] = 8500000 * 10**18;
        expectedStrikes[8] = 9000000 * 10**18;
        expectedStrikes[9] = 9500000 * 10**18;
        expectedStrikes[10] = 10000000 * 10**18;
        expectedStrikes[11] = 10500000 * 10**18;
        expectedStrikes[12] = 11000000 * 10**18;
        expectedStrikes[13] = 11500000 * 10**18;
        expectedStrikes[14] = 12000000 * 10**18;
        expectedStrikes[15] = 12000000 * 10**18;
        expectedStrikes[16] = 13000000 * 10**18;
        expectedStrikes[17] = 14000000 * 10**18;
        expectedStrikes[18] = 15000000 * 10**18;
        expectedStrikes[19] = 16000000 * 10**18;
        expectedStrikes[20] = 17000000 * 10**18;
        expectedStrikes[21] = 18000000 * 10**18;
        expectedStrikes[22] = 19000000 * 10**18;
        expectedStrikes[23] = 20000000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory2StrikePrice48000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(48000 * 10**18, uint32(block.timestamp + 60 days));
        assertEq(strikes.length, 12);
        
        uint256[] memory expectedStrikes = new uint256[](12);
        expectedStrikes[0] = 25000 * 10**18;
        expectedStrikes[1] = 30000 * 10**18;
        expectedStrikes[2] = 35000 * 10**18;
        expectedStrikes[3] = 40000 * 10**18;
        expectedStrikes[4] = 45000 * 10**18;
        expectedStrikes[5] = 50000 * 10**18;
        expectedStrikes[6] = 55000 * 10**18;
        expectedStrikes[7] = 55000 * 10**18;
        expectedStrikes[8] = 65000 * 10**18;
        expectedStrikes[9] = 75000 * 10**18;
        expectedStrikes[10] = 85000 * 10**18;
        expectedStrikes[11] = 95000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice192() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(192 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 19);
        
        uint256[] memory expectedStrikes = new uint256[](19);
        expectedStrikes[0] = 60 * 10**18;
        expectedStrikes[1] = 80 * 10**18;
        expectedStrikes[2] = 100 * 10**18;
        expectedStrikes[3] = 120 * 10**18;
        expectedStrikes[4] = 140 * 10**18;
        expectedStrikes[5] = 160 * 10**18;
        expectedStrikes[6] = 180 * 10**18;
        expectedStrikes[7] = 200 * 10**18;
        expectedStrikes[8] = 220 * 10**18;
        expectedStrikes[9] = 260 * 10**18;
        expectedStrikes[10] = 300 * 10**18;
        expectedStrikes[11] = 340 * 10**18;
        expectedStrikes[12] = 380 * 10**18;
        expectedStrikes[13] = 420 * 10**18;
        expectedStrikes[14] = 460 * 10**18;
        expectedStrikes[15] = 500 * 10**18;
        expectedStrikes[16] = 540 * 10**18;
        expectedStrikes[17] = 580 * 10**18;
        expectedStrikes[18] = 620 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice273_2() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2732 * 10**17, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 28);
        
        uint256[] memory expectedStrikes = new uint256[](28);
        expectedStrikes[0] = 80 * 10**18;
        expectedStrikes[1] = 100 * 10**18;
        expectedStrikes[2] = 120 * 10**18;
        expectedStrikes[3] = 140 * 10**18;
        expectedStrikes[4] = 160 * 10**18;
        expectedStrikes[5] = 180 * 10**18;
        expectedStrikes[6] = 200 * 10**18;
        expectedStrikes[7] = 220 * 10**18;
        expectedStrikes[8] = 240 * 10**18;
        expectedStrikes[9] = 260 * 10**18;
        expectedStrikes[10] = 280 * 10**18;
        expectedStrikes[11] = 300 * 10**18;
        expectedStrikes[12] = 320 * 10**18;
        expectedStrikes[13] = 340 * 10**18;
        expectedStrikes[14] = 380 * 10**18;
        expectedStrikes[15] = 420 * 10**18;
        expectedStrikes[16] = 460 * 10**18;
        expectedStrikes[17] = 500 * 10**18;
        expectedStrikes[18] = 540 * 10**18;
        expectedStrikes[19] = 580 * 10**18;
        expectedStrikes[20] = 620 * 10**18;
        expectedStrikes[21] = 660 * 10**18;
        expectedStrikes[22] = 700 * 10**18;
        expectedStrikes[23] = 740 * 10**18;
        expectedStrikes[24] = 780 * 10**18;
        expectedStrikes[25] = 820 * 10**18;
        expectedStrikes[26] = 860 * 10**18;
        expectedStrikes[27] = 900 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice100() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(100 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 20);
        
        uint256[] memory expectedStrikes = new uint256[](20);
        expectedStrikes[0] = 30 * 10**18;
        expectedStrikes[1] = 40 * 10**18;
        expectedStrikes[2] = 50 * 10**18;
        expectedStrikes[3] = 60 * 10**18;
        expectedStrikes[4] = 70 * 10**18;
        expectedStrikes[5] = 80 * 10**18;
        expectedStrikes[6] = 90 * 10**18;
        expectedStrikes[7] = 100 * 10**18;
        expectedStrikes[8] = 110 * 10**18;
        expectedStrikes[9] = 120 * 10**18;
        expectedStrikes[10] = 140 * 10**18;
        expectedStrikes[11] = 160 * 10**18;
        expectedStrikes[12] = 180 * 10**18;
        expectedStrikes[13] = 200 * 10**18;
        expectedStrikes[14] = 220 * 10**18;
        expectedStrikes[15] = 240 * 10**18;
        expectedStrikes[16] = 260 * 10**18;
        expectedStrikes[17] = 280 * 10**18;
        expectedStrikes[18] = 300 * 10**18;
        expectedStrikes[19] = 320 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice400() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(400 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 20);
        
        uint256[] memory expectedStrikes = new uint256[](20);
        expectedStrikes[0] = 120 * 10**18;
        expectedStrikes[1] = 160 * 10**18;
        expectedStrikes[2] = 200 * 10**18;
        expectedStrikes[3] = 240 * 10**18;
        expectedStrikes[4] = 280 * 10**18;
        expectedStrikes[5] = 320 * 10**18;
        expectedStrikes[6] = 360 * 10**18;
        expectedStrikes[7] = 400 * 10**18;
        expectedStrikes[8] = 440 * 10**18;
        expectedStrikes[9] = 480 * 10**18;
        expectedStrikes[10] = 560 * 10**18;
        expectedStrikes[11] = 640 * 10**18;
        expectedStrikes[12] = 720 * 10**18;
        expectedStrikes[13] = 800 * 10**18;
        expectedStrikes[14] = 880 * 10**18;
        expectedStrikes[15] = 960 * 10**18;
        expectedStrikes[16] = 1040 * 10**18;
        expectedStrikes[17] = 1120 * 10**18;
        expectedStrikes[18] = 1200 * 10**18;
        expectedStrikes[19] = 1280 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice754() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(754 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 16);
        
        uint256[] memory expectedStrikes = new uint256[](16);
        expectedStrikes[0] = 200 * 10**18;
        expectedStrikes[1] = 300 * 10**18;
        expectedStrikes[2] = 400 * 10**18;
        expectedStrikes[3] = 500 * 10**18;
        expectedStrikes[4] = 600 * 10**18;
        expectedStrikes[5] = 700 * 10**18;
        expectedStrikes[6] = 800 * 10**18;
        expectedStrikes[7] = 900 * 10**18;
        expectedStrikes[8] = 1100 * 10**18;
        expectedStrikes[9] = 1300 * 10**18;
        expectedStrikes[10] = 1500 * 10**18;
        expectedStrikes[11] = 1700 * 10**18;
        expectedStrikes[12] = 1900 * 10**18;
        expectedStrikes[13] = 2100 * 10**18;
        expectedStrikes[14] = 2300 * 10**18;
        expectedStrikes[15] = 2500 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice9950() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(9950 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 20);
        
        uint256[] memory expectedStrikes = new uint256[](20);
        expectedStrikes[0] = 3000 * 10**18;
        expectedStrikes[1] = 4000 * 10**18;
        expectedStrikes[2] = 5000 * 10**18;
        expectedStrikes[3] = 6000 * 10**18;
        expectedStrikes[4] = 7000 * 10**18;
        expectedStrikes[5] = 8000 * 10**18;
        expectedStrikes[6] = 9000 * 10**18;
        expectedStrikes[7] = 10000 * 10**18;
        expectedStrikes[8] = 11000 * 10**18;
        expectedStrikes[9] = 12000 * 10**18;
        expectedStrikes[10] = 14000 * 10**18;
        expectedStrikes[11] = 16000 * 10**18;
        expectedStrikes[12] = 18000 * 10**18;
        expectedStrikes[13] = 20000 * 10**18;
        expectedStrikes[14] = 22000 * 10**18;
        expectedStrikes[15] = 24000 * 10**18;
        expectedStrikes[16] = 26000 * 10**18;
        expectedStrikes[17] = 28000 * 10**18;
        expectedStrikes[18] = 30000 * 10**18;
        expectedStrikes[19] = 32000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice11000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(11000 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 22);
        
        uint256[] memory expectedStrikes = new uint256[](22);
        expectedStrikes[0] = 3000 * 10**18;
        expectedStrikes[1] = 4000 * 10**18;
        expectedStrikes[2] = 5000 * 10**18;
        expectedStrikes[3] = 6000 * 10**18;
        expectedStrikes[4] = 7000 * 10**18;
        expectedStrikes[5] = 8000 * 10**18;
        expectedStrikes[6] = 9000 * 10**18;
        expectedStrikes[7] = 10000 * 10**18;
        expectedStrikes[8] = 11000 * 10**18;
        expectedStrikes[9] = 12000 * 10**18;
        expectedStrikes[10] = 13000 * 10**18;
        expectedStrikes[11] = 15000 * 10**18;
        expectedStrikes[12] = 17000 * 10**18;
        expectedStrikes[13] = 19000 * 10**18;
        expectedStrikes[14] = 21000 * 10**18;
        expectedStrikes[15] = 23000 * 10**18;
        expectedStrikes[16] = 25000 * 10**18;
        expectedStrikes[17] = 27000 * 10**18;
        expectedStrikes[18] = 29000 * 10**18;
        expectedStrikes[19] = 31000 * 10**18;
        expectedStrikes[20] = 33000 * 10**18;
        expectedStrikes[21] = 35000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice2000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2000 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 20);
        
        uint256[] memory expectedStrikes = new uint256[](20);
        expectedStrikes[0] = 600 * 10**18;
        expectedStrikes[1] = 800 * 10**18;
        expectedStrikes[2] = 1000 * 10**18;
        expectedStrikes[3] = 1200 * 10**18;
        expectedStrikes[4] = 1400 * 10**18;
        expectedStrikes[5] = 1600 * 10**18;
        expectedStrikes[6] = 1800 * 10**18;
        expectedStrikes[7] = 2000 * 10**18;
        expectedStrikes[8] = 2200 * 10**18;
        expectedStrikes[9] = 2400 * 10**18;
        expectedStrikes[10] = 2800 * 10**18;
        expectedStrikes[11] = 3200 * 10**18;
        expectedStrikes[12] = 3600 * 10**18;
        expectedStrikes[13] = 4000 * 10**18;
        expectedStrikes[14] = 4400 * 10**18;
        expectedStrikes[15] = 4800 * 10**18;
        expectedStrikes[16] = 5200 * 10**18;
        expectedStrikes[17] = 5600 * 10**18;
        expectedStrikes[18] = 6000 * 10**18;
        expectedStrikes[19] = 6400 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice10000000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(10000000 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 20);
        
        uint256[] memory expectedStrikes = new uint256[](20);
        expectedStrikes[0] = 3000000 * 10**18;
        expectedStrikes[1] = 4000000 * 10**18;
        expectedStrikes[2] = 5000000 * 10**18;
        expectedStrikes[3] = 6000000 * 10**18;
        expectedStrikes[4] = 7000000 * 10**18;
        expectedStrikes[5] = 8000000 * 10**18;
        expectedStrikes[6] = 9000000 * 10**18;
        expectedStrikes[7] = 10000000 * 10**18;
        expectedStrikes[8] = 11000000 * 10**18;
        expectedStrikes[9] = 12000000 * 10**18;
        expectedStrikes[10] = 14000000 * 10**18;
        expectedStrikes[11] = 16000000 * 10**18;
        expectedStrikes[12] = 18000000 * 10**18;
        expectedStrikes[13] = 20000000 * 10**18;
        expectedStrikes[14] = 22000000 * 10**18;
        expectedStrikes[15] = 24000000 * 10**18;
        expectedStrikes[16] = 26000000 * 10**18;
        expectedStrikes[17] = 28000000 * 10**18;
        expectedStrikes[18] = 30000000 * 10**18;
        expectedStrikes[19] = 32000000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory3StrikePrice48000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(48000 * 10**18, uint32(block.timestamp + 160 days));
        assertEq(strikes.length, 10);
        
        uint256[] memory expectedStrikes = new uint256[](10);
        expectedStrikes[0] = 20000 * 10**18;
        expectedStrikes[1] = 30000 * 10**18;
        expectedStrikes[2] = 40000 * 10**18;
        expectedStrikes[3] = 50000 * 10**18;
        expectedStrikes[4] = 60000 * 10**18;
        expectedStrikes[5] = 80000 * 10**18;
        expectedStrikes[6] = 100000 * 10**18;
        expectedStrikes[7] = 120000 * 10**18;
        expectedStrikes[8] = 140000 * 10**18;
        expectedStrikes[9] = 160000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice1000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(1000 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 200 * 10**18;
        expectedStrikes[1] = 400 * 10**18;
        expectedStrikes[2] = 600 * 10**18;
        expectedStrikes[3] = 800 * 10**18;
        expectedStrikes[4] = 1000 * 10**18;
        expectedStrikes[5] = 1200 * 10**18;
        expectedStrikes[6] = 1400 * 10**18;
        expectedStrikes[7] = 1600 * 10**18;
        expectedStrikes[8] = 1800 * 10**18;
        expectedStrikes[9] = 2000 * 10**18;
        expectedStrikes[10] = 2200 * 10**18;
        expectedStrikes[11] = 2400 * 10**18;
        expectedStrikes[12] = 2600 * 10**18;
        expectedStrikes[13] = 2800 * 10**18;
        expectedStrikes[14] = 3000 * 10**18;
        expectedStrikes[15] = 3200 * 10**18;
        expectedStrikes[16] = 3400 * 10**18;
        expectedStrikes[17] = 3600 * 10**18;
        expectedStrikes[18] = 3800 * 10**18;
        expectedStrikes[19] = 4000 * 10**18;
        expectedStrikes[20] = 4200 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice192() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(192 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 40 * 10**18;
        expectedStrikes[1] = 240 * 10**18;
        expectedStrikes[2] = 440 * 10**18;
        expectedStrikes[3] = 640 * 10**18;
        expectedStrikes[4] = 840 * 10**18;
        expectedStrikes[5] = 1040 * 10**18;
        expectedStrikes[6] = 1240 * 10**18;
        expectedStrikes[7] = 1440 * 10**18;
        expectedStrikes[8] = 1640 * 10**18;
        expectedStrikes[9] = 1840 * 10**18;
        expectedStrikes[10] = 2040 * 10**18;
        expectedStrikes[11] = 2240 * 10**18;
        expectedStrikes[12] = 2440 * 10**18;
        expectedStrikes[13] = 2640 * 10**18;
        expectedStrikes[14] = 2840 * 10**18;
        expectedStrikes[15] = 3040 * 10**18;
        expectedStrikes[16] = 3240 * 10**18;
        expectedStrikes[17] = 3440 * 10**18;
        expectedStrikes[18] = 3640 * 10**18;
        expectedStrikes[19] = 3840 * 10**18;
        expectedStrikes[20] = 4040 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice273_2() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2732 * 10**17, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 40 * 10**18;
        expectedStrikes[1] = 240 * 10**18;
        expectedStrikes[2] = 440 * 10**18;
        expectedStrikes[3] = 640 * 10**18;
        expectedStrikes[4] = 840 * 10**18;
        expectedStrikes[5] = 1040 * 10**18;
        expectedStrikes[6] = 1240 * 10**18;
        expectedStrikes[7] = 1440 * 10**18;
        expectedStrikes[8] = 1640 * 10**18;
        expectedStrikes[9] = 1840 * 10**18;
        expectedStrikes[10] = 2040 * 10**18;
        expectedStrikes[11] = 2240 * 10**18;
        expectedStrikes[12] = 2440 * 10**18;
        expectedStrikes[13] = 2640 * 10**18;
        expectedStrikes[14] = 2840 * 10**18;
        expectedStrikes[15] = 3040 * 10**18;
        expectedStrikes[16] = 3240 * 10**18;
        expectedStrikes[17] = 3440 * 10**18;
        expectedStrikes[18] = 3640 * 10**18;
        expectedStrikes[19] = 3840 * 10**18;
        expectedStrikes[20] = 4040 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice400() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(400 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 80 * 10**18;
        expectedStrikes[1] = 280 * 10**18;
        expectedStrikes[2] = 480 * 10**18;
        expectedStrikes[3] = 680 * 10**18;
        expectedStrikes[4] = 880 * 10**18;
        expectedStrikes[5] = 1080 * 10**18;
        expectedStrikes[6] = 1280 * 10**18;
        expectedStrikes[7] = 1480 * 10**18;
        expectedStrikes[8] = 1680 * 10**18;
        expectedStrikes[9] = 1880 * 10**18;
        expectedStrikes[10] = 2080 * 10**18;
        expectedStrikes[11] = 2280 * 10**18;
        expectedStrikes[12] = 2480 * 10**18;
        expectedStrikes[13] = 2680 * 10**18;
        expectedStrikes[14] = 2880 * 10**18;
        expectedStrikes[15] = 3080 * 10**18;
        expectedStrikes[16] = 3280 * 10**18;
        expectedStrikes[17] = 3480 * 10**18;
        expectedStrikes[18] = 3680 * 10**18;
        expectedStrikes[19] = 3880 * 10**18;
        expectedStrikes[20] = 4080 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice754() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(754 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 200 * 10**18;
        expectedStrikes[1] = 400 * 10**18;
        expectedStrikes[2] = 600 * 10**18;
        expectedStrikes[3] = 800 * 10**18;
        expectedStrikes[4] = 1000 * 10**18;
        expectedStrikes[5] = 1200 * 10**18;
        expectedStrikes[6] = 1400 * 10**18;
        expectedStrikes[7] = 1600 * 10**18;
        expectedStrikes[8] = 1800 * 10**18;
        expectedStrikes[9] = 2000 * 10**18;
        expectedStrikes[10] = 2200 * 10**18;
        expectedStrikes[11] = 2400 * 10**18;
        expectedStrikes[12] = 2600 * 10**18;
        expectedStrikes[13] = 2800 * 10**18;
        expectedStrikes[14] = 3000 * 10**18;
        expectedStrikes[15] = 3200 * 10**18;
        expectedStrikes[16] = 3400 * 10**18;
        expectedStrikes[17] = 3600 * 10**18;
        expectedStrikes[18] = 3800 * 10**18;
        expectedStrikes[19] = 4000 * 10**18;
        expectedStrikes[20] = 4200 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice9950() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(9950 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 2000 * 10**18;
        expectedStrikes[1] = 2200 * 10**18;
        expectedStrikes[2] = 2400 * 10**18;
        expectedStrikes[3] = 2600 * 10**18;
        expectedStrikes[4] = 2800 * 10**18;
        expectedStrikes[5] = 3000 * 10**18;
        expectedStrikes[6] = 3200 * 10**18;
        expectedStrikes[7] = 3400 * 10**18;
        expectedStrikes[8] = 3600 * 10**18;
        expectedStrikes[9] = 3800 * 10**18;
        expectedStrikes[10] = 4000 * 10**18;
        expectedStrikes[11] = 4200 * 10**18;
        expectedStrikes[12] = 4400 * 10**18;
        expectedStrikes[13] = 4600 * 10**18;
        expectedStrikes[14] = 4800 * 10**18;
        expectedStrikes[15] = 5000 * 10**18;
        expectedStrikes[16] = 5200 * 10**18;
        expectedStrikes[17] = 5400 * 10**18;
        expectedStrikes[18] = 5600 * 10**18;
        expectedStrikes[19] = 5800 * 10**18;
        expectedStrikes[20] = 6000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice11000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(11000 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 2000 * 10**18;
        expectedStrikes[1] = 2200 * 10**18;
        expectedStrikes[2] = 2400 * 10**18;
        expectedStrikes[3] = 2600 * 10**18;
        expectedStrikes[4] = 2800 * 10**18;
        expectedStrikes[5] = 3000 * 10**18;
        expectedStrikes[6] = 3200 * 10**18;
        expectedStrikes[7] = 3400 * 10**18;
        expectedStrikes[8] = 3600 * 10**18;
        expectedStrikes[9] = 3800 * 10**18;
        expectedStrikes[10] = 4000 * 10**18;
        expectedStrikes[11] = 4200 * 10**18;
        expectedStrikes[12] = 4400 * 10**18;
        expectedStrikes[13] = 4600 * 10**18;
        expectedStrikes[14] = 4800 * 10**18;
        expectedStrikes[15] = 5000 * 10**18;
        expectedStrikes[16] = 5200 * 10**18;
        expectedStrikes[17] = 5400 * 10**18;
        expectedStrikes[18] = 5600 * 10**18;
        expectedStrikes[19] = 5800 * 10**18;
        expectedStrikes[20] = 6000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice2000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(2000 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 400 * 10**18;
        expectedStrikes[1] = 600 * 10**18;
        expectedStrikes[2] = 800 * 10**18;
        expectedStrikes[3] = 1000 * 10**18;
        expectedStrikes[4] = 1200 * 10**18;
        expectedStrikes[5] = 1400 * 10**18;
        expectedStrikes[6] = 1600 * 10**18;
        expectedStrikes[7] = 1800 * 10**18;
        expectedStrikes[8] = 2000 * 10**18;
        expectedStrikes[9] = 2200 * 10**18;
        expectedStrikes[10] = 2400 * 10**18;
        expectedStrikes[11] = 2600 * 10**18;
        expectedStrikes[12] = 2800 * 10**18;
        expectedStrikes[13] = 3000 * 10**18;
        expectedStrikes[14] = 3200 * 10**18;
        expectedStrikes[15] = 3400 * 10**18;
        expectedStrikes[16] = 3600 * 10**18;
        expectedStrikes[17] = 3800 * 10**18;
        expectedStrikes[18] = 4000 * 10**18;
        expectedStrikes[19] = 4200 * 10**18;
        expectedStrikes[20] = 4400 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice10000000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(10000000 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 2000000 * 10**18;
        expectedStrikes[1] = 2000200 * 10**18;
        expectedStrikes[2] = 2000400 * 10**18;
        expectedStrikes[3] = 2000600 * 10**18;
        expectedStrikes[4] = 2000800 * 10**18;
        expectedStrikes[5] = 2001000 * 10**18;
        expectedStrikes[6] = 2001200 * 10**18;
        expectedStrikes[7] = 2001400 * 10**18;
        expectedStrikes[8] = 2001600 * 10**18;
        expectedStrikes[9] = 2001800 * 10**18;
        expectedStrikes[10] = 2002000 * 10**18;
        expectedStrikes[11] = 2002200 * 10**18;
        expectedStrikes[12] = 2002400 * 10**18;
        expectedStrikes[13] = 2002600 * 10**18;
        expectedStrikes[14] = 2002800 * 10**18;
        expectedStrikes[15] = 2003000 * 10**18;
        expectedStrikes[16] = 2003200 * 10**18;
        expectedStrikes[17] = 2003400 * 10**18;
        expectedStrikes[18] = 2003600 * 10**18;
        expectedStrikes[19] = 2003800 * 10**18;
        expectedStrikes[20] = 2004000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice48000() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(48000 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 20000 * 10**18;
        expectedStrikes[1] = 20200 * 10**18;
        expectedStrikes[2] = 20400 * 10**18;
        expectedStrikes[3] = 20600 * 10**18;
        expectedStrikes[4] = 20800 * 10**18;
        expectedStrikes[5] = 21000 * 10**18;
        expectedStrikes[6] = 21200 * 10**18;
        expectedStrikes[7] = 21400 * 10**18;
        expectedStrikes[8] = 21600 * 10**18;
        expectedStrikes[9] = 21800 * 10**18;
        expectedStrikes[10] = 22000 * 10**18;
        expectedStrikes[11] = 22200 * 10**18;
        expectedStrikes[12] = 22400 * 10**18;
        expectedStrikes[13] = 22600 * 10**18;
        expectedStrikes[14] = 22800 * 10**18;
        expectedStrikes[15] = 23000 * 10**18;
        expectedStrikes[16] = 23200 * 10**18;
        expectedStrikes[17] = 23400 * 10**18;
        expectedStrikes[18] = 23600 * 10**18;
        expectedStrikes[19] = 23800 * 10**18;
        expectedStrikes[20] = 24000 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }

    function testCategory4StrikePrice100() public view {
        uint256[] memory strikes = StrikePrices.getStrikePrices(100 * 10**18, uint32(block.timestamp + 200 days));
        assertEq(strikes.length, 21);
        uint256[] memory expectedStrikes = new uint256[](21);
        expectedStrikes[0] = 20 * 10**18;
        expectedStrikes[1] = 220 * 10**18;
        expectedStrikes[2] = 420 * 10**18;
        expectedStrikes[3] = 620 * 10**18;
        expectedStrikes[4] = 820 * 10**18;
        expectedStrikes[5] = 1020 * 10**18;
        expectedStrikes[6] = 1220 * 10**18;
        expectedStrikes[7] = 1420 * 10**18;
        expectedStrikes[8] = 1620 * 10**18;
        expectedStrikes[9] = 1820 * 10**18;
        expectedStrikes[10] = 2020 * 10**18;
        expectedStrikes[11] = 2220 * 10**18;
        expectedStrikes[12] = 2420 * 10**18;
        expectedStrikes[13] = 2620 * 10**18;
        expectedStrikes[14] = 2820 * 10**18;
        expectedStrikes[15] = 3020 * 10**18;
        expectedStrikes[16] = 3220 * 10**18;
        expectedStrikes[17] = 3420 * 10**18;
        expectedStrikes[18] = 3620 * 10**18;
        expectedStrikes[19] = 3820 * 10**18;
        expectedStrikes[20] = 4020 * 10**18;
        
        for (uint256 i = 0; i < strikes.length; i++) {
            assertEq(strikes[i], expectedStrikes[i], string(abi.encodePacked("Strike ", i, " mismatch")));
        }
    }
} 