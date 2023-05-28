// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IERC721Receiver} from "./IERC721Receiver.sol";
import {IMoneyMakingOpportunity} from "./IMoneyMakingOpportunity.sol";

contract MMOBatchVote is IERC721Receiver {
    IMoneyMakingOpportunity public immutable MMO;

    constructor(address _mmo) {
        MMO = IMoneyMakingOpportunity(_mmo);
    }

    function onERC721Received(address, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        // Ignored to save gas. Other tokens would likely not match the vote abi and fail
        // to transfer. However, to be safe, don't send non-MMO tokens to this contract.
        // if (msg.sender != address(MMO)) revert NotMMOToken();

        (uint256 start, uint256 end) = abi.decode(data, (uint256, uint256));
        uint256 loopEnd;
        unchecked {
            loopEnd = end + 1;
        }

        for (uint256 i = start; i < loopEnd;) {
            MMO.castVote(tokenId, i, true);

            unchecked {
                ++i;
            }
        }

        MMO.transferFrom(address(this), from, tokenId);

        return this.onERC721Received.selector;
    }
}
