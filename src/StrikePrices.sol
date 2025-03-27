// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import "forge-std/console2.sol";

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

        // Get lower and upper bounds of strike price
        (uint256 minStrike, uint256 maxStrike) = _calculateStrikeRange(currentPrice, category);

        // Calculate target as (maxStrikePrice - minStrikePrice) / 15
        uint256 target = (maxStrike - minStrike) / 15;
        uint256 increment = _findClosestIncrement(target);

        // Calculate starting strike price (nearest to current price)
        uint256 startStrike = _round(currentPrice, increment);
        minStrike = _round(minStrike, increment);
        maxStrike = _round(maxStrike, increment);

        // For Category 0, use special strike price generation
        if (category == 0) {
            return _generateCategory0StrikePrices(startStrike, minStrike, maxStrike, increment);
        }

        // For other categories, use standard generation
        return _generateStrikePrices(startStrike, increment, minStrike, maxStrike);
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
        uint256[] memory standardIncrements = new uint256[](3);
        standardIncrements[0] = 25;
        standardIncrements[1] = 50;
        standardIncrements[2] = 100;

        // Calculate initial target interval
        uint256 targetInterval = target;
        while (targetInterval > standardIncrements[2]) {
            standardIncrements[0] *= 10;
            standardIncrements[1] *= 10;
            standardIncrements[2] *= 10;
        }

        uint256 minDiff = targetInterval;
        uint256 length = standardIncrements.length;
        if (targetInterval < standardIncrements[0]) {
            baseIncrement = standardIncrements[0];
        } else {            
            for (uint256 i = 0; i < length; i++) {
                uint256 scaledIncrement = standardIncrements[i];
                uint256 diff = scaledIncrement > targetInterval 
                    ? scaledIncrement - targetInterval 
                    : targetInterval - scaledIncrement;
                if (diff < minDiff) {
                    minDiff = diff;
                    baseIncrement = scaledIncrement;
                }
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
        // Calculate number of strikes below and above startStrike
        uint256 strikesBelow = (startStrike - minStrike) / increment;
        uint256 strikesAbove = (maxStrike - startStrike) / increment;
        uint256 totalStrikes = strikesBelow + strikesAbove + 1;

        uint256[] memory strikePrices = new uint256[](totalStrikes);
        
        // Generate strikes below startStrike
        for (uint256 i = 0; i <= strikesBelow; i++) {
            strikePrices[i] = startStrike - (strikesBelow - i) * increment;
        }
        
        // Generate strikes above startStrike
        for (uint256 i = 0; i < strikesAbove; i++) {
            strikePrices[strikesBelow + 1 + i] = startStrike + (i + 1) * increment;
        }

        return strikePrices;
    }

    function _generateCategory0StrikePrices(
        uint256 atmStrike,
        uint256 minStrike,
        uint256 maxStrike,
        uint256 baseIncrement
    ) internal pure returns (uint256[] memory) {
        // Calculate granular range boundaries (±5% from ATM)
        uint256 lowerGranularBoundary = _round(atmStrike * 95 / 100, baseIncrement);
        uint256 upperGranularBoundary = _round(atmStrike * 105 / 100, baseIncrement);

        // Calculate number of strikes in each range
        uint256 strikesLower = (lowerGranularBoundary - minStrike) / baseIncrement;
        uint256 strikesMiddle = (upperGranularBoundary - lowerGranularBoundary) / (baseIncrement / 2);
        uint256 strikesUpper = (maxStrike - upperGranularBoundary) / baseIncrement;
        uint256 totalStrikes = strikesLower + strikesMiddle + strikesUpper + 1;

        uint256[] memory strikePrices = new uint256[](totalStrikes);
        uint256 currentIndex = 0;

        // Generate strikes in lower range (standard increment)
        for (uint256 i = 0; i < strikesLower; i++) {
            strikePrices[currentIndex++] = minStrike + (i + 1) * baseIncrement;
        }

        // Generate strikes in middle range (half increment)
        for (uint256 i = 0; i <= strikesMiddle; i++) {
            strikePrices[currentIndex++] = lowerGranularBoundary + i * (baseIncrement / 2);
        }

        // Generate strikes in upper range (standard increment)
        for (uint256 i = 0; i < strikesUpper; i++) {
            strikePrices[currentIndex++] = upperGranularBoundary + (i + 1) * baseIncrement;
        }

        return strikePrices;
    }

    function _round(uint256 number, uint256 interval) private pure returns(uint256) {
        uint256 mod = number % interval;
        if (mod >= (interval / 2)) {
            return ((number / interval) + 1) * interval;
        } else {
            return (number / interval) * interval;
        }
    }
}
