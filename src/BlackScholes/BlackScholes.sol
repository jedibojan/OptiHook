// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {SignedSafeDecimalMath} from "./SignedSafeDecimalMath.sol";
import {SafeDecimalMath} from "./SafeDecimalMath.sol";
import {SignedSafeMath} from "permit2/lib/openzeppelin-contracts/contracts/utils/math/SignedSafeMath.sol";
import {IBlackScholes} from "./IBlackScholes.sol";

/**
 * @title BlackScholes
 * 
 * @dev Black-Scholes option pricing model.
 */
library BlackScholes {
    using SafeDecimalMath for uint;
    using SignedSafeMath for int;
    using SignedSafeDecimalMath for int;

    uint internal constant SECONDS_PER_YEAR = 31536000;
    uint internal constant PRECISE_UNIT = 1e27;
    int internal constant STD_NORMAL_CDF_MINIMUM = -4 * int(PRECISE_UNIT);   // -4
    int internal constant STD_NORMAL_CDF_MAXIMUM = 10 * int(PRECISE_UNIT);   // +10
    uint internal constant TIME_TO_EXPIRY_YEARS_MINIMUM = PRECISE_UNIT / SECONDS_PER_YEAR;  // 1 sec
    uint internal constant MIN_VOLATILITY = PRECISE_UNIT / 10000;                           // 0.01%
    uint internal constant VEGA_STANDARDISATION_MIN_DAYS = 7 days;

    uint internal constant SQRT_2XPI = 2506628274631000502415765285;  // sqrt(2 * PI)
    uint internal constant SCALE = 1e18;
    uint internal constant SCALE_DOWN = 1e9;

    int internal constant LOG2_E_SIGNED = 1_442695040888963407;       // log2(e)
    int internal constant HALF_SCALE_SIGNED = 5e17;                   // 0.5 * 10 ** 18
    int internal constant SCALE_SIGNED = 1e18;
    int internal constant SCALE_DOWN_SIGNED = 1e9;

    function callPrice(
        uint128 spot,
        uint128 strike,
        uint32 timeToExpirySec,
        uint80 vol,
        int80 rate
    ) internal pure returns (uint price) {
        uint timeToExpiryYear = _anualize(uint(timeToExpirySec));
        uint spotPrecise = (uint (spot)).decimalToPreciseDecimal();
        uint strikePrecise = (uint (strike)).decimalToPreciseDecimal();
        int ratePrecise = (int (rate)).decimalToPreciseDecimal();

        (int d1, int d2) =
        _d1d2(timeToExpiryYear, (uint (vol)).decimalToPreciseDecimal(), spotPrecise, strikePrecise, ratePrecise);

        (uint callPrecise, ) = _prices(timeToExpiryYear, spotPrecise, strikePrecise, ratePrecise, d1, d2);
        price = callPrecise.preciseDecimalToDecimal();

        if (price == 0) {
            price = 1000000000;
        }
    }

    function putPrice(
        uint128 spot,
        uint128 strike,
        uint32 timeToExpirySec,
        uint80 vol,
        int80 rate
    ) internal pure returns (uint price) {
        uint timeToExpiryYear = _anualize(uint(timeToExpirySec));
        uint spotPrecise = (uint (spot)).decimalToPreciseDecimal();
        uint strikePrecise = (uint (strike)).decimalToPreciseDecimal();
        int ratePrecise = (int (rate)).decimalToPreciseDecimal();

        (int d1, int d2) =
        _d1d2(timeToExpiryYear, (uint (vol)).decimalToPreciseDecimal(), spotPrecise, strikePrecise, ratePrecise);

        (, uint putPrecise) = _prices(timeToExpiryYear, spotPrecise, strikePrecise, ratePrecise, d1, d2);
        price = putPrecise.preciseDecimalToDecimal();

        if (price == 0) {
            price = 1000000000;
        }
    }

  /**
   * @dev Returns call and put option prices with given parameters.
   * @param timeToExpirySec Number of seconds to the expiry
   * @param vol Implied volatility (in decimal format)
   * @param spot The current price of the underlying
   * @param strike The strike price
   * @param rate Risk-free rate (in decimal format)
   */
  function prices(
    uint timeToExpirySec,
    uint vol,
    uint spot,
    uint strike,
    int rate
  ) internal pure returns (uint call, uint put) {
    uint timeToExpiryYear = _anualize(timeToExpirySec);
    uint spotPrecise = spot.decimalToPreciseDecimal();
    uint strikePrecise = strike.decimalToPreciseDecimal();
    int ratePrecise = rate.decimalToPreciseDecimal();

    (int d1, int d2) =
      _d1d2(timeToExpiryYear, vol.decimalToPreciseDecimal(), spotPrecise, strikePrecise, ratePrecise);
    (uint callPrecise, uint putPrecise) = _prices(timeToExpiryYear, spotPrecise, strikePrecise, ratePrecise, d1, d2);

    call = callPrecise.preciseDecimalToDecimal();
    put = putPrecise.preciseDecimalToDecimal();

    if (call == 0) {
        call = 1000000000;
    }

    if (put == 0) {
        put = 1000000000;
    }
  }

  /**
   * @dev Returns call/put prices and delta/vega for given parameters.
   * @param timeToExpirySec Number of seconds to the expiry
   * @param vol Implied volatility (in decimal format)
   * @param spot The current price of the underlying
   * @param strike The strike price
   * @param rate Risk-free rate (in decimal format)
   */
  function pricesAndGreeks(
    uint timeToExpirySec,
    uint vol,
    uint spot,
    uint strike,
    int rate
  ) internal pure returns (IBlackScholes.PricesAndGreeks memory) {
    uint timeToExpiryYear = _anualize(timeToExpirySec);
    uint spotPrecise = spot.decimalToPreciseDecimal();

    (int d1, int d2) =
      _d1d2(
        timeToExpiryYear,
        vol.decimalToPreciseDecimal(),
        spotPrecise,
        strike.decimalToPreciseDecimal(),
        rate.decimalToPreciseDecimal()
      );
    (uint callPrecise, uint putPrecise) =
      _prices(
        timeToExpiryYear,
        spotPrecise,
        strike.decimalToPreciseDecimal(),
        rate.decimalToPreciseDecimal(),
        d1,
        d2
      );

    uint call = callPrecise.preciseDecimalToDecimal();
    uint put = putPrecise.preciseDecimalToDecimal();

    if (call == 0) {
        call = 1000000000;
    }

    if (put == 0) {
        put = 1000000000;
    }

    uint standardVega = _standardVega(d1, spotPrecise, timeToExpirySec);
    (int callDelta, int putDelta) = _delta(d1);

    return
      IBlackScholes.PricesAndGreeks(
        call,
        put,
        callDelta.preciseDecimalToDecimal(),
        putDelta.preciseDecimalToDecimal(),
        standardVega
      );
  }

   /**
   * @dev Returns vega for given parameters.
   * @param timeToExpirySec Number of seconds to the expiry
   * @param vol Implied volatility (in decimal format)
   * @param spot The current price of the underlying
   * @param strike The strike price
   * @param rate Risk-free rate (in decimal format)
   */
  function vega(
    uint timeToExpirySec,
    uint vol,
    uint spot,
    uint strike,
    int rate
  ) internal pure returns (uint) {
    uint timeToExpiryYear = _anualize(timeToExpirySec);
    uint spotPrecise = spot.decimalToPreciseDecimal();

    (int d1, ) =
      _d1d2(
        timeToExpiryYear,
        vol.decimalToPreciseDecimal(),
        spotPrecise,
        strike.decimalToPreciseDecimal(),
        rate.decimalToPreciseDecimal()
      );

    return _standardVega(d1, spotPrecise, timeToExpirySec);
  }

  /**
   * @dev Returns the natural log of the value.
   */
  function ln(uint x) internal pure returns (int result) {
    result = (_log2(int(x)) * SCALE_SIGNED) / LOG2_E_SIGNED;
  }

  /**
   * @dev Returns the natural exponent of the value.
   */
  function expE(int x) internal pure returns (uint result) {
      unchecked {
          int doubleScaleProduct = (x / SCALE_DOWN_SIGNED) * LOG2_E_SIGNED;
          result = _exp2((doubleScaleProduct + HALF_SCALE_SIGNED) / SCALE_SIGNED) * SCALE_DOWN;
      }
  }

  /**
   * @dev Returns the square root of the value with high precision.
   */
  function sqrtPrecise(uint x) internal pure returns (uint result) {
      result = sqrt(x * PRECISE_UNIT);
  }

  /**
   * @dev Returns standard normal distribution of the value.
   */
  function stdNormal(int x) internal pure returns (uint result) {
      result = expE(-x.multiplyDecimalRoundPrecise(x / 2)).divideDecimalRoundPrecise(SQRT_2XPI);
  }

  /*
   * @dev Returns standard normal cumulative distribution of the value.
   */
  function stdNormalCDF(int x) internal pure returns (uint result) {
     if (x < STD_NORMAL_CDF_MINIMUM) {
      return 0;
    }

    if (x > STD_NORMAL_CDF_MAXIMUM) {
      return PRECISE_UNIT;
    }

    int t1 = int(1e7 + int((2315419 * _abs(x)) / PRECISE_UNIT));
    int exponent = x.multiplyDecimalRoundPrecise(x / 2);
    int d = int((3989423 * PRECISE_UNIT) / expE(exponent));
    uint prob = uint((d * (3193815 + ((-3565638 + ((17814780 + ((-18212560 + (13302740 * 1e7) / t1) * 1e7) / t1) * 1e7) / t1) * 1e7) / t1) * 1e7) / t1);
    if (x > 0) {
      prob = 1e14 - prob;
    }

    result = (PRECISE_UNIT * prob) / 1e14;
  }

  /**
   * @dev Returns internal coefficients d1 and d2 of the Black-Scholes model.
   * @param timeToExpiryYears Number of years to expiry
   * @param vol Implied volatility (in decimal format)
   * @param spot The current price of the underlying
   * @param strike The strike price
   * @param rate Risk-free rate (in decimal format)
   */
  function _d1d2(
    uint timeToExpiryYears,
    uint vol,
    uint spot,
    uint strike,
    int rate
  ) internal  pure returns (int d1, int d2) {
    // Set minimum values for timeToExpiryYears and volatility to not break computation in extreme scenarios
    // These values will result in option prices reflecting only the difference in stock/strike, which is expected.
    // This should be caught before calling this function, however the function shouldn't break if the values are 0.
    timeToExpiryYears = timeToExpiryYears < TIME_TO_EXPIRY_YEARS_MINIMUM ? TIME_TO_EXPIRY_YEARS_MINIMUM : timeToExpiryYears;
    vol = vol < MIN_VOLATILITY ? MIN_VOLATILITY : vol;

    int vtSqrt = int(vol.multiplyDecimalRoundPrecise(sqrtPrecise(timeToExpiryYears)));
    int log = int(ln(spot.divideDecimal(strike)) * 1000000000);
    int v2t =
      (int(vol.multiplyDecimalRoundPrecise(vol) / 2) + rate).multiplyDecimalRoundPrecise(
        int(timeToExpiryYears)
      );
    d1 = (log + v2t).divideDecimalRoundPrecise(vtSqrt);
    d2 = d1 - vtSqrt;
  }

  // NOTE: delta can be calculated here cheaply using
  // delta = int(stdNormalCDF(d1));
  /**
   * @dev Call and put prices of the Black-Scholes model.
   * @param timeToExpiryYears Number of years to expiry
   * @param spot The current price of the underlying
   * @param strike The strike price
   * @param rate Risk-free rate (in decimal format)
   * @param d1 Internal coefficient of the Black-Scholes model
   * @param d2 Internal coefficient of the Black-Scholes model
   */
  function _prices(
    uint timeToExpiryYears,
    uint spot,
    uint strike,
    int rate,
    int d1,
    int d2
  ) internal  pure returns (uint call, uint put) {
    uint strikePV = strike.multiplyDecimalRoundPrecise(expE(-rate.multiplyDecimalRoundPrecise(int(timeToExpiryYears))));
    uint spotNd1 = spot.multiplyDecimalRoundPrecise(stdNormalCDF(d1));
    uint strikeNd2 = strikePV.multiplyDecimalRoundPrecise(stdNormalCDF(d2));

    // We clamp to zero if the minuend is less than the subtrahend
    // In some scenarios it may be better to compute put price instead and derive call from it depending on which way
    // around is more precise.
    call = strikeNd2 <= spotNd1 ? spotNd1 - strikeNd2 : 0;
    put = call + strikePV;
    put = spot <= put ? put - spot : 0;
  }

  /**
   * @dev Returns the option's call and put delta.
   * @param d1 Internal coefficient of the Black-Scholes model
   */
  function _delta(int d1) internal  pure returns (int callDelta, int putDelta) {
    callDelta = int(stdNormalCDF(d1));
    putDelta = callDelta - int(PRECISE_UNIT);
  }

  /**
   * @dev Returns the option's vega value with expiry modified to be at least VEGA_STANDARDISATION_MIN_DAYS
   * @param d1 Internal coefficient of the Black-Scholes model
   * @param spot The current price of the underlying
   * @param timeToExpirySec Number of seconds to expiry
   */
  function _standardVega(
    int d1,
    uint spot,
    uint timeToExpirySec
  ) internal pure returns (uint stdVega) {
    uint timeToExpiryYears = _anualize(timeToExpirySec);
    timeToExpirySec = timeToExpirySec < VEGA_STANDARDISATION_MIN_DAYS ? VEGA_STANDARDISATION_MIN_DAYS : timeToExpirySec;
    uint daysToExpiry = (timeToExpirySec * PRECISE_UNIT) / 1 days;
    uint normalisationFactor = sqrtPrecise((30 * PRECISE_UNIT).divideDecimalRoundPrecise(daysToExpiry)) / 100;
    uint vegaValue = sqrtPrecise(timeToExpiryYears).multiplyDecimalRoundPrecise(stdNormal(d1).multiplyDecimalRoundPrecise(spot));
    stdVega = vegaValue.multiplyDecimalRoundPrecise(normalisationFactor).preciseDecimalToDecimal();
  }

  /**
   * @dev Returns the square root of the value.
   */
  function sqrt(uint x) internal pure returns (uint result) {
    if (x == 0) {
      return 0;
    }

    // Set the initial guess to the least power of two that is greater than or equal to sqrt(x).
    uint xAux = uint(x);
    result = 1;
    if (xAux >= 0x100000000000000000000000000000000) {
        xAux >>= 128;
        result <<= 64;
    }
    if (xAux >= 0x10000000000000000) {
        xAux >>= 64;
        result <<= 32;
    }
    if (xAux >= 0x100000000) {
        xAux >>= 32;
        result <<= 16;
    }
    if (xAux >= 0x10000) {
        xAux >>= 16;
        result <<= 8;
    }
    if (xAux >= 0x100) {
        xAux >>= 8;
        result <<= 4;
    }
    if (xAux >= 0x10) {
        xAux >>= 4;
        result <<= 2;
    }
    if (xAux >= 0x8) {
        result <<= 1;
    }

    // The operations can never overflow because the result is max 2^127 when it enters this block.
    unchecked {
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1; // Seven iterations should be enough
        uint roundedDownResult = x / result;

        if(result >= roundedDownResult) {
          result = roundedDownResult;
        }
    }
  }

  /**
   * @dev Returns absolute value of an integer.
   */
  function _abs(int x) internal pure returns (uint result) {
    result = uint(x < 0 ? -x : x);
  }

  /**
   * @dev Converts timespan in seconds to a timespan in years.
   */
  function _anualize(uint timeToExpirySec) internal pure returns (uint timeToExpiryYears) {
    timeToExpiryYears = timeToExpirySec.divideDecimalRoundPrecise(SECONDS_PER_YEAR);
  }

  /// @notice Calculates the binary logarithm of x.
  ///
  /// @dev Based on the iterative approximation algorithm.
  /// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
  ///
  /// Requirements:
  /// - x must be greater than zero.
  ///
  /// Caveats:
  /// - The results are not perfectly accurate to the last decimal, due to the lossy precision of the iterative approximation.
  ///
  /// @param x The signed 59.18-decimal fixed-point number for which to calculate the binary logarithm.
  /// @return result The binary logarithm as a signed 59.18-decimal fixed-point number.
  function _log2(int x) internal pure returns (int result) {
      if (x <= 0) {
        revert ();
      }
      unchecked {
          // This works because log2(x) = -log2(1/x).
          int sign;
          if (x >= SCALE_SIGNED) {
              sign = 1;
          } else {
              sign = -1;
              // Do the fixed-point inversion inline to save gas. The numerator is SCALE * SCALE.
              assembly {
                  x := div(1000000000000000000000000000000000000, x)
              }
          }

          // Calculate the integer part of the logarithm and add it to the result and finally calculate y = x * 2^(-n).
          uint n = _mostSignificantBit(uint(x / SCALE_SIGNED));

          // The integer part of the logarithm as a signed 59.18-decimal fixed-point number. The operation can't overflow
          // because n is maximum 255, SCALE is 1e18 and sign is either 1 or -1.
          result = int(n) * SCALE_SIGNED;

          // This is y = x * 2^(-n).
          int y = x >> n;

          // If y = 1, the fractional part is zero.
          if (y == SCALE_SIGNED) {
              return result * sign;
          }

          // Calculate the fractional part via the iterative approximation.
          // The "delta >>= 1" part is equivalent to "delta /= 2", but shifting bits is faster.
          for (int delta = int(HALF_SCALE_SIGNED); delta > 0; delta >>= 1) {
              y = (y * y) / SCALE_SIGNED;

              // Is y^2 > 2 and so in the range [2,4)?
              if (y >= 2 * SCALE_SIGNED) {
                  // Add the 2^(-m) factor to the logarithm.
                  result += delta;

                  // Corresponds to z/2 on Wikipedia.
                  y >>= 1;
              }
          }
          result *= sign;
      }
  }

  function _mostSignificantBit(uint x) internal pure returns (uint msb) {
    if (x >= 2**128) {
        x >>= 128;
        msb += 128;
    }
    if (x >= 2**64) {
        x >>= 64;
        msb += 64;
    }
    if (x >= 2**32) {
        x >>= 32;
        msb += 32;
    }
    if (x >= 2**16) {
        x >>= 16;
        msb += 16;
    }
    if (x >= 2**8) {
        x >>= 8;
        msb += 8;
    }
    if (x >= 2**4) {
        x >>= 4;
        msb += 4;
    }
    if (x >= 2**2) {
        x >>= 2;
        msb += 2;
    }
    if (x >= 2**1) {
        // No need to shift x any more.
        msb += 1;
    }
  }

  /// @notice Calculates the binary exponent of x using the binary fraction method.
  ///
  /// @dev See https://ethereum.stackexchange.com/q/79903/24693.
  ///
  /// Requirements:
  /// - x must be 192 or less.
  /// - The result must fit within MAX_SD59x18.
  ///
  /// Caveats:
  /// - For any x less than -59.794705707972522261, the result is zero.
  ///
  /// @param x The exponent as a signed 59.18-decimal fixed-point number.
  /// @return result The result as a signed 59.18-decimal fixed-point number.
  function _exp2(int x) internal pure returns (uint result) {
    // This works because 2^(-x) = 1/2^x.
    if (x < 0) {
      // 2^59.794705707972522262 is the maximum number whose inverse does not truncate down to zero.
      if (x < -59_794705707972522261) {
          return 0;
      }

      // Do the fixed-point inversion inline to save gas. The numerator is SCALE * SCALE.
      unchecked {
          result = 1e36 / _exp2(-x);
      }
    } else {
      // 2^192 doesn't fit within the 192.64-bit format used internally in this function.
      if (x >= 192e18) {
          revert();
      }

      unchecked {
          // Convert x to the 192.64-bit fixed-point format.
          uint x192x64 = (uint(x) << 64) / SCALE;

          // Safe to convert the result to int directly because the maximum input allowed is 192.
          result = _exp2(x192x64);
      }
    }
  }

  /// @notice Calculates the binary exponent of x using the binary fraction method.
  /// @dev Has to use 192.64-bit fixed-point numbers.
  /// See https://ethereum.stackexchange.com/a/96594/24693.
  /// @param x The exponent as an unsigned 192.64-bit fixed-point number.
  /// @return result The result as an unsigned 60.18-decimal fixed-point number.
  function _exp2(uint x) internal pure returns (uint result) {
      unchecked {
          // Start from 0.5 in the 192.64-bit fixed-point format.
          result = 0x800000000000000000000000000000000000000000000000;

          // Multiply the result by root(2, 2^-i) when the bit at position i is 1. None of the intermediary results overflows
          // because the initial result is 2^191 and all magic factors are less than 2^65.
          if (x & 0x8000000000000000 > 0) {
              result = (result * 0x16A09E667F3BCC909) >> 64;
          }
          if (x & 0x4000000000000000 > 0) {
              result = (result * 0x1306FE0A31B7152DF) >> 64;
          }
          if (x & 0x2000000000000000 > 0) {
              result = (result * 0x1172B83C7D517ADCE) >> 64;
          }
          if (x & 0x1000000000000000 > 0) {
              result = (result * 0x10B5586CF9890F62A) >> 64;
          }
          if (x & 0x800000000000000 > 0) {
              result = (result * 0x1059B0D31585743AE) >> 64;
          }
          if (x & 0x400000000000000 > 0) {
              result = (result * 0x102C9A3E778060EE7) >> 64;
          }
          if (x & 0x200000000000000 > 0) {
              result = (result * 0x10163DA9FB33356D8) >> 64;
          }
          if (x & 0x100000000000000 > 0) {
              result = (result * 0x100B1AFA5ABCBED61) >> 64;
          }
          if (x & 0x80000000000000 > 0) {
              result = (result * 0x10058C86DA1C09EA2) >> 64;
          }
          if (x & 0x40000000000000 > 0) {
              result = (result * 0x1002C605E2E8CEC50) >> 64;
          }
          if (x & 0x20000000000000 > 0) {
              result = (result * 0x100162F3904051FA1) >> 64;
          }
          if (x & 0x10000000000000 > 0) {
              result = (result * 0x1000B175EFFDC76BA) >> 64;
          }
          if (x & 0x8000000000000 > 0) {
              result = (result * 0x100058BA01FB9F96D) >> 64;
          }
          if (x & 0x4000000000000 > 0) {
              result = (result * 0x10002C5CC37DA9492) >> 64;
          }
          if (x & 0x2000000000000 > 0) {
              result = (result * 0x1000162E525EE0547) >> 64;
          }
          if (x & 0x1000000000000 > 0) {
              result = (result * 0x10000B17255775C04) >> 64;
          }
          if (x & 0x800000000000 > 0) {
              result = (result * 0x1000058B91B5BC9AE) >> 64;
          }
          if (x & 0x400000000000 > 0) {
              result = (result * 0x100002C5C89D5EC6D) >> 64;
          }
          if (x & 0x200000000000 > 0) {
              result = (result * 0x10000162E43F4F831) >> 64;
          }
          if (x & 0x100000000000 > 0) {
              result = (result * 0x100000B1721BCFC9A) >> 64;
          }
          if (x & 0x80000000000 > 0) {
              result = (result * 0x10000058B90CF1E6E) >> 64;
          }
          if (x & 0x40000000000 > 0) {
              result = (result * 0x1000002C5C863B73F) >> 64;
          }
          if (x & 0x20000000000 > 0) {
              result = (result * 0x100000162E430E5A2) >> 64;
          }
          if (x & 0x10000000000 > 0) {
              result = (result * 0x1000000B172183551) >> 64;
          }
          if (x & 0x8000000000 > 0) {
              result = (result * 0x100000058B90C0B49) >> 64;
          }
          if (x & 0x4000000000 > 0) {
              result = (result * 0x10000002C5C8601CC) >> 64;
          }
          if (x & 0x2000000000 > 0) {
              result = (result * 0x1000000162E42FFF0) >> 64;
          }
          if (x & 0x1000000000 > 0) {
              result = (result * 0x10000000B17217FBB) >> 64;
          }
          if (x & 0x800000000 > 0) {
              result = (result * 0x1000000058B90BFCE) >> 64;
          }
          if (x & 0x400000000 > 0) {
              result = (result * 0x100000002C5C85FE3) >> 64;
          }
          if (x & 0x200000000 > 0) {
              result = (result * 0x10000000162E42FF1) >> 64;
          }
          if (x & 0x100000000 > 0) {
              result = (result * 0x100000000B17217F8) >> 64;
          }
          if (x & 0x80000000 > 0) {
              result = (result * 0x10000000058B90BFC) >> 64;
          }
          if (x & 0x40000000 > 0) {
              result = (result * 0x1000000002C5C85FE) >> 64;
          }
          if (x & 0x20000000 > 0) {
              result = (result * 0x100000000162E42FF) >> 64;
          }
          if (x & 0x10000000 > 0) {
              result = (result * 0x1000000000B17217F) >> 64;
          }
          if (x & 0x8000000 > 0) {
              result = (result * 0x100000000058B90C0) >> 64;
          }
          if (x & 0x4000000 > 0) {
              result = (result * 0x10000000002C5C860) >> 64;
          }
          if (x & 0x2000000 > 0) {
              result = (result * 0x1000000000162E430) >> 64;
          }
          if (x & 0x1000000 > 0) {
              result = (result * 0x10000000000B17218) >> 64;
          }
          if (x & 0x800000 > 0) {
              result = (result * 0x1000000000058B90C) >> 64;
          }
          if (x & 0x400000 > 0) {
              result = (result * 0x100000000002C5C86) >> 64;
          }
          if (x & 0x200000 > 0) {
              result = (result * 0x10000000000162E43) >> 64;
          }
          if (x & 0x100000 > 0) {
              result = (result * 0x100000000000B1721) >> 64;
          }
          if (x & 0x80000 > 0) {
              result = (result * 0x10000000000058B91) >> 64;
          }
          if (x & 0x40000 > 0) {
              result = (result * 0x1000000000002C5C8) >> 64;
          }
          if (x & 0x20000 > 0) {
              result = (result * 0x100000000000162E4) >> 64;
          }
          if (x & 0x10000 > 0) {
              result = (result * 0x1000000000000B172) >> 64;
          }
          if (x & 0x8000 > 0) {
              result = (result * 0x100000000000058B9) >> 64;
          }
          if (x & 0x4000 > 0) {
              result = (result * 0x10000000000002C5D) >> 64;
          }
          if (x & 0x2000 > 0) {
              result = (result * 0x1000000000000162E) >> 64;
          }
          if (x & 0x1000 > 0) {
              result = (result * 0x10000000000000B17) >> 64;
          }
          if (x & 0x800 > 0) {
              result = (result * 0x1000000000000058C) >> 64;
          }
          if (x & 0x400 > 0) {
              result = (result * 0x100000000000002C6) >> 64;
          }
          if (x & 0x200 > 0) {
              result = (result * 0x10000000000000163) >> 64;
          }
          if (x & 0x100 > 0) {
              result = (result * 0x100000000000000B1) >> 64;
          }
          if (x & 0x80 > 0) {
              result = (result * 0x10000000000000059) >> 64;
          }
          if (x & 0x40 > 0) {
              result = (result * 0x1000000000000002C) >> 64;
          }
          if (x & 0x20 > 0) {
              result = (result * 0x10000000000000016) >> 64;
          }
          if (x & 0x10 > 0) {
              result = (result * 0x1000000000000000B) >> 64;
          }
          if (x & 0x8 > 0) {
              result = (result * 0x10000000000000006) >> 64;
          }
          if (x & 0x4 > 0) {
              result = (result * 0x10000000000000003) >> 64;
          }
          if (x & 0x2 > 0) {
              result = (result * 0x10000000000000001) >> 64;
          }
          if (x & 0x1 > 0) {
              result = (result * 0x10000000000000001) >> 64;
          }

          // We're doing two things at the same time:
          //
          //   1. Multiply the result by 2^n + 1, where "2^n" is the integer part and the one is added to account for
          //      the fact that we initially set the result to 0.5. This is accomplished by subtracting from 191
          //      rather than 192.
          //   2. Convert the result to the unsigned 60.18-decimal fixed-point format.
          //
          // This works because 2^(191-ip) = 2^ip / 2^191, where "ip" is the integer part "2^n".
          result *= SCALE;
          result >>= (191 - (x >> 64));
      }
  }
}
