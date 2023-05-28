// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {MMOBatchVote} from "../src/MMOBatchVote.sol";
import {IMoneyMakingOpportunity} from "../src/IMoneyMakingOpportunity.sol";

contract CastBatchVote is Script {
    function run() public {
        address sender = vm.envAddress("SENDER");
        IMoneyMakingOpportunity mmo = IMoneyMakingOpportunity(0x41d3d86a84c8507A7Bc14F2491ec4d188FA944E7);
        address batchVote = address(0x05fDf5E06E7de07aD438Eceb87Fc0aAE09848743);
        uint256 tokenId = vm.envUint("TOKEN_ID");

        uint256[] memory votes = new uint256[](10);
        votes[0] = 2;
        votes[1] = 3;
        votes[2] = 4;
        votes[3] = 5;
        votes[4] = 6;
        votes[5] = 7;
        votes[6] = 8;
        votes[7] = 9;
        votes[8] = 10;
        votes[9] = 11;

        bytes memory voteData = abi.encode(votes);

        vm.broadcast(sender);
        mmo.safeTransferFrom(sender, batchVote, tokenId, voteData);
    }
}
