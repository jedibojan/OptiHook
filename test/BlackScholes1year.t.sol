// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {BlackScholes} from "../src/BlackScholes/BlackScholes.sol";
import {IBlackScholes} from "../src/BlackScholes/IBlackScholes.sol";

contract BlackScholes1yearTest is Test {
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

    function testPrice_1year_10vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            399000002523179300000000
        );
    }

    function testPrice_1year_10vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            413951975144031170000,
            199413951975143980000000
        );
    }

    function testPrice_1year_10vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            39359666070583220000000,
            40359666070583220000000
        );
    }

    function testPrice_1year_10vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            39877611676745000000000,
            39877611676745000000000
        );
    }

    function testPrice_1year_10vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            40399541690089390000000,
            39399541690089274000000
        );
    }

    function testPrice_1year_10vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            202443089319359630000000,
            1443089319359685800000
        );
    }

    function testPrice_1year_10vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            401011426464026900000000,
            11426464026802421000
        );
    }

    function testPrice_1year_10vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            352133817295511000000000
        );
    }

    function testPrice_1year_10vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            1450997741660583400000,
            153584784819165480000000
        );
    }

    function testPrice_1year_10vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            66073394568728280000000,
            20207181646233075000000
        );
    }

    function testPrice_1year_10vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            66773601632569330000000,
            19907388710074185000000
        );
    }

    function testPrice_1year_10vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            67477275358020910000000,
            19611062435525644000000
        );
    }

    function testPrice_1year_10vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            248244537458082780000000,
            378324535587546050000
        );
    }

    function testPrice_1year_10vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            447867787357782000000000,
            1574435286772939000
        );
    }

    function testPrice_1year_10vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            303837767365639100000000
        );
    }

    function testPrice_1year_10vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            4589692119945335000000,
            108427110155904900000000
        );
    }

    function testPrice_1year_10vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            102229522133653400000000,
            8066940169613023000000
        );
    }

    function testPrice_1year_10vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            103081509256344290000000,
            7918927292303706000000
        );
    }

    function testPrice_1year_10vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            103935795208822350000000,
            7773213244781888000000
        );
    }

    function testPrice_1year_10vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            296233841731662300000000,
            71259767621666920000
        );
    }

    function testPrice_1year_10vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            496162727024401100000000,
            145060360588103340
        );
    }

    function testPrice_1year_70vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            71465046242238900000000,
            470465046242238900000000
        );
    }

    function testPrice_1year_70vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            158657260945571560000000,
            357657260945571600000000
        );
    }

    function testPrice_1year_70vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            273024739862934200000000,
            274024739862934340000000
        );
    }

    function testPrice_1year_70vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            273661302351238030000000,
            273661302351238030000000
        );
    }

    function testPrice_1year_70vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            274298400897256800000000,
            273298400897256800000000
        );
    }

    function testPrice_1year_70vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            411468755612233770000000,
            210468755612233770000000
        );
    }

    function testPrice_1year_70vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 0
            }),
            564503193150694600000000,
            163503193150694540000000
        );
    }

    function testPrice_1year_70vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            78421772823612060000000,
            430555559901116800000000
        );
    }

    function testPrice_1year_70vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            171002462449756360000000,
            323136249527261200000000
        );
    }

    function testPrice_1year_70vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            290622386989191640000000,
            244756174066696370000000
        );
    }

    function testPrice_1year_70vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            291284361104800250000000,
            244418148182305040000000
        );
    }

    function testPrice_1year_70vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            291946857336962250000000,
            244080644414467160000000
        );
    }

    function testPrice_1year_70vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            433886584539907750000000,
            186020371617412720000000
        );
    }

    function testPrice_1year_70vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            591019773067334000000000,
            143153560144838700000000
        );
    }

    function testPrice_1year_70vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            86418972694774100000000,
            390256390730733600000000
        );
    }

    function testPrice_1year_70vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            184875035993949000000000,
            288712454029908460000000
        );
    }

    function testPrice_1year_70vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            310078517222430960000000,
            215915935258390440000000
        );
    }

    function testPrice_1year_70vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            310767207944899160000000,
            215604625980858570000000
        );
    }

    function testPrice_1year_70vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            311456403404528900000000,
            215293821440488400000000
        );
    }

    function testPrice_1year_70vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            458363028294437040000000,
            162200446330396460000000
        );
    }

    function testPrice_1year_70vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(7e17),
                rate: 1e17
            }),
            619692565584974600000000,
            123529983620934130000000
        );
    }

    function testPrice_1year_80vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            94335465054470580000000,
            493335465054470500000000
        );
    }

    function testPrice_1year_80vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            190503147254506100000000,
            389503147254506100000000
        );
    }

    function testPrice_1year_80vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            310188291763002200000000,
            311188291763002200000000
        );
    }

    function testPrice_1year_80vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            310843483220648400000000,
            310843483220648370000000
        );
    }

    function testPrice_1year_80vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            311499135016054000000000,
            310499135016053900000000
        );
    }

    function testPrice_1year_80vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            451014009454028500000000,
            250014009454028500000000
        );
    }

    function testPrice_1year_80vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            604264654151705300000000,
            203264654151705200000000
        );
    }

    function testPrice_1year_80vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            101697119324568080000000,
            453830906402072900000000
        );
    }

    function testPrice_1year_80vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            202625126222204240000000,
            354758913299709150000000
        );
    }

    function testPrice_1year_80vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            326833146466387140000000,
            280966933543891900000000
        );
    }

    function testPrice_1year_80vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            327510163931897430000000,
            280643951009402300000000
        );
    }

    function testPrice_1year_80vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            328187630010364640000000,
            280321417087869500000000
        );
    }

    function testPrice_1year_80vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            471814457853329600000000,
            223948244930834450000000
        );
    }

    function testPrice_1year_80vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            628655280757278400000000,
            180789067834783230000000
        );
    }

    function testPrice_1year_80vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            110031526294577110000000,
            413868944330536600000000
        );
    }

    function testPrice_1year_80vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            216112282863180400000000,
            319949700899139860000000
        );
    }

    function testPrice_1year_80vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            345121492198530400000000,
            250958910234490000000000
        );
    }

    function testPrice_1year_80vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            345821483243535900000000,
            250658901279495400000000
        );
    }

    function testPrice_1year_80vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            346521908767724300000000,
            250359326803683830000000
        );
    }

    function testPrice_1year_80vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            494445463159557100000000,
            198282881195516500000000
        );
    }

    function testPrice_1year_80vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            654989104045953800000000,
            158826522081913400000000
        );
    }

    function testPrice_1year_90vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            118333333333333330000000,
            517333333333333330000000
        );
    }

    function testPrice_1year_90vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            223333333333333330000000,
            422333333333333330000000
        );
    }

    function testPrice_1year_90vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            347333333333333330000000,
            348333333333333330000000
        );
    }

    function testPrice_1year_90vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            348000000000000000000000,
            348000000000000000000000
        );
    }

    function testPrice_1year_90vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            348666666666666670000000,
            347666666666666670000000
        );
    }

    function testPrice_1year_90vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            493333333333333330000000,
            292333333333333330000000
        );
    }

    function testPrice_1year_90vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            651333333333333330000000,
            250333333333333330000000
        );
    }

    function testPrice_1year_90vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            125494032459228100000000,
            477627819536733000000000
        );
    }

    function testPrice_1year_90vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            233808324646234020000000,
            385942111723738840000000
        );
    }

    function testPrice_1year_90vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            362342598833477100000000,
            316476385910981860000000
        );
    }

    function testPrice_1year_90vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            363035038499670600000000,
            316168825577175400000000
        );
    }

    function testPrice_1year_90vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            363727868696050950000000,
            315861655773555740000000
        );
    }

    function testPrice_1year_90vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            509387730098938050000000,
            261521517176442720000000
        );
    }

    function testPrice_1year_90vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            666647254843206600000000,
            218781041920711300000000
        );
    }

    function testPrice_1year_90vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            137333333333333330000000,
            431333333333333330000000
        );
    }

    function testPrice_1year_90vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            251333333333333330000000,
            345333333333333330000000
        );
    }

    function testPrice_1year_90vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            385333333333333330000000,
            281333333333333330000000
        );
    }

    function testPrice_1year_90vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            386000000000000000000000,
            281000000000000000000000
        );
    }

    function testPrice_1year_90vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            386666666666666670000000,
            280666666666666670000000
        );
    }

    function testPrice_1year_90vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            539333333333333330000000,
            233333333333333330000000
        );
    }

    function testPrice_1year_90vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401000 * 10**DECIMALS),
                strike: uint128(1000000 * 10**DECIMALS),
                secondsToExpiry: 365 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            705333333333333330000000,
            199333333333333330000000
        );
    }
}