//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { stdError } from "forge-std/src/StdError.sol";
import { mulDiv, PRBMath_MulDiv_Overflow } from "../src/Common.sol";

contract mulDivFuzzTest is Test {
    function callMulDiv(uint256 x, uint256 y, uint256 denominator) external pure returns (uint256) {
        return mulDiv(x, y, denominator);
    }

    function testFuzz_mulDiv_zeroDenominator(uint256 x, uint256 y) public {
        vm.expectRevert(stdError.divisionError);
        this.callMulDiv(x, y, 0);
    }

    function testFuzz_mulDiv_overflow(uint256 _x, uint256 _y) public {
        uint256 x = bound(_x, 2 ** 128, type(uint256).max);
        uint256 y = bound(_y, 2 ** 128, type(uint256).max);

        // The product is at least 2^256, so division by one must overflow uint256.
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, x, y, 1));
        this.callMulDiv(x, y, 1);
    }
}
