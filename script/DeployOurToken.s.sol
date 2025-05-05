// In tokens we wont need a HelperConfig as the contract will be exactly the same no matter the network & there is no special contracts that we need to interacct with

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken ot = new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ot;
        // The vm.startBroadcast() and vm.stopBroadcast() functions are used to start and stop the transaction broadcasting process
    }
}
