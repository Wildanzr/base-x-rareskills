// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.25;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";
import { DepositTrade } from "../../src/homework1/DepositTrade.sol";
import { ERC20 } from "../../src/homework1/ERC20Scratch.sol";

contract DepositTradeTest is Test {
    DepositTrade internal depositTrade;
    ERC20 internal token;

    function setUp() public virtual {
        token = new ERC20("Meoww", "MEOW", 9);
        depositTrade = new DepositTrade(address(token));

        token.mint(address(this), 1_000_000);
    }

    function test_getToken() external view {
        assertEq(depositTrade.getToken(), address(token), "token mismatch");
    }

    function testFail_depositZero() external {
        depositTrade.deposit(0);
    }

    function testFail_depositInsufficientAllowance() external {
        depositTrade.deposit(1_000_001);
    }

    function testFail_depositInsufficientBalance() external {
        token.approve(address(depositTrade), 10_000_000);
        depositTrade.deposit(1_000_001);
    }

    function test_deposit1m() external {
        token.approve(address(depositTrade), 1_000_000);
        depositTrade.deposit(1_000_000);
        assertEq(token.balanceOf(address(depositTrade)), 1_000_000, "balance mismatch");
        assertEq(token.balanceOf(address(this)), 0, "balance mismatch");
    }
}
