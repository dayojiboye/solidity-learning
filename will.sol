// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Will {
    address owner;
    uint256 fortune;
    bool deceased;

    constructor() payable {
        owner = msg.sender; // represents address that is being called
        fortune = msg.value; // represents how much ether is being sent
        deceased = false;
    }

    // Create modifier so the only person who can call the contract is the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Create modifier so that we only allocate funds if deceased is true
    modifier mustBeDeceased() {
        require(deceased == true);
        _;
    }

    // List of family wallets
    address payable[] familyWallets;

    // Create an object of keys addresses (wallet addresses) and value integers (amounts)
    mapping(address => uint256) inheritance;

    // Set inheritance for each address
    function setInheritance(address payable wallet, uint256 amount)
        public
        onlyOwner
    {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    // Pay each family member based on their wallet address
    function payout() private mustBeDeceased {
        for (uint256 i = 0; i < familyWallets.length; i++) {
            // Transfer the funds from contract address to receiver address
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }

    function setIsDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}
