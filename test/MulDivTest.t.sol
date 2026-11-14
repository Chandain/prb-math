//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { stdError } from "forge-std/src/StdError.sol";
import { mulDiv, PRBMath_MulDiv_Overflow } from "../src/Common.sol";

contract mulDivTest is Test {
    function callMulDiv(uint256 x, uint256 y, uint256 denominator) external pure returns (uint256) {
        return mulDiv(x, y, denominator);
    }

    function test_mulDiv_ReproduceDevisionByZeroPanic() public {
        vm.expectRevert(stdError.divisionError);

        this.callMulDiv(1, 1, 0);
    }

    function test_mulDiv_ReproduceOverflowPanic() public {
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, type(uint256).max, type(uint256).max, 0));

        this.callMulDiv(type(uint256).max, type(uint256).max, 0);
    }
}
