// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.25;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";
import { NotBasedRewarder, NotBasedToken } from "../../src/homework2/NotBasedRewarder.sol";

contract NotBasedRewarderTest is Test {
    NotBasedToken internal rewardToken;
    NotBasedToken internal depositToken;
    NotBasedRewarder internal rewarder;

    function setUp() public virtual {
        rewardToken = new NotBasedToken(address(this));
        depositToken = new NotBasedToken(address(this));
        rewarder = new NotBasedRewarder(rewardToken, depositToken);
    }

    function testFail_unableToWithdrawBecauseRewardTokenIsDepositedButDepositTokenIsNot() external {
        rewardToken.approve(address(rewarder), 1000e18);
        rewarder.deposit(100e18);
        rewarder.withdraw(10e18);
    }

    function testFail_unableToWithdrawBecauseDepositTokenIsPaused() external {
        // To make it works, need to manual transfer some depositToken to rewarder
        rewardToken.transfer(address(1), 1000e18);
        depositToken.transfer(address(1), 1000e18);
        depositToken.transfer(address(rewarder), 1000e18);

        vm.startPrank(address(1));
        rewardToken.approve(address(rewarder), 1000e18);
        rewarder.deposit(100e18);
        assertEq(rewardToken.balanceOf(address(rewarder)), 100e18, "balance mismatch");
        assertEq(rewardToken.balanceOf(address(1)), 900e18, "balance mismatch");
        vm.stopPrank();

        depositToken.pause();

        vm.startPrank(address(1));
        rewarder.withdraw(10e18);
        vm.stopPrank();
    }
}
