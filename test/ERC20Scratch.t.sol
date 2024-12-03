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

    function test_mint1m() external {
        erc20.mint(address(this), 1_000_000);
        assertEq(erc20.balanceOf(address(this)), 1_000_000, "balance mismatch");
    }

    function testFail_transferInsufficientBalance() external {
        erc20.mint(address(this), 1_000_000);
        erc20.transfer(address(1), 1_000_001);
    }

    function testFail_transferToZeroAddress() external {
        erc20.mint(address(this), 1_000_000);
        erc20.transfer(address(0), 100);
    }

    function test_transfer() external {
        erc20.mint(address(this), 1_000_000);
        erc20.transfer(address(1), 100);
        assertEq(erc20.balanceOf(address(this)), 999_900, "balance mismatch");
        assertEq(erc20.balanceOf(address(1)), 100, "balance mismatch");
    }

    function test_approveAndAllowance() external {
        erc20.mint(address(this), 1_000_000);
        erc20.approve(address(1), 100);
        assertEq(erc20.allowance(address(this), address(1)), 100, "allowance mismatch");
    }

    function testFail_transferFromInsufficientBalance() external {
        erc20.mint(address(this), 1_000_000);
        erc20.approve(address(1), 1_000_000);
        erc20.transferFrom(address(this), address(2), 1_000_001);
    }

    function testFail_transferFromInsufficientAllowance() external {
        erc20.mint(address(this), 1_000_000);
        erc20.approve(address(1), 100);
        erc20.transferFrom(address(this), address(2), 101);
    }

    function testFail_transferFromToZeroAddress() external {
        erc20.mint(address(this), 1_000_000);
        erc20.approve(address(1), 100);
        erc20.transferFrom(address(this), address(0), 100);
    }

    function test_transferFrom() external {
        erc20.mint(address(this), 1_000_000);
        erc20.approve(address(1), 100);
        vm.prank(address(1));
        erc20.transferFrom(address(this), address(2), 100);
        assertEq(erc20.balanceOf(address(this)), 999_900, "balance mismatch");
        assertEq(erc20.balanceOf(address(2)), 100, "balance mismatch");
    }

    function test_mint() external {
        erc20.mint(address(1), 1_000_000);
        assertEq(erc20.totalSupply(), 1_000_000, "total supply mismatch");
        assertEq(erc20.balanceOf(address(1)), 1_000_000, "balance mismatch");
    }
}
