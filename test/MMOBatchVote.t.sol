// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {MMOBatchVote} from "../src/MMOBatchVote.sol";
import {MoneyMakingOpportunity} from "../src/reference/MoneyMakingOpportunity.sol";

contract MMOBatchVoteTest is Test {
    MoneyMakingOpportunity mmo = new MoneyMakingOpportunity();
    MMOBatchVote batchVote = new MMOBatchVote(address(mmo));

    uint256 constant tokenCount = 10;

    function setUp() public {
        for (uint256 i = 0; i < tokenCount; i++) {
            address actor = makeAddress(i);
            vm.deal(actor, 0.03 ether);
            vm.prank(actor);
            (bool success,) = address(mmo).call{value: 0.03 ether}("");
            require(success, "MMO: failed to transfer");
        }

        address uriContract = address(0);
        mmo.unlock(uriContract);

        for (uint256 i = 0; i < tokenCount; i++) {
            address actor = makeAddress(i);
            vm.prank(actor);
            mmo.claim();
        }
    }

    function testDeploy() public {
        new MMOBatchVote(address(0));
    }

    function testVote() public {
        assertEq(mmo.votes(1, 1), false);

        uint256[] memory votes = new uint256[](1);
        votes[0] = 1;
        bytes memory data = abi.encode(votes);

        address actor = makeAddress(0);
        vm.prank(actor);
        mmo.safeTransferFrom(actor, address(batchVote), 1, data);

        assertEq(mmo.votes(1, 1), true);
        assertEq(mmo.ownerOf(1), actor);
    }

    function testBatchVote() public {
        assertEq(mmo.votes(1, 1), false);
        assertEq(mmo.votes(1, 2), false);

        uint256[] memory votes = new uint256[](2);
        votes[0] = 1;
        votes[1] = 2;
        bytes memory data = abi.encode(votes);

        address actor = makeAddress(0);
        vm.prank(actor);
        mmo.safeTransferFrom(actor, address(batchVote), 1, data);

        assertEq(mmo.votes(1, 1), true);
        assertEq(mmo.votes(1, 2), true);
        assertEq(mmo.ownerOf(1), actor);
    }

    // Helpers

    function makeAddress(uint256 i) private returns (address) {
        return makeAddr(uint256ToString(i));
    }

    bytes16 private constant _SYMBOLS = "0123456789abcdef";

    // SPDX-License-Identifier: MIT
    // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
    function uint256ToString(uint256 value) private pure returns (string memory) {
        unchecked {
            uint256 length = log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    // SPDX-License-Identifier: MIT
    // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
    function log10(uint256 value) private pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }
}
