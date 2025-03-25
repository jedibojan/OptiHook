// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import "forge-std/console.sol";

/**
 * @title StrikePrices
 *
 * @dev Utility library for managing available strike prices.
 */
// TODO: in production we can define different strike price rules for different pairs
library StrikePrices {
    uint32 private constant DAY_IN_SECONDS = 86400;
    // time intervals
    uint32 private constant zeroTimeInterval = DAY_IN_SECONDS * 3;
    uint32 private constant firstTimeInterval = DAY_IN_SECONDS * 21;
    uint32 private constant secondTimeInterval = DAY_IN_SECONDS * 90;
    uint32 private constant thirdTimeInterval = DAY_IN_SECONDS * 180;

    error InvalidExpirationTime();
    error InvalidCurrentPrice();

    function getStrikePrices(uint256 currentPrice, uint32 expirationTime) 
        public 
        view 
        returns (uint256[] memory) 
    {
        uint32 currentTimestamp = uint32(block.timestamp);
        // Input validation
        if (currentPrice == 0) revert InvalidCurrentPrice();
        if (expirationTime <= currentTimestamp) revert InvalidExpirationTime();

        // Calculate days to expiration
        uint32 timeToExpiration = expirationTime - currentTimestamp;
        uint8 category = _determineTimeCategory(timeToExpiration);

        // Get standard increments and find closest to target
        uint256 target = currentPrice / 50;
        uint256 baseIncrement = _findClosestIncrement(target);
        console.log("baseIncrement", baseIncrement);

        // // Apply category multiplier
        // uint256 increment = baseIncrement * _getCategoryMultiplier(category);

        // // Calculate strike range
        // (uint256 minStrike, uint256 maxStrike) = _calculateStrikeRange(currentPrice, category);

        // // Calculate starting strike
        // uint256 startStrike = (currentPrice / increment) * increment;

        // // Generate final strike prices
        // return _generateStrikePrices(startStrike, increment, minStrike, maxStrike);
    }

    function _determineTimeCategory(uint32 timeToExpiration) internal pure returns (uint8) {
        if (timeToExpiration <= zeroTimeInterval) {
            return 0; // 0-3 days
        } else if (timeToExpiration <= firstTimeInterval) {
            return 1; // 4-21 days
        } else if (timeToExpiration <= secondTimeInterval) {
            return 2; // 22-90 days
        } else if (timeToExpiration <= thirdTimeInterval) {
            return 3; // 91-180 days
        } else {
            return 4; // 181+ days
        }
    }

    function _findClosestIncrement(uint256 target) 
        internal 
        pure 
        returns (uint256 baseIncrement) 
    {
        uint256[] memory standardIncrements = new uint256[](4);
        standardIncrements[0] = 25;
        standardIncrements[1] = 50;
        standardIncrements[2] = 100;
        standardIncrements[3] = 200;
        
        uint16 pwr = 1;
        console.log("target", target);
        console.log("target % 1000", target % 1000);
        while (target % 1000 == 0) {
            pwr++;
            console.log("pwr", pwr);
            target /= 10;
        }
        // console.log("pwr", pwr);
        console.log("target after", target);
        uint256 minDiff = type(uint256).max;
        for (uint256 i = 0; i < standardIncrements.length; i++) {
            uint256 scaledIncrement = standardIncrements[i] * 10**pwr;
            uint256 diff = scaledIncrement > target 
                ? scaledIncrement - target 
                : target - scaledIncrement;
            if (diff < minDiff) {
                minDiff = diff;
                baseIncrement = scaledIncrement;
            }
        }
    }

    function _getCategoryMultiplier(uint8 category) internal pure returns (uint256) {
        if (category == 0) {
            return 1;
        } else if (category == 1 || category == 2) {
            return 4;
        } else {
            return 8;
        }
    }

    function _calculateStrikeRange(uint256 currentPrice, uint8 category) internal pure returns (uint256 minStrike, uint256 maxStrike) {
        // Define min and max factors (scaled by 10^16, to be applied to currentPrice / 10^18)
        uint8[5] memory rangeFactors = [
            85, // 0.85
            70, // 0.70
            50, // 0.50
            30, // 0.30
            20  // 0.20
        ];

        minStrike = currentPrice * rangeFactors[category] / 100;
        maxStrike = currentPrice * 100 / rangeFactors[category];
    }

    function _generateStrikePrices(
        uint256 startStrike,
        uint256 increment,
        uint256 minStrike,
        uint256 maxStrike
    ) internal pure returns (uint256[] memory) {
        uint256 mMax = (startStrike - minStrike) / increment;
        uint256 nMax = (maxStrike - startStrike) / increment;
        uint256 totalStrikes = mMax + nMax + 1;

        uint256[] memory strikePrices = new uint256[](totalStrikes);
        
        // Generate strikes below startStrike
        for (uint256 i = 0; i <= mMax; i++) {
            strikePrices[i] = startStrike - (mMax - i) * increment;
        }
        
        // Generate strikes above startStrike
        for (uint256 i = 0; i < nMax; i++) {
            strikePrices[mMax + 1 + i] = startStrike + (i + 1) * increment;
        }

        return strikePrices;
    }
}
