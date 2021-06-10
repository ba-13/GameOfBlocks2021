// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

/*
This is just a simple example of a coin-like contract.
It is not standards compatible and cannot be expected to talk to other
coin/token contracts. If you want to create a standards-compliant
token, see: https://github.com/ConsenSys/Tokens. Cheers!
*/

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

    //Modifier of being Owner, can be used as a decorator.
    modifier isOwner() {
        require(msg.sender == Owner, "Caller is not the Owner."); // Implements a modifier to allow only the owner of the contract to use specific functions
        _; // Placeholder for the function this modifier is used in.
    }

    constructor() public {
        Owner = msg.sender; // Made the creator of the contract the Owner.
    }

    // Fill up the following function definitions and also try to justify why some functions are pure and some are view and some are none, in your README.md

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
        /*
    	Anyone should be able to use this function to calculate the amount of Compound interest for given P, R, T
        Solidity does not have a good support for fixed point numbers so we input the rate as a uint
        A common way to perform division to calculate such percentages is mentioned here as references: 
        https://medium.com/coinmonks/math-in-solidity-part-4-compound-interest-512d9e13041b
        https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
        */
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
        /*
        A creditor uses this function to request the Owner to settle his loan, and the amount to settle is calculated using the inputs.
        Also emits the Request event after succesfully adding to the mapping, and return true. 
        Returns false if adding to the mapping failed (maybe the user entered a float rate, there were overflows and toPay comes to be lesser than principle, etc.
        */
        if (toPay < principle) return false;
        if (msg.sender == Owner) return false;
        loans[msg.sender] = toPay;
        emit Request(msg.sender, principle, rate, time, toPay);
        return true;
    }

    function getOwnerBalance() public view returns (uint256) {
        // Used the getBalance function of MetaCoin contract to view the Balance of the contract Owner.
        return MetaCoin.getBalance(Owner);
    }

    /*
    function getOwnerAddress() public view returns (address) {
        return Owner; //just to test which of the 10 is the owner.
    }

    	*/

    /*
    Implementing viewDues and settleDues which allow *ONLY* the owner to *view* and *settle* his loans respectively. 
    They take in the address of a creditor as arguments. viewDues returns a uint256 corresponding to the due amount, and does not modify any state variables. settleDues returns a bool, true if the dues were settled and false otherwise. Remember to set the the pending loan to 0 after settling the dues.
    Used sendCoin function of MetaCoin contract to send the coins required for settling the dues.
    */
    function viewDues(address addr) public view isOwner returns (uint256) {
        // require(addr != Owner, "Use getOwnerBalance to know that.");
        return loans[addr];
    }

    function settleDues(address addr) public isOwner returns (bool correct) {
        // require(addr != Owner, "Can't repay yourself, can you?");
        if (MetaCoin.getOwnerBalance() - loans[addr] < 0) return false;
        bool done = MetaCoin.sendCoin(addr, loans[addr], Owner);
        if (done) {
            loans[addr] = 0;
            return true;
        } else {
            return false;
        }
    }
}
