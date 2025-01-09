// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Coin {
    address public minter;
    mapping(address => uint256) public balances;

    event Sent(address from, address to, uint256 amount);

    error insufficientBalance(
        uint256 amountRequested,
        uint256 amountAavailable
    );

    constructor() {
        minter = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == minter);
        _;
    }

    function mint(address receiver, uint256 amount) public onlyOwner {
        balances[receiver] += amount;
    }

    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender]) {
            revert insufficientBalance({
                amountRequested: amount,
                amountAavailable: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
