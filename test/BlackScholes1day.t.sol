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
            1625125048853306,
            2625125048853192
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
            2088156949206961,
            2088156949206961
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
            2627175442645580,
            1627175442645693
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
            398868501797331530
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
            198868501797331530
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
            1681420344013815,
            2549922141345405
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
            2154427733255602,
            2022929530587134
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
            2703393007906470,
            1571894805237946
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
            201131498202668470,
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
            401131498202668470,
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
            398726064924326600
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
            198726064924326580
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
            1743864805720477,
            2469929730047170
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
            2227697915143039,
            1953762839469504
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
            2787404084033937,
            1513469008360459
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
            201273935075673420,
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
            401273935075673400,
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
            3,
            1990000000035919
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
            14114435200028595,
            15114435200028595
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
            14616297747764690,
            14616297747764690
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
            15129046055571280,
            14129046055571337
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
            20100000216014337,
            2
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
            398868501797331530
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
            3,
            1988685018010060
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
            14177885616365870,
            15046387413697346
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
            14681179969627408,
            14549681766958940
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
            15195359297459220,
            14063861094790752
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
            20113150032149463,
            2
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
            401131498202668470,
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
            398726064924326600
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
            3,
            19872606492809382
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
            14246826415149940,
            14972891339476462
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
            14751671842599137,
            14477736669257773
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
            15267401235518662,
            13993466062177308
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
            20127393715060134,
            2
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
            401273935075673400,
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
            386,
            19900000038629128
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
            16200466965623320,
            17200466965623377
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
            16704054267142850,
            16704054267142850
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
            17217166257997746,
            16217166257997860
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
            20100005859159216,
            58
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
            398868501797331530
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
            393,
            19886850219050360
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
            16263947353641868,
            17132449150973457
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
            16768787450559160,
            16637289247890749
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
            17283151563826323,
            16251653361157912
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
            20113155591769726,
            57
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
            401131498202668470,
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
            398726064924326600
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
            400,
            19872606532508564
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
            16332894087042860,
            17058959011736944
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
            16839091324721720,
            16565193122053309
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
            17354811743751327,
            16323313541082916
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
            20127399185529850,
            56
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
            401273935075673400,
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
            772,
            19900000077258256
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
            16200933931246640,
            17200933931246697
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
            16708108534285700,
            16708108534285700
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
            17234332515995492,
            16234332515995606
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
            20100011718318432,
            116
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
            398868501797331530
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
            786,
            19886850238100720
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
            16263947353641868,
            17132449150973457
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
            16768787450559160,
            16637289247890749
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
            17283151563826323,
            16251653361157912
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
            20113155591769726,
            57
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
            401131498202668470,
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
            398726064924326600
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
            800,
            19872606565017128
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
            16332894087042860,
            17058959011736944
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
            16839091324721720,
            16565193122053309
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
            17354811743751327,
            16323313541082916
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
            20127399185529850,
            56
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
            401273935075673400,
            0
        );
    }
}