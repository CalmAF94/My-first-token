//SPDX-License-Identifier: MIT
//This contract follows the ERC20 standards for us to create our own token... :D
//Follow the standards found in Ethereum Improvement Proposals (EIP) & ERC20

pragma solidity ^0.8.18;

contract ManualToken {
    //We gonna need a mapping to link the address to the balance
    mapping(address => uint256) private s_balances;

    function name() public pure returns (string memory) {
        return "ManualToken";
    }

    //Another methods to write the name and symbol of ur token:
    // string public name = "ManualToken";
    // string public symbol = "MTK";

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    //As foundry doesnt know decimals this tells it to use 18 decimals
    //This is the standard for most tokens
    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        //////////////////////Function Breakdown//////////////////////
        // Parameters:
        // _to: The destination address to receive the tokens
        // _amount: The number of tokens to transfer
        // State Variables Used:
        // s_balances: A mapping storing token balances for addresses
        // balanceOf(): A function returning current balance
        uint256 previousBalances = s_balances[msg.sender] + s_balances[_to]; //This stores the combined balance of sender and receiver before transfer recording the initial state...
        // The upcoming two lines perform the actual token transfer by subtracting from sender and adding to recipient then updates the balances:
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        // This verifies that the total amount of tokens hasn't changed during the transfer which is a very important security check:
        assert(balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
        //Same as: require (balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
    }
}
