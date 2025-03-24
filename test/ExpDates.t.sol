// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {ExpDates} from "../src/ExpDates.sol";
import {console} from "forge-std/console.sol";
contract ExpDatesTest is Test {
    using ExpDates for *;

    uint32 constant FIRST_FRIDAY_TIMESTAMP = 1743148800; // Friday, March 28, 2025, 8:00 AM UTC
    uint32 constant DAY_IN_SECONDS = 86400;
    uint32 constant SEVEN_DAYS_IN_SECONDS = 604800;

    // Expected expiration times based on rules
    uint32[] expectedTimesApril;

    function setUp() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 5 * DAY_IN_SECONDS); // April 2, 2025
        
        // Initialize expected times array
        expectedTimesApril = new uint32[](7);
        
        // Rule 1: First approaching Friday (April 4, 2025)
        expectedTimesApril[0] = FIRST_FRIDAY_TIMESTAMP + SEVEN_DAYS_IN_SECONDS;
        
        // Rule 2: Friday after that (April 11, 2025)
        expectedTimesApril[1] = FIRST_FRIDAY_TIMESTAMP + 2 * SEVEN_DAYS_IN_SECONDS;
        
        // Rule 3: Last Friday in current month (April 25, 2025)
        expectedTimesApril[2] = FIRST_FRIDAY_TIMESTAMP + 28 * DAY_IN_SECONDS;
        
        // Rule 4: Last Friday in following month (May 30, 2025)
        expectedTimesApril[3] = FIRST_FRIDAY_TIMESTAMP + 63 * DAY_IN_SECONDS;
        
        // Rule 5: Last Friday in current quarter (June 27, 2025) - included since April is first month of Q2
        expectedTimesApril[4] = FIRST_FRIDAY_TIMESTAMP + 91 * DAY_IN_SECONDS;
        
        // Rule 6: Last Friday in next quarter (September 26, 2025) - two quarters away
        expectedTimesApril[5] = FIRST_FRIDAY_TIMESTAMP + 182 * DAY_IN_SECONDS;
        
        // Rule 7: Last Friday in quarter after that (December 26, 2025) - three quarters away
        expectedTimesApril[6] = FIRST_FRIDAY_TIMESTAMP + 273 * DAY_IN_SECONDS;
    }

    function testGetExpirationTimes() public view {
        // Test getting expiration times for different dates
        uint32[] memory timestamps = ExpDates.getExpirationTimes();
        
        // Verify the number of timestamps
        assertEq(timestamps.length, 7);
        
        // Verify timestamps match expected times
        uint8 length = uint8(timestamps.length);
        for(uint8 i = 0; i < length; i++) {
            assertEq(timestamps[i], expectedTimesApril[i], "Timestamp mismatch");
        }
        
        // Verify all timestamps are Fridays at 8:00 AM UTC
        for(uint8 i = 0; i < length; i++) {
            if(timestamps[i] != 0) {
                // Verify it's a Friday (5)
                uint32 daysSinceEpoch = timestamps[i] / DAY_IN_SECONDS;
                assertEq((daysSinceEpoch + 4) % 7, 5, "Not a Friday");
            }
        }
    }

    function testIsValidExpirationTime() public view {
        // Test that all expected times are valid
        for(uint8 i = 0; i < expectedTimesApril.length; i++) {
            assertTrue(
                ExpDates.isValidExpirationTime(expectedTimesApril[i]), 
                string.concat("Expected time at index ", string(abi.encode(i)), " should be valid")
            );
        }
    }

    function testInvalidNextDayExpirationTime() public view {
        // Test that the day after a valid expiration time is invalid
        assertFalse(
            ExpDates.isValidExpirationTime(expectedTimesApril[0] + DAY_IN_SECONDS),
            "Day after valid expiration time should be invalid"
        );
    }

    function testInvalidPreviousDayExpirationTime() public view {
        // Test that the day before a valid expiration time is invalid
        assertFalse(
            ExpDates.isValidExpirationTime(expectedTimesApril[0] - DAY_IN_SECONDS),
            "Day before valid expiration time should be invalid"
        );
    }

    function testInvalidRandomExpirationTime() public view {
        // Test that a random future timestamp is invalid
        assertFalse(
            ExpDates.isValidExpirationTime(expectedTimesApril[0] + 3 * DAY_IN_SECONDS),
            "Random timestamp should be invalid"
        );
    }
} 