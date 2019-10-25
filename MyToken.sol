pragma solidity ^0.5.10;

contract MyToken {
    mapping(address => uint256) private _balances;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) public {
        _balances[msg.sender] = initialSupply;
        _totalSupply = initialSupply;
        _symbol = tokenSymbol;
        _name = tokenName;
        _decimals = decimalUnits;

    }

    function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }

    function setBalance(address account, uint256 balance) internal {
        _balances[account] = balance;
    }
    
    function transfer(address beneficiary, uint256 amount) public returns (bool){
        _balances[msg.sender] -= amount;
        _balances[beneficiary] += amount;
        return true;
    }

}