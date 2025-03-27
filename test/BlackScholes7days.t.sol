// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {BlackScholes} from "../src/BlackScholes/BlackScholes.sol";
import {IBlackScholes} from "../src/BlackScholes/IBlackScholes.sol";

contract BlackScholes7daysTest is Test {
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
            assertLt(deviation, expectedCallPrice * 0.0025e18 / 1e18, "Allowed error is above 0.25%");
        }
        if (expectedPutPrice > 0) {
            uint256 deviation = expectedPutPrice > put ? expectedPutPrice - put : put - expectedPutPrice;
            assertLt(deviation, expectedPutPrice * 0.0025e18 / 1e18, "Allowed error is above 0.25%");
        }

        IBlackScholes.PricesAndGreeks memory pricesAndGreeks = BlackScholes.pricesAndGreeks(params);
        uint256 callPrice = BlackScholes.callPrice(params);
        uint256 putPrice = BlackScholes.putPrice(params);

        assertEq(call, callPrice);
        assertEq(put, putPrice);
        assertEq(pricesAndGreeks.callPrice, callPrice);
        assertEq(pricesAndGreeks.putPrice, putPrice);
    }

    function testPrice_7days_10vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            399 * 10**15
        );
    }

    function testPrice_7days_10vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            199 * 10**15
        );
    }

    function testPrice_7days_10vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            1625125048853306,
            2625125048853192
        );
    }

    function testPrice_7days_10vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            2088156949206961,
            2088156949206961
        );
    }

    function testPrice_7days_10vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            2627175442645580,
            1627175442645693
        );
    }

    function testPrice_7days_10vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            201 * 10**15,
            0
        );
    }

    function testPrice_7days_10vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_10vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530
        );
    }

    function testPrice_7days_10vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198868501797331530
        );
    }

    function testPrice_7days_10vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            1681420344013815,
            2549922141345405
        );
    }

    function testPrice_7days_10vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            2154427733255602,
            2022929530587134
        );
    }

    function testPrice_7days_10vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            2703393007906470,
            1571894805237946
        );
    }

    function testPrice_7days_10vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201131498202668470,
            0
        );
    }

    function testPrice_7days_10vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401131498202668470,
            0
        );
    }

    function testPrice_7days_10vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            398726064924326600
        );
    }

    function testPrice_7days_10vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            198726064924326580
        );
    }

    function testPrice_7days_10vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            1743864805720477,
            2469929730047170
        );
    }

    function testPrice_7days_10vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            2227697915143039,
            1953762839469504
        );
    }

    function testPrice_7days_10vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            2787404084033937,
            1513469008360459
        );
    }

    function testPrice_7days_10vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            201273935075673420,
            0
        );
    }

    function testPrice_7days_10vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            401273935075673400,
            0
        );
    }

    function testPrice_7days_70vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            399 * 10**15
        );
    }

    function testPrice_7days_70vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            3,
            1990000000035919
        );
    }

    function testPrice_7days_70vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_70vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_70vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_70vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_70vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_70vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530
        );
    }

    function testPrice_7days_70vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            3,
            198868501797331530
        );
    }

    function testPrice_7days_70vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_70vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_70vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_70vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_70vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_70vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            0,
            398726064924326600
        );
    }

    function testPrice_7days_70vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            3,
            198726064924326580
        );
    }

    function testPrice_7days_70vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_70vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_70vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_70vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_70vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_80vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            399 * 10**15
        );
    }

    function testPrice_7days_80vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            3,
            1990000000035919
        );
    }

    function testPrice_7days_80vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_80vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_80vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_80vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_80vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_80vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530
        );
    }

    function testPrice_7days_80vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            3,
            198868501797331530
        );
    }

    function testPrice_7days_80vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_80vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_80vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_80vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_80vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_80vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            0,
            398726064924326600
        );
    }

    function testPrice_7days_80vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            3,
            198726064924326580
        );
    }

    function testPrice_7days_80vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_80vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_80vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_80vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_80vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_90vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            399 * 10**15
        );
    }

    function testPrice_7days_90vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            772,
            19900000077258256
        );
    }

    function testPrice_7days_90vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_90vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_90vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_90vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_90vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_90vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530
        );
    }

    function testPrice_7days_90vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            772,
            198868501797331530
        );
    }

    function testPrice_7days_90vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_90vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_90vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_90vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_90vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401 * 10**15,
            0
        );
    }

    function testPrice_7days_90vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            0,
            398726064924326600
        );
    }

    function testPrice_7days_90vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            772,
            198726064924326580
        );
    }

    function testPrice_7days_90vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            14114435200028595,
            15114435200028595
        );
    }

    function testPrice_7days_90vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1 * 10**DECIMALS),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            14616297747764690,
            14616297747764690
        );
    }

    function testPrice_7days_90vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            15129046055571280,
            14129046055571337
        );
    }

    function testPrice_7days_90vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            20100000216014337,
            2
        );
    }

    function testPrice_7days_90vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**15),
                strike: uint128(1 * 10**DECIMALS),
                secondsToExpiry: 7 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            401 * 10**15,
            0
        );
    }
}
