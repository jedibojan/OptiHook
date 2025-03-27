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
        // verify with 0.3% error deviation allowed
        if (expectedCallPrice > 0) {
            uint256 deviation = expectedCallPrice > call ? expectedCallPrice - call : call - expectedCallPrice;
            assertLt(deviation, expectedCallPrice * 0.003e18 / 1e18, "Allowed error is above 0.3%");
        }
        if (expectedPutPrice > 0) {
            uint256 deviation = expectedPutPrice > put ? expectedPutPrice - put : put - expectedPutPrice;
            assertLt(deviation, expectedPutPrice * 0.003e18 / 1e18, "Allowed error is above 0.3%");
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
            198999999999999950
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
            5036348201986229,
            6036348201986286
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
            5524706145628500,
            5524706145628500
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
            6041858523417098,
            5041858523417320
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
            201000000000000070,
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
            398079875629070770
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
            198079875629070700
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
            5479556253490114,
            5559431882560750
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
            5994422137463928,
            5074297766534785
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
            6538005789793133,
            4617881418863990
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
            201920124370929320,
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
            401920124370929300,
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
            397084029599955500
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
            197084029599955400
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
            5986734163467400,
            5070763763422914
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
            6530239354831657,
            4614268954787870
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
            7102237186594529,
            4186266786549860
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
            202915970400044600,
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
            402915970400044570,
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
            399000001006581300
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
            327749055596491,
            199327749055596360
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
            38140842000357830,
            39140842000357834
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
            38658114775770080,
            38658114775770080
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
            39179498059915380,
            38179498059915384
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
            202206099193715570,
            1206099193715490
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
            401007305424732730,
            7335424732653
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
            398079876690091260
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
            336795368003468,
            198416670997074160
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
            38581075892551270,
            38660951521622020
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
            39102132664920070,
            38182008293990710
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
            39627297869388730,
            37707173498459640
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
            203096345117941400,
            1176220747011944
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
            401927156763678100,
            7024892748790
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
            397084030723171550
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
            346847864484118,
            197430877464439660
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
            39061463898391880,
            38145493498347280
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
            39586617849432070,
            37670647449387470
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
            40115877566249010,
            37199907166204410
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
            204060562880816300,
            1144592480771759
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
            402922717893029800,
            6747292985985
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
            399000037093764640
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
            834415794772724,
            199834415794772680
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
            43655120097317090,
            44655120097317090
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
            44175409198318800,
            44175409198318800
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
            44699293708834800,
            43699293708834850
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
            203483603674315730,
            2483603674315569
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
            401042877971480100,
            42877971480066
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
            398079914272042030
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
            852802282194788,
            198932677911265450
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
            44093071724545680,
            44172947353616240
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
            44616670638923550,
            43696606267994110
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
            45143863184358200,
            43223898813428760
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
            204353505024710400,
            2433380653781222
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
            401961728417494670,
            41604046565638
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
            397084069991399100
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
            873122678725440,
            197957152278680830
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
            44570497786495470,
            43654527386450870
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
            45097680488473510,
            43181710088428910
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
            45628454616020500,
            42712484215975900
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
            205295941317233170,
            2379970917188785
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
            402956234268059150,
            40263868014625
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
            399000470917148850
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
            1670490822459791,
            200670490822459700
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
            49167340628310520,
            50167340628310520
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
            49690587812600220,
            49690587812600220
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
            50217029618829010,
            49217029618829120
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
            205283586249545240,
            4283586249545224
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
            401153420413243400,
            153420413243550
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
            398080362263192100
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
            1700819009798515,
            199780694638869270
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
            49602954144606640,
            49682929773677200
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
            50129142190399270,
            49109101781946990
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
            50658523301038310,
            48638482892586030
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
            206130892127953440,
            4210767757024184
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
            402069805624588700,
            149681253659501
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
            397084533824760830
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
            1734210600949866,
            198818240200905330
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
            50077466975307680,
            49161496575263080
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
            50606839339622340,
            48586888939577740
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
            51139402886338670,
            48122324862942940
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
            207049050595823680,
            4133080195779015
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
            403061695896504400,
            145725496459679
        );
    }
}
