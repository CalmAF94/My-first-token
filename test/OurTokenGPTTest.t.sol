// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
    }

    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        // Here we r actually telling foundry to expect revert as we will try to mint 1 token using this test contract (address(this)):
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    ////////////////////////////////////////////GPT started here//////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////
    //These 3 tests arent working:
    // testTransferTokens --> insuffiecent funds
    // testTransferFromWithApproval --> insuffiecent funds
    // testTransferEmitsEvent --> logs dont match
    // i just skipped them for now
    ///////////////////////////////////////////////////////////////////////////////////////
    function testTransferTokens() public {
        //This test ensures seccessful transfer of tokens
        address recipient = address(1); //Creating a recipient address
        uint256 amount = 100; //Specifying the amount of tokens to transfer

        ourToken.transfer(recipient, amount); //Transfer the amount
        assertEq(ourToken.balanceOf(recipient), amount); //Checking the balance of the recipient
        assertEq(
            ourToken.balanceOf(address(this)),
            deployer.INITIAL_SUPPLY() - amount //INITIAL_SUPPLY from DeployOurToken.s.sol was 1000
        ); //Checking the amount was deducted from the INITIAL_SUPPLY
    }

    function testTransferInsufficientBalanceReverts() public {
        address attacker = address(2); // Creating the address
        vm.prank(attacker); // attacker has 0 tokens as we didnt give him any
        vm.expectRevert(); // Telling foundry to expect revert
        ourToken.transfer(address(3), 1000); // As we didnt give the address any tokens, the transfer will revert
    }

    function testApproveAndAllowance() public {
        address spender = address(1); // Creating a spender address
        uint256 amount = 500; // Specifying the amount of tokens to approve
        bool success = ourToken.approve(spender, amount); // Approving the spender to spend the tokens on behalf of the owner

        assertTrue(success); // Makes sure the previous boolean returns success
        assertEq(ourToken.allowance(address(this), spender), amount); // Makes sure the allowance from (address(this) or msg.sender went to spender
    }

    function testTransferFromWithApproval() public {
        address owner = address(this);
        address spender = address(1); // This is the address we r allowing to move tokens on our behalf
        address recipient = address(2);
        uint256 amount = 200;

        ourToken.approve(spender, amount); // This sets an allowance of 200 tokens for spender to spend from owner's account.

        vm.prank(spender); // makes the next call appear as if it's being made by spender.
        ourToken.transferFrom(owner, recipient, amount); // This moves 200 tokens from the owner's balance to the recipient.

        assertEq(ourToken.balanceOf(recipient), amount); // Make sure the recipient got the tokens
        assertEq(ourToken.allowance(owner, spender), 0); // This checks that the spender’s allowance was reduced to zero, since they used all 200 tokens in a single transferFrom.
    }

    function testTransferFromWithoutApprovalReverts() public {
        // The whole purpose of this test is to make sure that no tokens can be transferred from an address without the approval of the owner
        address spender = address(1);
        address recipient = address(2);

        vm.prank(spender);
        vm.expectRevert();
        ourToken.transferFrom(address(this), recipient, 100); //TRying to transfer 100 tokens from the owner by spender without the approval
    }

    function testTransferFromInsufficientBalanceReverts() public {
        // This test ensures that transferFrom reverts if the owner does not have enough balance even if the spender has approval
        address owner = address(3); // Not address(this) as we r not giving it any tokens
        address spender = address(1); // Trying to transfer tje tokens while owner has no tokens
        uint256 amount = 100;
        // Owner approving spender to spend 100 tokens on his behalf eventhough he has 0 tokens:
        vm.startPrank(owner);
        OurToken token = OurToken(address(ourToken));
        token.approve(spender, amount);
        vm.stopPrank();
        // Spender trying to transfer 100 tokens from owner to address(2) NOT address(this): so this should revert:
        vm.prank(spender);
        vm.expectRevert();
        token.transferFrom(owner, address(2), amount);
    }

    function testApprovalEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Approval(address(this), address(1), 123);
        ourToken.approve(address(1), 123);
    }

    function testTransferEmitsEvent() public {
        address recipient = address(2);
        uint256 amount = 50;

        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), address(2), amount);
        ourToken.transfer(recipient, amount);
    }
}
