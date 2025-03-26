// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {BlackScholes} from "../src/BlackScholes/BlackScholes.sol";
import {IBlackScholes} from "../src/BlackScholes/IBlackScholes.sol";

contract BlackScholes12hTest is Test {
    uint constant DECIMALS = 18;

    function verifyPrices(
        IBlackScholes.InputParams memory params,
        uint256 expectedCallPrice,
        uint256 expectedPutPrice
    ) internal pure {
        (uint256 call, uint256 put) = BlackScholes.prices(params);
        // verify with 0.25% error deviation allowed
        if (expectedCallPrice > 0) {
            uint256 deviation = expectedCallPrice > call ? expectedCallPrice - call : call - expectedCallPrice;
            assertLt(deviation, expectedCallPrice * 0.0025e18, "Allowed error is above 0.25%");
        }
        if (expectedPutPrice > 0) {
            uint256 deviation = expectedPutPrice > put ? expectedPutPrice - put : put - expectedPutPrice;
            assertLt(deviation, expectedPutPrice * 0.0025e18, "Allowed error is above 0.25%");
        }

        IBlackScholes.PricesAndGreeks memory pricesAndGreeks = BlackScholes.pricesAndGreeks(params);
        uint256 callPrice = BlackScholes.callPrice(params);
        uint256 putPrice = BlackScholes.putPrice(params);

        assertEq(call, callPrice);
        assertEq(put, putPrice);
        assertEq(pricesAndGreeks.callPrice, callPrice);
        assertEq(pricesAndGreeks.putPrice, putPrice);
    }

    function testPrice_12h_10vol_601k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            399000 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_801k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            199000 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_999k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            1029 * 10**DECIMALS,
            2029 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1000k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            1476 * 10**DECIMALS,
            1476 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1001k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            2030 * 10**DECIMALS,
            1030 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1201k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            201000 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_70vol_601k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            399000 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_801k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            199000 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_999k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            9838 * 10**DECIMALS,
            10838 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1000k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            10335 * 10**DECIMALS,
            10335 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1001k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            10848 * 10**DECIMALS,
            9848 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1201k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            201000 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_80vol_601k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            399000 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_801k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            199000 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_999k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            11238 * 10**DECIMALS,
            12238 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1000k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            11735 * 10**DECIMALS,
            11735 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1001k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            12248 * 10**DECIMALS,
            11248 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1201k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            201000 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_90vol_601k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            399000 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_801k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            199000 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_999k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            12638 * 10**DECIMALS,
            13638 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1000k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            13135 * 10**DECIMALS,
            13135 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1001k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            13648 * 10**DECIMALS,
            12648 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1201k_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            201000 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_10vol_601k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398934 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_801k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198934 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_999k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            1055 * 10**DECIMALS,
            1989 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1000k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            1509 * 10**DECIMALS,
            1443 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1001k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            2070 * 10**DECIMALS,
            1005 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1201k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201065 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_70vol_601k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398934 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_801k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198934 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_999k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            9869 * 10**DECIMALS,
            10803 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1000k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            10368 * 10**DECIMALS,
            10302 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1001k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            10882 * 10**DECIMALS,
            9816 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1201k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201065 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_80vol_601k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398934 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_801k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198934 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_999k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            11269 * 10**DECIMALS,
            12203 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1000k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            11768 * 10**DECIMALS,
            11702 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1001k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            12282 * 10**DECIMALS,
            11116 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1201k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201065 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_90vol_601k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398934 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_801k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198934 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_999k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            12669 * 10**DECIMALS,
            13603 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1000k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            13168 * 10**DECIMALS,
            13102 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1001k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            13682 * 10**DECIMALS,
            12516 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1201k_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201065 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_10vol_601k_100rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: int256(100 * 10**(DECIMALS - 3))
            }),
            0,
            398863 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_801k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            198863 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_999k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            1084 * 10**DECIMALS,
            1947 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1000k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            1545 * 10**DECIMALS,
            1408 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1001k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            2114 * 10**DECIMALS,
            977 * 10**DECIMALS
        );
    }

    function testPrice_12h_10vol_1201k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            201136 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_70vol_601k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            0,
            398863 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_801k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            0,
            198863 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_999k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            9903 * 10**DECIMALS,
            10766 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1000k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            10403 * 10**DECIMALS,
            10266 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1001k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            10918 * 10**DECIMALS,
            9781 * 10**DECIMALS
        );
    }

    function testPrice_12h_70vol_1201k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            201136 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_80vol_601k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            0,
            398863 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_801k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            0,
            198863 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_999k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            11303 * 10**DECIMALS,
            12166 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1000k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            11803 * 10**DECIMALS,
            11666 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1001k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            12318 * 10**DECIMALS,
            10981 * 10**DECIMALS
        );
    }

    function testPrice_12h_80vol_1201k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            201136 * 10**DECIMALS,
            0
        );
    }

    function testPrice_12h_90vol_601k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            0,
            398863 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_801k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            0,
            198863 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_999k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            12703 * 10**DECIMALS,
            13566 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1000k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            13203 * 10**DECIMALS,
            13066 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1001k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            13718 * 10**DECIMALS,
            12481 * 10**DECIMALS
        );
    }

    function testPrice_12h_90vol_1201k_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            201136 * 10**DECIMALS,
            0
        );
    }
} 