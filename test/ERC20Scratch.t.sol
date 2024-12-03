// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";
import { ERC20 } from "../src/ERC20Scratch.sol";

contract ERC20Test is Test {
    ERC20 internal erc20;

    function setUp() public virtual {
        erc20 = new ERC20("Meoww", "MEOW");
    }

    function test_getName() external view {
        assertEq(erc20.name(), "Meoww", "name mismatch");
    }

    function test_getSymbol() external view {
        assertEq(erc20.symbol(), "MEOW", "symbol mismatch");
    }

    function test_getDecimals() external view {
        assertEq(erc20.decimals(), 9, "decimals mismatch");
    }

    function test_getInitialTotalSupply() external view {
        assertEq(erc20.totalSupply(), 0, "total supply mismatch");
    }

    function test_getBalanceZeroAddress() external view {
        assertEq(erc20.balanceOf(address(0)), 0, "balance mismatch");
    }
}
