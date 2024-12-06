// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.25;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";
import { CNotBasedRewarder, CNotBasedToken } from "../../src/homework2/CorrectNotBasedRewarder.sol";

contract NotBasedRewarderTest is Test {
    CNotBasedToken internal rewardToken;
    CNotBasedToken internal depositToken;
    CNotBasedRewarder internal rewarder;

    function setUp() public virtual {
        rewardToken = new CNotBasedToken(address(this));
        depositToken = new CNotBasedToken(address(this));
        rewarder = new CNotBasedRewarder(rewardToken, depositToken);
    }

    function testFail_unableToWithdrawBecauseDepositTokenIsPaused() external {
        depositToken.transfer(address(1), 1000e18);

        vm.startPrank(address(1));
        depositToken.approve(address(rewarder), 1000e18);
        rewarder.deposit(1000e18);
        assertEq(depositToken.balanceOf(address(1)), 0, "balance mismatch");
        assertEq(depositToken.balanceOf(address(rewarder)), 1000e18, "balance mismatch");
        vm.stopPrank();

        depositToken.pause();

        vm.startPrank(address(1));
        rewarder.withdraw(10e18);
        vm.stopPrank();
    }

    function testFail_unableToWithdrawBecauseContractDoesntHaveEnoughRewardToken() external {
        depositToken.transfer(address(1), 1000e18);

        vm.startPrank(address(1));
        depositToken.approve(address(rewarder), 1000e18);
        rewarder.deposit(1000e18);
        assertEq(depositToken.balanceOf(address(1)), 0, "balance mismatch");
        assertEq(depositToken.balanceOf(address(rewarder)), 1000e18, "balance mismatch");
        vm.stopPrank();

        depositToken.pause();

        vm.warp(block.timestamp + 25 hours);
        vm.startPrank(address(1));
        rewarder.withdraw(10e18);
        vm.stopPrank();
    }
}
