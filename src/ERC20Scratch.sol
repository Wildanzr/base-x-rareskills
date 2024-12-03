// SPDX-License-Identifier: MIT

pragma solidity >=0.8.25;

contract ERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals = 9;
    uint256 private _totalSupply;

    mapping(address owner => uint256 balance) private _balances;
    mapping(address owner => mapping(address spender => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return _balances[_owner];
    }
}
