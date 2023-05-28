// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {MMOBatchVote} from "../src/MMOBatchVote.sol";

contract DeployMMOBatchVote is Script {
    function setUp() public {}

    function run() public {
        address mmo = address(0x41d3d86a84c8507A7Bc14F2491ec4d188FA944E7);
        vm.broadcast();
        new MMOBatchVote(mmo);
    }
}
