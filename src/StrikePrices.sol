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

        uint256 increment = _findClosestIncrement(currentPrice);

        // Calculate starting strike price (nearest to current price)
        uint256 startStrike = _round(currentPrice, increment);
        minStrike = _round(minStrike, increment);
        maxStrike = _round(maxStrike, increment);

        // For Category 0, use special strike price generation
        if (category == 0) {
            return _generateCategory0StrikePrices(startStrike, minStrike, maxStrike, increment);
        }
        // For Category 1, use two-tier strike price generation - increment and increment * 2
        if (category == 1) {
            return _generateCategory1StrikePrices(startStrike, minStrike, maxStrike, increment);
        }
        // For Category 2, use teo-tier strike price generation - increment * 2 and increment * 4
        if (category == 2) {
            return _generateCategory2StrikePrices(startStrike, minStrike, maxStrike, increment);
        }
        // For Category 3, use two-tier strike price generation - increment * 4 and increment * 8
        if (category == 3) {
            return _generateCategory3StrikePrices(startStrike, minStrike, maxStrike, increment);
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

    function _findClosestIncrement(uint256 currentPrice) 
        internal 
        pure 
        returns (uint256 baseIncrement) 
    {
        uint256[] memory standardIncrements = new uint256[](3);
        standardIncrements[0] = 25;
        standardIncrements[1] = 50;
        standardIncrements[2] = 100;

        (uint256 minStrike, uint256 maxStrike) = _calculateStrikeRange(currentPrice, 0);
        // Calculate target as (maxStrikePrice - minStrikePrice) / 15
        uint256 target = (maxStrike - minStrike) / 15;

        while (target > standardIncrements[2]) {
            standardIncrements[0] *= 10;
            standardIncrements[1] *= 10;
            standardIncrements[2] *= 10;
        }


        uint256 minDiff = target;
        uint256 length = standardIncrements.length;
        if (target < standardIncrements[0]) {
            baseIncrement = standardIncrements[0];
        } else {            
            for (uint256 i = 0; i < length; i++) {
                uint256 scaledIncrement = standardIncrements[i];
                uint256 diff = scaledIncrement > target 
                    ? scaledIncrement - target 
                    : target - scaledIncrement;
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

    function _generateCategory1StrikePrices(
        uint256 startStrike,
        uint256 minStrike,
        uint256 maxStrike,
        uint256 baseIncrement
    ) internal pure returns (uint256[] memory) {
        // Calculate fine-grained upper boundary (110% of ATM)
        uint256 fineGrainedUpperBound = _round(startStrike * 110 / 100, baseIncrement);
        
        // If fine-grained upper bound exceeds maxStrike, adjust it
        if (fineGrainedUpperBound > maxStrike) {
            fineGrainedUpperBound = maxStrike;
        }
        
        // Calculate coarse-grained increment (2x base increment)
        uint256 coarseIncrement = baseIncrement * 2;
        
        // Calculate number of strikes in each range
        uint256 fineGrainedStrikes = (fineGrainedUpperBound - minStrike) / baseIncrement + 1;
        uint256 coarseGrainedStrikes = 0;
        
        // Calculate coarse-grained strikes starting from fineGrainedUpperBound + coarseIncrement
        if (fineGrainedUpperBound < maxStrike) {
            uint256 firstCoarseStrike = fineGrainedUpperBound + coarseIncrement;
            coarseGrainedStrikes = ((maxStrike - firstCoarseStrike) / coarseIncrement) + 1;
        }
        
        uint256 totalStrikes = fineGrainedStrikes + coarseGrainedStrikes;
        uint256[] memory strikePrices = new uint256[](totalStrikes);
        uint256 currentIndex = 0;
        
        // Generate fine-grained strikes (base increment)
        for (uint256 i = 0; i < fineGrainedStrikes; i++) {
            strikePrices[currentIndex++] = minStrike + i * baseIncrement;
        }
        
        // Generate coarse-grained strikes (2x increment), starting from fineGrainedUpperBound + coarseIncrement
        if (coarseGrainedStrikes > 0) {
            uint256 firstCoarseStrike = fineGrainedUpperBound + coarseIncrement;
            for (uint256 i = 0; i < coarseGrainedStrikes; i++) {
                strikePrices[currentIndex++] = firstCoarseStrike + i * coarseIncrement;
            }
        }
        
        return strikePrices;
    }

    function _generateCategory2StrikePrices(
        uint256 startStrike,
        uint256 minStrike,
        uint256 maxStrike,
        uint256 baseIncrement
    ) internal pure returns (uint256[] memory) {
        // Round minStrike using baseIncrement * 2
        minStrike = _round(minStrike, baseIncrement * 2);
        
        // Calculate boundaries
        uint256 fineUpperBound = _round(startStrike * 120 / 100, baseIncrement * 2); // 120% of startStrike
        
        // Ensure boundaries don't exceed maxStrike
        if (fineUpperBound > maxStrike) fineUpperBound = maxStrike;
        
        // Calculate number of strikes in each range
        uint256 fineStrikes = (fineUpperBound - minStrike) / (baseIncrement * 2) + 1; // 2x increment
        uint256 coarseStrikes = (maxStrike - fineUpperBound) / (baseIncrement * 4) + 1; // 4x increment
        
        // Initialize strike prices array
        uint256[] memory strikes = new uint256[](fineStrikes + coarseStrikes);
        
        // Generate fine-grained strikes (2x increment)
        for (uint256 i = 0; i < fineStrikes; i++) {
            strikes[i] = minStrike + (i * baseIncrement * 2);
        }
        
        // Generate coarse-grained strikes (4x increment)
        for (uint256 i = 0; i < coarseStrikes; i++) {
            strikes[fineStrikes + i] = fineUpperBound + (i * baseIncrement * 4);
        }
        
        return strikes;
    }

    function _generateCategory3StrikePrices(
        uint256 startStrike,
        uint256 minStrike,
        uint256 maxStrike,
        uint256 baseIncrement
    ) internal pure returns (uint256[] memory) {
        // Round minStrike using baseIncrement * 4
        minStrike = _round(minStrike, baseIncrement * 4);
        
        // Calculate boundaries
        uint256 fineUpperBound = _round(startStrike * 120 / 100, baseIncrement * 4); // 120% of startStrike
        
        // Ensure boundaries don't exceed maxStrike
        if (fineUpperBound > maxStrike) fineUpperBound = maxStrike;
        
        // Calculate number of strikes in each range
        uint256 fineStrikes = (fineUpperBound - minStrike) / (baseIncrement * 4) + 1; // 4x increment
        uint256 coarseStrikes = 0;
        
        // Only calculate coarse strikes if fineUpperBound is less than maxStrike
        if (fineUpperBound < maxStrike) {
            uint256 firstCoarseStrike = fineUpperBound + baseIncrement * 8;
            if (firstCoarseStrike <= maxStrike) {
                coarseStrikes = ((maxStrike - firstCoarseStrike) / (baseIncrement * 8)) + 1;
            }
        }
        
        // Initialize strike prices array
        uint256[] memory strikes = new uint256[](fineStrikes + coarseStrikes);
        
        // Generate fine-grained strikes (4x increment)
        for (uint256 i = 0; i < fineStrikes; i++) {
            strikes[i] = minStrike + (i * baseIncrement * 4);
        }
        
        // Generate coarse-grained strikes (8x increment)
        if (coarseStrikes > 0) {
            uint256 firstCoarseStrike = fineUpperBound + baseIncrement * 8;
            for (uint256 i = 0; i < coarseStrikes; i++) {
                strikes[fineStrikes + i] = firstCoarseStrike + (i * baseIncrement * 8);
            }
        }
        
        return strikes;
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
