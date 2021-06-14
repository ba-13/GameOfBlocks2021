// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

contract MetaCoin {
    mapping(address => uint256) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
        balances[tx.origin] = 100000;
    }

    function sendCoin(
        address receiver,
        uint256 amount,
        address sender
    ) public returns (bool sufficient) {
        if (balances[sender] < amount) return false;
        balances[sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(sender, receiver, amount);
        return true;
    }

    function getBalance(address addr) public view returns (uint256) {
        return balances[addr];
    }
}

contract Loan is MetaCoin {
    //Some declarations for the contract.
    mapping(address => uint256) private loans;
    event Request(
        address indexed _from,
        uint256 P,
        uint256 R,
        uint256 T,
        uint256 amt
    );
    address private Owner;
    uint256 private creditor_number = 0;
    mapping(uint256 => address) private creditors;

    //Modifier of being Owner, can be used as a decorator.
    modifier isOwner() {
        require(msg.sender == Owner, "Caller is not the Owner.");
        _;
    }

    constructor() public {
        Owner = msg.sender; // Made the creator of the contract the Owner.
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 z
    ) internal pure returns (uint256) {
        return (x * y) / z;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function getCompoundInterest(
        uint256 principle,
        uint256 rate,
        uint256 time
    ) public pure returns (uint256) {
        while (time != 0) {
            principle = add(principle, mulDiv(rate, principle, 100));
            time -= 1;
        }
        return principle;
    }

    function reqLoan(
        uint256 principle,
        uint256 rate,
        uint256 time
    ) public returns (bool correct) {
        uint256 toPay = getCompoundInterest(principle, rate, time);

        if (toPay < principle) return false;
        if (msg.sender == Owner) return false;

        creditors[creditor_number] = msg.sender;
        creditor_number += 1;

        loans[msg.sender] = toPay;
        emit Request(msg.sender, principle, rate, time, toPay);
        return true;
    }

    function getOwnerBalance() public view returns (uint256) {
        // Used the getBalance function of MetaCoin contract to view the Balance of the contract Owner.
        return MetaCoin.getBalance(Owner);
    }

    function getOwnerAddress() public view returns (address) {
        return Owner; //just to test which of the 10 is the owner.
    }

    function viewDues(address addr) public view isOwner returns (uint256) {
        return loans[addr];
    }

    function settleDues(address addr) public isOwner returns (bool correct) {
        if (MetaCoin.getBalance(getOwnerAddress()) - loans[addr] < 0)
            return false;
        bool done = MetaCoin.sendCoin(addr, loans[addr], Owner);
        if (done) {
            loans[addr] = 0;
            return true;
        } else {
            return false;
        }
    }

    function getMaxAddress() public view isOwner returns (address) {
        uint256 max = 0;
        address maxAddress;
        for (uint256 i = 0; i < creditor_number; i++) {
            if (max < loans[creditors[i]]) maxAddress = creditors[i];
        }
        return maxAddress;
    }
}
