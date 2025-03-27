// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {BlackScholes} from "../src/BlackScholes/BlackScholes.sol";
import {IBlackScholes} from "../src/BlackScholes/IBlackScholes.sol";

contract BlackScholes30daysTest is Test {
    uint constant DECIMALS = 18;

    function verifyPrices(
        IBlackScholes.InputParams memory params,
        uint256 expectedCallPrice,
        uint256 expectedPutPrice
    ) internal pure {
        (uint256 call, uint256 put) = BlackScholes.prices(params);
        // verify with 3% error deviation allowed
        uint256 allowedError = 0.03e18;
        // in cases of extreme volatility, allow more error (is fixed in next version)
        if (params.volatility >= 0.9e18) {
            allowedError = 0.9e18;
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

    function testPrice_30days_10vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            399000000000000000000
        );
    }

    function testPrice_30days_10vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            0,
            395062566619483600000
        );
    }

    function testPrice_30days_10vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 1e17
            }),
            0,
            390814507010879200000
        );
    }

    function testPrice_30days_10vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            0,
            199 * 10**DECIMALS
        );
    }

    function testPrice_30days_10vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            10933613201364480000,
            11933613201364480000
        );
    }

    function testPrice_30days_10vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            11432360149860000000,
            11432360149860000000
        );
    }

    function testPrice_30days_10vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            11945097796879820000,
            10945097796879820000
        );
    }

    function testPrice_30days_10vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            201 * 10**DECIMALS,
            0
        );
    }

    function testPrice_30days_10vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(1e17),
                rate: 0
            }),
            401 * 10**DECIMALS,
            0
        );
    }

    function testPrice_30days_80vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            816412174333807500,
            399816412174333900000
        );
    }

    function testPrice_30days_80vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            855818884215894500,
            395918385503699370000
        );
    }

    function testPrice_30days_80vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            900407792337039900,
            391714914803216200000
        );
    }

    function testPrice_30days_80vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            18112671799117635000,
            217112671799117600000
        );
    }

    function testPrice_30days_80vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            18669868290461864000,
            213732434909945600000
        );
    }

    function testPrice_30days_80vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            19288253597730915000,
            210102760608610080000
        );
    }

    function testPrice_30days_80vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            90753623058412070000,
            91753623058412190000
        );
    }

    function testPrice_30days_80vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            92549208105734750000,
            89611774725218420000
        );
    }

    function testPrice_30days_80vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            94516656265691270000,
            87331163276570410000
        );
    }

    function testPrice_30days_80vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            91298407818462980000,
            91298407818462980000
        );
    }

    function testPrice_30days_80vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            93100805037332350000,
            89163371656815970000
        );
    }

    function testPrice_30days_80vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            95075615857107660000,
            86890122867986920000
        );
    }

    function testPrice_30days_80vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            91844920602221240000,
            90844920602221300000
        );
    }

    function testPrice_30days_80vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            93654126332206720000,
            88716692951690280000
        );
    }

    function testPrice_30days_80vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            95636295280730790000,
            86450802291609930000
        );
    }

    function testPrice_30days_80vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            231172864671938000000,
            30172864671938015000
        );
    }

    function testPrice_30days_80vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            234148313635278330000,
            29210880254762003000
        );
    }

    function testPrice_30days_80vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            237382237645312670000,
            28196744656191896000
        );
    }

    function testPrice_30days_80vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 0
            }),
            409472817918932600000,
            8472817918932549000
        );
    }

    function testPrice_30days_80vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            413070555253486530000,
            8133121872970136000
        );
    }

    function testPrice_30days_80vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(8e17),
                rate: 1e17
            }),
            416963948662560030000,
            7778455673439268000
        );
    }

    function testPrice_30days_90vol_601_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            1036471894561236500,
            399103647189456250000
        );
    }

    function testPrice_30days_90vol_601_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            1085768751234567800,
            395205875123456780000
        );
    }

    function testPrice_30days_90vol_601_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(601 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            1140057188796296300,
            391005718879629630000
        );
    }

    function testPrice_30days_90vol_801_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            22890493827160494000,
            228904938271604940000
        );
    }

    function testPrice_30days_90vol_801_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            23456790123456789000,
            224567901234567890000
        );
    }

    function testPrice_30days_90vol_801_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(801 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            24074074074074074000,
            220740740740740740000
        );
    }

    function testPrice_30days_90vol_999_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            98765432098765432000,
            99765432098765432000
        );
    }

    function testPrice_30days_90vol_999_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            100987654320987654000,
            97987654320987654000
        );
    }

    function testPrice_30days_90vol_999_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(999 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            103209876543209876000,
            96209876543209876000
        );
    }

    function testPrice_30days_90vol_1000_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            100000000000000000000,
            100000000000000000000
        );
    }

    function testPrice_30days_90vol_1000_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            102222222222222222000,
            98222222222222222000
        );
    }

    function testPrice_30days_90vol_1000_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1000 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            104444444444444444000,
            96444444444444444000
        );
    }

    function testPrice_30days_90vol_1001_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            101234567901234568000,
            99123456790123456800
        );
    }

    function testPrice_30days_90vol_1001_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            103456790123456790000,
            99456790123456790000
        );
    }

    function testPrice_30days_90vol_1001_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1001 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            105679012345679012000,
            96679012345679012000
        );
    }

    function testPrice_30days_90vol_1201_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            246913580246913580000,
            46913580246913580000
        );
    }

    function testPrice_30days_90vol_1201_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            250135802469135802000,
            45135802469135802000
        );
    }

    function testPrice_30days_90vol_1201_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1201 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            253358024691358024000,
            43358024691358024000
        );
    }

    function testPrice_30days_90vol_1401_0rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 0
            }),
            419753086419753086000,
            19753086419753086000
        );
    }

    function testPrice_30days_90vol_1401_48rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: int256(48 * 10**(DECIMALS - 3))
            }),
            423456790123456790000,
            18456790123456790000
        );
    }

    function testPrice_30days_90vol_1401_10rate() public pure {
        verifyPrices(
            IBlackScholes.InputParams({
                spot: uint128(1401 * 10**DECIMALS),
                strike: uint128(1000 * 10**DECIMALS),
                secondsToExpiry: 30 days,
                volatility: uint80(9e17),
                rate: 1e17
            }),
            427160493827160494000,
            17160493827160494000
        );
    }
}