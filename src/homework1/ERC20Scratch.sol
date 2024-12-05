// SPDX-License-Identifier: MIT
// THIS CODE IS FOR LEARNING PURPOSES AND DEMONSTRATES THE BASIC FUNCTIONALITY OF AN ERC20 TOKEN.

pragma solidity >=0.8.25;

error InsufficientBalance(uint256 available, uint256 required);
error InsufficientAllowance(uint256 available, uint256 required);
error AccountError(string message);

contract ERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address private creator;
    address private dead = address(0xdead);

    mapping(address owner => uint256 balance) private _balances;
    mapping(address owner => mapping(address spender => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        if (decimals_ > 18 || decimals_ == 0) {
            revert AccountError("decimals must be between 1 and 18");
        }
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        creator = msg.sender;
    }

    modifier onlyCreator() {
        if (msg.sender != creator) {
            revert AccountError("only creator can call this function");
        }
        _;
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

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        if (_to == address(0)) {
            revert AccountError("cannot transfer to zero address");
        }
        if (_balances[msg.sender] < _amount) {
            revert InsufficientBalance({ available: _balances[msg.sender], required: _amount });
        }

        if (_to == dead) {
            _totalSupply -= _amount;
        }

        _balances[msg.sender] -= _amount;
        _balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        _allowances[msg.sender][_spender] = _amount;

        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return _allowances[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        if (_to == address(0)) {
            revert AccountError("cannot transfer to zero address");
        }
        if (_balances[_from] < _amount) {
            revert InsufficientBalance({ available: _balances[_from], required: _amount });
        }
        if (_allowances[_from][msg.sender] < _amount) {
            revert InsufficientAllowance({ available: _allowances[_from][msg.sender], required: _amount });
        }
        if (_to == dead) {
            _totalSupply -= _amount;
        }

        _balances[_from] -= _amount;
        _balances[_to] += _amount;
        _allowances[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function mint(address _to, uint256 _amount) external onlyCreator {
        if (_to == address(0)) {
            revert AccountError("cannot mint to zero address");
        }
        if (_to == dead) {
            revert AccountError("cannot mint to dead address");
        }
        _totalSupply += _amount;
        _balances[_to] += _amount;

        emit Transfer(address(0), _to, _amount);
    }
}
