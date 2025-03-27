// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {BlackScholes} from "../src/BlackScholes/BlackScholes.sol";
import {IBlackScholes} from "../src/BlackScholes/IBlackScholes.sol";

contract BlackScholes1dayTest is Test {
    uint constant DECIMALS = 18;

    function verifyPrices(
        IBlackScholes.InputParams memory params,
        uint256 expectedCallPrice,
        uint256 expectedPutPrice
    ) internal pure {
        (uint256 call, uint256 put) = BlackScholes.prices(params);
        // verify with 3% error deviation allowed
        uint256 allowedError = 0.03e18;
        // in cases of extreme volatility, and atm prices, allow more error (is fixed in next version)
        if (params.volatility >= 0.6e18 && (params.spot >= params.strike && params.spot - params.strike <= 1e18) || (params.spot <= params.strike && params.strike - params.spot <= 1e18)) {
            allowedError = 0.15e18;
        }
        if (expectedCallPrice > 0) {
            uint256 deviation = expectedCallPrice > call ? expectedCallPrice - call : call - expectedCallPrice;
            assertLt(deviation, expectedCallPrice * allowedError / 1e18, "Allowed error is above 3%");
        }
        if (expectedPutPrice > 0) {
            uint256 deviation = expectedPutPrice > put ? expectedPutPrice - put : put - expectedPutPrice;
            assertLt(deviation, expectedPutPrice * allowedError / 1e18, "Allowed error is above 3%");
        }

        IBlackScholes.PricesAndGreeks memory pricesAndGreeks = BlackScholes.pricesAndGreeks(params);
        uint256 callPrice = BlackScholes.callPrice(params);
        uint256 putPrice = BlackScholes.putPrice(params);

        assertEq(call, callPrice);
        assertEq(put, putPrice);
        assertEq(pricesAndGreeks.callPrice, callPrice);
        assertEq(pricesAndGreeks.putPrice, putPrice);
    }

    function testPrice_1day_10vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            399 * 10**DECIMALS
        );
    }

    function testPrice_1day_10vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            199 * 10**DECIMALS
        );
    }

    function testPrice_1day_10vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            1625125048853306000,
            2625125048853192000
        );
    }

    function testPrice_1day_10vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            2088156949206961000,
            2088156949206961000
        );
    }

    function testPrice_1day_10vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            2627175442645580000,
            1627175442645693000
        );
    }

    function testPrice_1day_10vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            201 * 10**DECIMALS,
            0
        );
    }

    function testPrice_1day_10vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            401 * 10**DECIMALS,
            0
        );
    }

    function testPrice_1day_10vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530000
        );
    }

    function testPrice_1day_10vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198868501797331530000
        );
    }

    function testPrice_1day_10vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            1681420344013815000,
            2549922141345405000
        );
    }

    function testPrice_1day_10vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            2154427733255602000,
            2022929530587134000
        );
    }

    function testPrice_1day_10vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            2703393007906470000,
            1571894805237946000
        );
    }

    function testPrice_1day_10vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201131498202668470000,
            0
        );
    }

    function testPrice_1day_10vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401131498202668470000,
            0
        );
    }

    function testPrice_1day_10vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            398726064924326600000
        );
    }

    function testPrice_1day_10vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            198726064924326580000
        );
    }

    function testPrice_1day_10vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            1743864805720477000,
            2469929730047170000
        );
    }

    function testPrice_1day_10vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            2227697915143039000,
            1953762839469504000
        );
    }

    function testPrice_1day_10vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            2787404084033937000,
            1513469008360459000
        );
    }

    function testPrice_1day_10vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            201273935075673420000,
            0
        );
    }

    function testPrice_1day_10vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            401273935075673400000,
            0
        );
    }

    function testPrice_1day_70vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            399 * 10**DECIMALS
        );
    }

    function testPrice_1day_70vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            0,
            199000000003591900000
        );
    }

    function testPrice_1day_70vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            14114435200028595000,
            15114435200028595000
        );
    }

    function testPrice_1day_70vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            14616297747764690000,
            14616297747764690000
        );
    }

    function testPrice_1day_70vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            15129046055571280000,
            14129046055571337000
        );
    }

    function testPrice_1day_70vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            201000002160143370000,
            0
        );
    }

    function testPrice_1day_70vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            401 * 10**DECIMALS,
            0
        );
    }

    function testPrice_1day_70vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530000
        );
    }

    function testPrice_1day_70vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198868501801006000000
        );
    }

    function testPrice_1day_70vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14177885616365870000,
            15046387413697346000
        );
    }

    function testPrice_1day_70vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            14681179969627408000,
            14549681766958940000
        );
    }

    function testPrice_1day_70vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            15195359297459220000,
            14063861094790752000
        );
    }

    function testPrice_1day_70vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201131500321494630000,
            0
        );
    }

    function testPrice_1day_70vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401131498202668470000,
            0
        );
    }

    function testPrice_1day_70vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            0,
            398726064924326600000
        );
    }

    function testPrice_1day_70vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            0,
            198726064928093820000
        );
    }

    function testPrice_1day_70vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            14246826415149940000,
            14972891339476462000
        );
    }

    function testPrice_1day_70vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            14751671842599137000,
            14477736669257773000
        );
    }

    function testPrice_1day_70vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            15267401235518662000,
            13993466062177308000
        );
    }

    function testPrice_1day_70vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            201273937150601340000,
            0
        );
    }

    function testPrice_1day_70vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            401273935075673400000,
            0
        );
    }

    function testPrice_1day_80vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            399 * 10**DECIMALS
        );
    }

    function testPrice_1day_80vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            0,
            199000000386291280000
        );
    }

    function testPrice_1day_80vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            16200466965623320000,
            17200466965623377000
        );
    }

    function testPrice_1day_80vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            16704054267142850000,
            16704054267142850000
        );
    }

    function testPrice_1day_80vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            17217166257997746000,
            16217166257997860000
        );
    }

    function testPrice_1day_80vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            201000058591592160000,
            0
        );
    }

    function testPrice_1day_80vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            401 * 10**DECIMALS,
            0
        );
    }

    function testPrice_1day_80vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530000
        );
    }

    function testPrice_1day_80vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198868502190503600000
        );
    }

    function testPrice_1day_80vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            16263947353641868000,
            17132449150973457000
        );
    }

    function testPrice_1day_80vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            16768787450559160000,
            16637289247890749000
        );
    }

    function testPrice_1day_80vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            17283151563826323000,
            16251653361157912000
        );
    }

    function testPrice_1day_80vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201131555917697260000,
            0
        );
    }

    function testPrice_1day_80vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401131498202668470000,
            0
        );
    }

    function testPrice_1day_80vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            0,
            398726064924326600000
        );
    }

    function testPrice_1day_80vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            0,
            198726065325085640000
        );
    }

    function testPrice_1day_80vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            16332894087042860000,
            17058959011736944000
        );
    }

    function testPrice_1day_80vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            16839091324721720000,
            16565193122053309000
        );
    }

    function testPrice_1day_80vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            17354811743751327000,
            16323313541082916000
        );
    }

    function testPrice_1day_80vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            201273991855298500000,
            0
        );
    }

    function testPrice_1day_80vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            401273935075673400000,
            0
        );
    }

    function testPrice_1day_90vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            399 * 10**DECIMALS
        );
    }

    function testPrice_1day_90vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            0,
            199000000772582560000
        );
    }

    function testPrice_1day_90vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            16200933931246640000,
            17200933931246697000
        );
    }

    function testPrice_1day_90vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            16708108534285700000,
            16708108534285700000
        );
    }

    function testPrice_1day_90vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            17234332515995492000,
            16234332515995606000
        );
    }

    function testPrice_1day_90vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            201000117183184320000,
            0
        );
    }

    function testPrice_1day_90vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            401 * 10**DECIMALS,
            0
        );
    }

    function testPrice_1day_90vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            398868501797331530000
        );
    }

    function testPrice_1day_90vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            198868502381007200000
        );
    }

    function testPrice_1day_90vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            16263947353641868000,
            17132449150973457000
        );
    }

    function testPrice_1day_90vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            16768787450559160000,
            16637289247890749000
        );
    }

    function testPrice_1day_90vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            17283151563826323000,
            16251653361157912000
        );
    }

    function testPrice_1day_90vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            201131555917697260000,
            0
        );
    }

    function testPrice_1day_90vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            401131498202668470000,
            0
        );
    }

    function testPrice_1day_90vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            0,
            398726064924326600000
        );
    }

    function testPrice_1day_90vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            0,
            198726065650171280000
        );
    }

    function testPrice_1day_90vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            16332894087042860000,
            17058959011736944000
        );
    }

    function testPrice_1day_90vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            16839091324721720000,
            16565193122053309000
        );
    }

    function testPrice_1day_90vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            17354811743751327000,
            16323313541082916000
        );
    }

    function testPrice_1day_90vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            201273991855298500000,
            0
        );
    }

    function testPrice_1day_90vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 1 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            401273935075673400000,
            0
        );
    }
}