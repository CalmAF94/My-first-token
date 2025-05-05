//SPDX-License-Identifier: MIT
// This contract is another token but made by using the OpenZeppelin library
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This contract is a simple ERC20 token implementation using OpenZeppelin's library

contract OurToken is ERC20 {
    // The iherited contract has a constructor so it needs to be here as well
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
        // The _mint function creates the initial supply of tokens and assigns them to the contract deployer(msg.sender)
        // It is a method of distribution as well
        // The _mint in the constructor prevents anyone to mint tokens after the contract is deployed
    }
}
