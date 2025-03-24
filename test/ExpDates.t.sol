// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {ExpDates} from "../src/ExpDates.sol";

contract ExpDatesTest is Test {
    using ExpDates for *;

    uint32 constant FIRST_FRIDAY_TIMESTAMP = 1743148800; // Friday, March 28, 2025, 8:00 AM UTC
    uint32 constant DAY_IN_SECONDS = 86400;
    uint32 constant SEVEN_DAYS_IN_SECONDS = 604800;

    // Expected expiration times based on rules
    uint32[] expectedTimesApril;
    uint32[] expectedTimesNovember;
    uint32[] expectedTimesMay;  // New array for May scenario

    function setUp() public {
        setupAprilTimes();
        setupNovemberTimes();
        setupMayTimes();  // Add May setup
    }

    function setupAprilTimes() internal {
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

    function setupNovemberTimes() internal {
        // Initialize expected times array
        expectedTimesNovember = new uint32[](7); // Changed to 7 to include all three quarter rules
        
        // Rule 1: First approaching Friday (November 14, 2025)
        expectedTimesNovember[0] = FIRST_FRIDAY_TIMESTAMP + 231 * DAY_IN_SECONDS;
        
        // Rule 2: Friday after that (November 21, 2025)
        expectedTimesNovember[1] = FIRST_FRIDAY_TIMESTAMP + 238 * DAY_IN_SECONDS;
        
        // Rule 3: Last Friday in current month (November 28, 2025)
        expectedTimesNovember[2] = FIRST_FRIDAY_TIMESTAMP + 245 * DAY_IN_SECONDS;
        
        // Rule 4: Last Friday in following month (December 26, 2025)
        expectedTimesNovember[3] = FIRST_FRIDAY_TIMESTAMP + 273 * DAY_IN_SECONDS;
        
        // Rule 5: Last Friday in next quarter (March 27, 2026) - Q1 2026 - two quarters away
        expectedTimesNovember[4] = FIRST_FRIDAY_TIMESTAMP + 364 * DAY_IN_SECONDS;
        
        // Rule 6: Last Friday in quarter after that (June 26, 2026) - Q2 2026 - three quarters away
        expectedTimesNovember[5] = FIRST_FRIDAY_TIMESTAMP + 455 * DAY_IN_SECONDS;
        
        // Since November is not the first month of Q4, we don't have a rule for the last Friday in quarter after that, and the function must return a fixed array length of 7, the last element is 0
        expectedTimesNovember[6] = 0;
    }

    function setupMayTimes() internal {
        // Initialize expected times array for May 30, 2025 (Friday)
        // Since current day is Friday, we exclude it as the first approaching Friday because it is forbidden to create market on expiration date
        expectedTimesMay = new uint32[](7);
        
        // Rule 1: First approaching Friday (June 6, 2025)
        expectedTimesMay[0] = FIRST_FRIDAY_TIMESTAMP + 70 * DAY_IN_SECONDS;
        
        // Rule 2: Friday after that (June 13, 2025)
        expectedTimesMay[1] = FIRST_FRIDAY_TIMESTAMP + 77 * DAY_IN_SECONDS;
        
        // Rule 3: Last Friday in current month (May 30, 2025) - excluded since it is the current day
        
        // Rule 4: Last Friday in following month (July 25, 2025)
        expectedTimesMay[2] = FIRST_FRIDAY_TIMESTAMP + 91 * DAY_IN_SECONDS;
        
        // Rule 5: Last Friday in current quarter (June 27, 2025) - excluded since we already have it
        
        // Rule 6: Last Friday in next quarter (September 26, 2025) - two quarters away
        expectedTimesMay[3] = FIRST_FRIDAY_TIMESTAMP + 182 * DAY_IN_SECONDS;
        
        // Rule 7: Last Friday in quarter after that (December 26, 2025) - three quarters away
        expectedTimesMay[4] = FIRST_FRIDAY_TIMESTAMP + 273 * DAY_IN_SECONDS;

        expectedTimesMay[5] = 0;
        expectedTimesMay[6] = 0;
    }

    function testGetExpirationTimesApril() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 5 * DAY_IN_SECONDS); // April 2, 2025
        uint32[] memory timestamps = ExpDates.getExpirationTimes();
        
        // Verify the number of timestamps
        assertEq(timestamps.length, 7);
        
        // Verify timestamps match expected times
        uint8 length = uint8(timestamps.length);
        for(uint8 i = 0; i < length; i++) {
            assertEq(timestamps[i], expectedTimesApril[i], "Timestamp mismatch in April");
        }
        
        // Verify all timestamps are Fridays at 8:00 AM UTC
        for(uint8 i = 0; i < length; i++) {
            if(timestamps[i] != 0) {
                // Verify it's a Friday (5)
                uint32 daysSinceEpoch = timestamps[i] / DAY_IN_SECONDS;
                assertEq((daysSinceEpoch + 4) % 7, 5, "Not a Friday in April");
            }
        }
    }

    function testGetExpirationTimesNovember() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 230 * DAY_IN_SECONDS); // November 13, 2025
        uint32[] memory timestamps = ExpDates.getExpirationTimes();
        
        // Verify the number of timestamps
        assertEq(timestamps.length, 7);
        
        // Verify timestamps match expected times
        uint8 length = uint8(timestamps.length);
        for(uint8 i = 0; i < length; i++) {
            assertEq(timestamps[i], expectedTimesNovember[i], "Timestamp mismatch in November");
        }
        
        // Verify all timestamps are Fridays at 8:00 AM UTC
        for(uint8 i = 0; i < length; i++) {
            if(timestamps[i] != 0) {
                // Verify it's a Friday (5)
                uint32 daysSinceEpoch = timestamps[i] / DAY_IN_SECONDS;
                assertEq((daysSinceEpoch + 4) % 7, 5, "Not a Friday in November");
            }
        }
    }

    function testGetExpirationTimesMay() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 63 * DAY_IN_SECONDS); // May 30, 2025
        uint32[] memory timestamps = ExpDates.getExpirationTimes();
        
        // Verify the number of timestamps
        assertEq(timestamps.length, 7);
        
        // Verify timestamps match expected times
        uint8 length = uint8(timestamps.length);
        for(uint8 i = 0; i < length; i++) {
            assertEq(timestamps[i], expectedTimesMay[i], "Timestamp mismatch in May");
        }
        
        // Verify all timestamps are Fridays at 8:00 AM UTC
        for(uint8 i = 0; i < length; i++) {
            if(timestamps[i] != 0) {
                // Verify it's a Friday (5)
                uint32 daysSinceEpoch = timestamps[i] / DAY_IN_SECONDS;
                assertEq((daysSinceEpoch + 4) % 7, 5, "Not a Friday in May");
            }
        }
    }

    function testIsValidExpirationTime() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 5 * DAY_IN_SECONDS); // April 2, 2025
        // Test that all expected times are valid
        for(uint8 i = 0; i < expectedTimesApril.length; i++) {
            assertTrue(
                ExpDates.isValidExpirationTime(expectedTimesApril[i]), 
                string.concat("Expected time at index ", string(abi.encode(i)), " should be valid")
            );
        }
    }

    function testIsValidExpirationTimeNovember() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 230 * DAY_IN_SECONDS); // November 13, 2025
        // Test that all expected times are valid
        for(uint8 i = 0; i < expectedTimesNovember.length; i++) {
            if(expectedTimesNovember[i] != 0) { // Skip the last element which is 0
                assertTrue(
                    ExpDates.isValidExpirationTime(expectedTimesNovember[i]), 
                    string.concat("Expected time at index ", string(abi.encode(i)), " should be valid")
                );
            }
        }
    }

    function testInvalidNextDayExpirationTime() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 5 * DAY_IN_SECONDS); // April 2, 2025
        // Test that the day after a valid expiration time is invalid
        assertFalse(
            ExpDates.isValidExpirationTime(expectedTimesApril[0] + DAY_IN_SECONDS),
            "Day after valid expiration time should be invalid"
        );
    }

    function testInvalidPreviousDayExpirationTime() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 5 * DAY_IN_SECONDS); // April 2, 2025
        // Test that the day before a valid expiration time is invalid
        assertFalse(
            ExpDates.isValidExpirationTime(expectedTimesApril[0] - DAY_IN_SECONDS),
            "Day before valid expiration time should be invalid"
        );
    }

    function testInvalidRandomExpirationTime() public {
        vm.warp(FIRST_FRIDAY_TIMESTAMP + 5 * DAY_IN_SECONDS); // April 2, 2025
        // Test that a random future timestamp is invalid
        assertFalse(
            ExpDates.isValidExpirationTime(expectedTimesApril[0] + 3 * DAY_IN_SECONDS),
            "Random timestamp should be invalid"
        );
    }
} 