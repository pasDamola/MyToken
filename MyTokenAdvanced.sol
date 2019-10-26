pragma solidity ^0.5.10;


contract Administrable {
    address private _admin;

    event AdminshipTransferred(address indexed currentAdmin, address indexed newAdmin);

    constructor() internal {
        _admin = msg.sender;
        emit  AdminshipTransferred(address(0), _admin);
    }

    function admin() public view returns (address){
        return _admin;
    }

    modifier onlyAdmin(){
        require(msg.sender == _admin, "Only admin can perform this function");
        _;
    }

    function transferAdminship(address newAdmin) public onlyAdmin {
        emit AdminshipTransferred(_admin, newAdmin);
       _admin = newAdmin;
    }
}


contract MyToken {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) public {
        _balances[msg.sender] = initialSupply;
        _totalSupply = initialSupply;
        _symbol = tokenSymbol;
        _name = tokenName;
        _decimals = decimalUnits;

    }

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimals() public view returns (uint8){
        return _decimals;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

     function setTotalSupply(uint256 totalAmount) internal{
       _totalSupply = totalAmount;
    }

    function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }

    function setBalance(address account, uint256 balance) internal {
        _balances[account] = balance;
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return _allowances[owner][spender];
    }

    function setAllowance(address owner, address spender, uint256 amount) internal{
         _allowances[owner][spender] = amount;
    }
    
    function transfer(address beneficiary, uint256 amount) public returns (bool){
        require(beneficiary != address(0), "Beneficiary address cannot be zero");
        require(_balances[msg.sender] >= amount, "Sender does not have enough balance");
        require(_balances[beneficiary] + amount > _balances[beneficiary], "Addition Overflow!");
        _balances[msg.sender] -= amount;
        _balances[beneficiary] += amount;

        emit Transfer(msg.sender, beneficiary, amount);

        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool success){
      require(spender != address(0), "Spender address cannot be zero");
      _allowances[msg.sender][spender] = amount;
      emit Approval(msg.sender, spender, amount);
      return true;
    }

    function transferFrom(address sender, address beneficiary, uint256 amount) public returns (bool){
        require(sender != address(0), "Sender address cannot be zero");
        require(beneficiary != address(0), "Beneficiary address cannot be zero");
        require(amount <= _allowances[msg.sender][sender], "Beneficiary address cannot be zero");
        require(_balances[sender] >= amount, "Sender does not have enough balance");
        require(_balances[beneficiary] + amount > _balances[beneficiary], "Addition Overflow!");

        _balances[sender] -= amount;
        _allowances[sender][msg.sender] -= amount;
        _balances[beneficiary] += amount;
        emit Transfer(sender, beneficiary, amount);
        return true;
    }

}

contract MyTokenAdvanced is MyToken, Administrable{
    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits, address newAdmin) public
        MyToken(0, tokenName, tokenSymbol, decimalUnits) {
            if(newAdmin != address(0) && newAdmin != msg.sender)
              transferAdminship(newAdmin);
            
            setBalance(admin(), initialSupply);
            setTotalSupply(initialSupply);
        }

        function mintToken(address target, uint256 mintedAmount) public onlyAdmin{
            require(balanceOf(target) + mintedAmount > balanceOf(target), "Addition Overflow");
            require(totalSupply() + mintedAmount > totalSupply(), "Addition Overflow");

            setBalance(target, balanceOf(target) + mintedAmount);
            setTotalSupply(totalSupply() + mintedAmount);
            emit Transfer(address(0), target, mintedAmount);
        }
        
    
}