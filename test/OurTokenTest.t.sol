//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {OurToken} from "../src/OurToken.sol";
import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    //////////////////State Variables//////////////////
    OurToken public ourToken;
    DeployOurToken public deployer;

    // Add addresses for testing
    address za3rora = makeAddr("za3rora");
    address zazo = makeAddr("zazo");
    // Add starting balance:
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(za3rora, STARTING_BALANCE);
    }

    function testZa3roraBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(za3rora));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;
        // za3rora approves zazo to spend tokens on his behalf:
        vm.prank(za3rora); //funding
        ourToken.approve(zazo, initialAllowance); //Approving

        uint256 transferAmount = 500;
        // zazo transfers 500 tokens from za3rora to herself:
        vm.prank(zazo); //spending
        ourToken.transferFrom(za3rora, zazo, transferAmount); //Actually transferring
        // This method is brilliant as it only allows the approved address to spend the tokens on behalf of the owner
        assertEq(ourToken.balanceOf(zazo), transferAmount); //Make sure the transfer was successful
        assertEq(
            ourToken.balanceOf(za3rora),
            STARTING_BALANCE - transferAmount
        ); //Make sure the sender's balance was deducted
    }
}
