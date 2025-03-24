// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

/**
 * @title ExpirationDates
 *
 * @dev Utility library for managing expiration dates.
 */
// TODO: we can add dailies if needed
library ExpDates {

    struct DateTime {
        uint16 year;
        uint8 month;
        uint8 day;
        uint8 hour;
        uint8 minute;
        uint8 second;
    }

    uint16 private constant ORIGIN_YEAR = 1970;
    uint32 private constant DAY_IN_SECONDS = 86400;
    uint32 private constant SEVEN_DAYS_IN_SECONDS = 604800;
    uint32 private constant YEAR_IN_SECONDS = 31536000;
    uint32 private constant LEAP_YEAR_IN_SECONDS = 31622400;
    uint32 private constant HOUR_IN_SECONDS = 3600;
    uint32 private constant MINUTE_IN_SECONDS = 60;

    uint32 private constant FIRST_FRIDAY_TIMESTAMP = 1743148800; // Friday, 28MAR2025, 8:00 AM UTC

    /**
     * @dev Gets an array of timestamps representing expiry dates at the time of call.
     * Expiry date is always Friday, 8:00 AM UTC. The rules are following: always returns
     * first Friday and Friday after that, last Friday in current month, last Friday in
     * following month, last Friday in current quarter, next quarter and quarter after that.
     * @return Array of timestamps representing expiry dates.
     */
    function getExpirationTimes() external view returns (uint32[] memory) {
        return _getExpirationTimes();
    }

    /**
     * @dev Checks if expiration time is valid at the time of call.
     * @param expirationTime Timestamp to be checked.
     * @return True if expiration time is valid, otherwise false.
     */
    function isValidExpirationTime(uint32 expirationTime) external view returns (bool) {
        uint32[] memory validExpirationTimes = _getExpirationTimes();
        for(uint8 i = 0; i < validExpirationTimes.length; i++) {
            if(expirationTime == validExpirationTimes[i]) {
                return true;
            }
        }

        return false;
    }

    /**
     * @dev Gets an array of timestamps representing expiry dates at the time of call.
     * Expiry date is always Friday, 8:00 AM UTC. The rules are following: always returns
     * first Friday and Friday after that, last Friday in current month, last Friday in
     * following month, last Friday in current quarter, next quarter and quarter after that.
     * @return Array of timestamps representing expiry dates.
     */
    function _getExpirationTimes() private view returns (uint32[] memory) {
        uint32[] memory timestamps = new uint32[](7);
        DateTime memory nowDateTime = _parseTimestamp(uint32(block.timestamp));
        uint8 index;

        uint32 firstFriday = _getFirstFriday(uint32(block.timestamp));

        // add first Friday from now if 1) nothing is added - no dailies 2) if Friday is not already added
        if (index == 0 || timestamps[index - 1] < firstFriday) {
            timestamps[index++] = firstFriday;
        }

        // always add second friday from now, even if it's next month
        uint32 secondFriday = _getNextFriday(firstFriday);
        timestamps[index++] = secondFriday;
        uint32 firstFridayNextQuarter = secondFriday;

        // last friday this month, if not alredy added
        uint32 firstFridayNextMonth = firstFriday;
        DateTime memory firstFridayDateTime = _parseTimestamp(firstFriday);
        if (firstFridayDateTime.month == nowDateTime.month) {
            uint32 lastFridayThisMonth;
            (lastFridayThisMonth, firstFridayNextMonth) = _getLastFridayInMonth(nowDateTime.month, firstFriday);
            if (lastFridayThisMonth != firstFriday && lastFridayThisMonth != secondFriday) {
                timestamps[index++] = lastFridayThisMonth;
                firstFridayNextQuarter = firstFridayNextMonth;
            }
        }

        // last friday next month
        DateTime memory firstFridayNextMonthDateTime = _parseTimestamp(firstFridayNextMonth);
        (uint32 lastFridayNextMonth, uint32 firstFriday2MonthsAway) = _getLastFridayInMonth(firstFridayNextMonthDateTime.month, firstFridayNextMonth);
        timestamps[index++] = lastFridayNextMonth;

        DateTime memory firstFriday2MonthsAwayDateTime = _parseTimestamp(firstFriday2MonthsAway);
        if (_getQuarter(firstFridayNextMonthDateTime.month) != _getQuarter(firstFriday2MonthsAwayDateTime.month)) {
            firstFridayNextQuarter = firstFriday2MonthsAway;
        }

        // last Friday of this quarter (if todays month is first month in quarter)
        if (nowDateTime.month % 3 == 1) {
            (uint32 lastFriday2MonthsAway, uint32 firstFriday3MonthsAway) = _getLastFridayInMonth(firstFriday2MonthsAwayDateTime.month, firstFriday2MonthsAway);
            timestamps[index++] = lastFriday2MonthsAway;

            uint8 firstFriday3MonthsAwayMonth = firstFriday2MonthsAwayDateTime.month + 1;
            if(firstFriday3MonthsAwayMonth > 12) {
                firstFriday3MonthsAwayMonth = 1;
            }

            if(_getQuarter(firstFriday2MonthsAwayDateTime.month) != _getQuarter(firstFriday3MonthsAwayMonth)) {
                firstFridayNextQuarter = firstFriday3MonthsAway;
            }
        }

        // last Friday of next quarter
        uint32 lastFridayNextQuarter = _getLastFridayInQuarter(firstFridayNextQuarter);
        timestamps[index++] = lastFridayNextQuarter;

        // last Friday of 2 quarters away
        uint32 lastFriday2QuartersAway = _getLastFridayInQuarter(lastFridayNextQuarter + SEVEN_DAYS_IN_SECONDS);
        timestamps[index++] = lastFriday2QuartersAway;

        return timestamps;
    }

    /**
     * @dev Gets the first upcoming Friday timestamp after specified timestamp.
     * @param timestamp Timestamp after which first Friday is found.
     * @return Timestamp of first Friday after specified timestamp.
     */
    function _getFirstFriday(uint32 timestamp) private pure returns (uint32) {

        uint32 weeksPassed = (timestamp - FIRST_FRIDAY_TIMESTAMP) / (SEVEN_DAYS_IN_SECONDS);
        uint32 nextFriday = FIRST_FRIDAY_TIMESTAMP + (weeksPassed + 1) * SEVEN_DAYS_IN_SECONDS;
        return nextFriday;
    }

    /**
     * @dev Gets the first day timestamp before or equal specified Friday.
     * @param firstFriday Timestamp of first Friday.
     * @param timestampNow Timestamp of now.
     * @return Timestamp of first day before or equal to Friday.
     */
    function _getNextDay(uint32 firstFriday, uint32 timestampNow) private pure returns (uint32) {
        // get round days until Friday
        uint32 daysUntilFriday = (firstFriday - timestampNow) / DAY_IN_SECONDS;
        if (daysUntilFriday == 0) {
            return firstFriday;
        }

        return firstFriday - daysUntilFriday * DAY_IN_SECONDS;
    }

    /**
     * @dev Gets the next Friday timestamp after specified Friday.
     * @param friday Timestamp of Friday.
     * @return Timestamp of next Friday after specified Friday.
     */
    function _getNextFriday(uint32 friday) private pure returns (uint32) {
        return friday + SEVEN_DAYS_IN_SECONDS;
    }

    /**
     * @dev Gets the last Friday timestamp in specified month.
     * @param month A month where Friday is searched.
     * @param firstFridayTimestamp Timestamp of first Friday in specified month.
     * @return Timestamp of last Friday in specified month, and timestamp of first Friday in the following month.
     */
    function _getLastFridayInMonth(uint8 month, uint32 firstFridayTimestamp) private pure returns (uint32, uint32) {
        uint32 nextFriday = _getNextFriday(firstFridayTimestamp);
        uint32 lastFriday = firstFridayTimestamp;
        DateTime memory nextFridayDateTime = _parseTimestamp(nextFriday);
        while (nextFridayDateTime.month == month) {
            lastFriday = nextFriday;
            nextFriday = _getNextFriday(nextFriday);
            nextFridayDateTime = _parseTimestamp(nextFriday);
        }

        return (lastFriday, nextFriday);
    }

    /**
     * @dev Gets the last Friday timestamp in specified quarter.
     * @param firstFridayTimestamp Timestamp of first Friday in specified month
     * @return Timestamp of last Friday in specified quarter, and timestamp of first Friday in the following quarter.
     */
    function _getLastFridayInQuarter(uint32 firstFridayTimestamp) private pure returns (uint32) {
        // advance 10 weeks, land on some friday in last month
        uint32 firstFridayLastMonthInQuarter = firstFridayTimestamp + 70 * DAY_IN_SECONDS;
        DateTime memory firstFridayLastMonthInQuarterDateTime = _parseTimestamp(firstFridayLastMonthInQuarter);
        (uint32 lastFridayThisQuarter,) = _getLastFridayInMonth(firstFridayLastMonthInQuarterDateTime.month, firstFridayLastMonthInQuarter);

        return lastFridayThisQuarter;
    }

    /**
     * @dev Gets the quarter in a year of a given month.
     * @param month Month in a year.
     * @return Quarter in a year of a given month.
     */
    function _getQuarter(uint8 month) private pure returns (uint8) {
        return (month - 1) / uint8(3) + 1;
    }

    /**
     * @dev Gets the number of days in a month of a year.
     * @param month Month in a year.
     * @param year Year when specified month is.
     * @return Number of days in specified month of specified year.
     */
    function _getDaysInMonth(uint8 month, uint16 year) private pure returns (uint8) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            return 31;
        }
        else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        }
        else if (_isLeapYear(year)) {
            return 29;
        }
        else {
            return 28;
        }
    }

    /**
     * @dev Parses timestamp to DateTime struct.
     * @param timestamp Timestamp to be parsed.
     * @return DateTime struct of parsed timestamp.
     */
    function _parseTimestamp(uint32 timestamp) private pure returns (DateTime memory) {
        uint32 secondsAccountedFor = 0;
        uint32 buf;
        uint8 i;
        DateTime memory dt = DateTime(0, 0, 0, 0, 0, 0);

        // year
        dt.year = _getYear(timestamp);
        buf = _leapYearsBefore(dt.year) - _leapYearsBefore(ORIGIN_YEAR);

        secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
        secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

        // month
        uint32 secondsInMonth;
        for (i = 1; i <= 12; i++) {
            secondsInMonth = DAY_IN_SECONDS * _getDaysInMonth(i, dt.year);
            if (secondsInMonth + secondsAccountedFor > timestamp) {
                dt.month = i;
                break;
            }
            secondsAccountedFor += secondsInMonth;
        }

        // day
        uint8 daysInMonth = _getDaysInMonth(dt.month, dt.year);
        for (i = 1; i <= daysInMonth; i++) {
            if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                dt.day = i;
                break;
            }
            secondsAccountedFor += DAY_IN_SECONDS;
        }

        return dt;
   }

    /**
     * @dev Checks if year is leap year or not.
     * @param year Year to be checked.
     * @return True if year is leap year, otherwise false.
     */
    function _isLeapYear(uint16 year) private pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 != 0) {
            return false;
        }
        return true;
    }

    function _leapYearsBefore(uint32 year) private pure returns (uint32) {
        year -= 1;
        return year / 4 - year / 100 + year / 400;
    }

    /**
     * @dev Gets year of the specified timestamp.
     * @param timestamp Timestamp to be parsed.
     * @return Year of parsed timestamp.
     */
    function _getYear(uint32 timestamp) private pure returns (uint16) {
        uint32 secondsAccountedFor = 0;
        uint16 year;
        uint32 numLeapYears;

        // year
        year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
        numLeapYears = _leapYearsBefore(year) - _leapYearsBefore(ORIGIN_YEAR);

        secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
        secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

        while (secondsAccountedFor > timestamp) {
            if (_isLeapYear(uint16(year - 1))) {
                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
            }
            else {
                secondsAccountedFor -= YEAR_IN_SECONDS;
            }
            year -= 1;
        }

        return year;
    }
}
