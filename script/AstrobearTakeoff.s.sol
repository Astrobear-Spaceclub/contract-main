// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/AstrobearTakeoff.sol";
import "../lib/forge-std/src/Script.sol";

contract AstrobearTakeoffScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address[] memory payees = new address[](1);
        payees[0] = 0x2684c4E13DE9d37Cef81a58f6BaBE596bb7e5a3D;
        uint256[] memory shares = new uint256[](1);
        shares[0] = uint256(100);

        AstrobearTakeoff nftContract = new AstrobearTakeoff(
            "Astrobear",
            "AST-TAKEOFF",
            payees,
            shares,
            0.05 ether,
            0.075 ether,
            0.1 ether,
            "ipfs://QmbUQHnXWgSgpPke6gcQaqvp2z6yeaHzZRvza7cQ2CiViC/"
        );

        vm.stopBroadcast();
    }
}
