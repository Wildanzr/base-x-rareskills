// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.25;

import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error InsufficientBalance(uint256 available, uint256 required);
error InsufficientAllowance(uint256 available, uint256 required);
error AccountError(string message);

contract DepositTrade {
    using SafeERC20 for IERC20;

    address private token;

    event Deposit(address indexed from, uint256 value);

    constructor(address _token) {
        token = _token;
    }

    function getToken() public view returns (address) {
        return token;
    }

    function deposit(uint256 _amount) external {
        if (_amount == 0) {
            revert AccountError("Deposit amount must be greater than 0");
        }
        uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
        if (allowance < _amount) {
            revert InsufficientAllowance(allowance, _amount);
        }
        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
        emit Deposit(msg.sender, _amount);
    }
}
