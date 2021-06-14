// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract maso {
    string public constant name = "MasoCoin";
    string public constant symbol = "MASO";
    uint8 public constant decimals = 10;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );

    uint256 totalSupply_ = 1_000_000;

    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }

    function transfer(address reciever, uint256 num) public returns (bool) {
        require(num <= balances[msg.sender], "Not enough balance.");
        balances[msg.sender] = sub(balances[msg.sender], num);
        balances[reciever] = add(balances[reciever], num);
        emit Transfer(msg.sender, reciever, num);
        return true;
    }

    function approve(address delegate, uint256 num) public returns (bool) {
        allowed[msg.sender][delegate] = num;
        emit Approval(msg.sender, delegate, num);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 num
    ) public returns (bool) {
        require(num <= balances[owner], "Not enough credits.");
        require(num <= allowed[owner][msg.sender]);

        balances[owner] = sub(balances[owner], num);
        allowed[owner][msg.sender] = sub(allowed[owner][msg.sender], num);
        balances[buyer] = add(balances[buyer], num);
        emit Transfer(owner, buyer, num);
        return true;
    }
}
