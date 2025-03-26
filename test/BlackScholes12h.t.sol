// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {BlackScholes} from "../src/BlackScholes/BlackScholes.sol";
import {IBlackScholes} from "../src/BlackScholes/IBlackScholes.sol";

contract BlackScholes12hTest is Test {
    uint constant DECIMALS = 18;

    function testPrices(
        IBlackScholes.InputParams memory params,
        uint128 expectedCallPrice,
        uint128 expectedPutPrice
    ) internal pure {
        (uint256 call, uint256 put) = BlackScholes.prices(params);
        IBlackScholes.PricesAndGreeks memory pricesAndGreeks = BlackScholes.pricesAndGreeks(params);
        uint256 callPrice = BlackScholes.callPrice(params);
        uint256 putPrice = BlackScholes.putPrice(params);

        assertEq(call, callPrice);
        assertEq(put, putPrice);
        assertEq(pricesAndGreeks.callPrice, callPrice);
        assertEq(pricesAndGreeks.putPrice, putPrice);
    }

    function testPrice_12h_10vol_601k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_801k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_999k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1000k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1001k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1201k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_601k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_801k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_999k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1000k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1001k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1201k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_601k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_801k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_999k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1000k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1001k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1201k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_601k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_801k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_999k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1000k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1001k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1201k_0rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_601k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_801k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_999k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1000k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1001k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1201k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_601k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_801k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_999k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1000k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1001k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1201k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_601k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_801k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_999k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1000k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1001k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1201k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_601k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_801k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_999k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1000k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1001k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1201k_48rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 48
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_601k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_801k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_999k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1000k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1001k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_10vol_1201k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(1e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_601k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_801k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_999k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1000k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1001k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_70vol_1201k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(7e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_601k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_801k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_999k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1000k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1001k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_80vol_1201k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(8e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_601k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_801k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_999k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1000k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1001k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 100
            }),
            0,
            0
        );
    }

    function testPrice_12h_90vol_1201k_100rate() public pure {
        testPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 12 hours,
                volatility: uint80(9e17),
                rate: 100
            }),
            0,
            0
        );
    }
} 