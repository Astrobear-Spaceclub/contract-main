// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/AstrobearTakeoff.sol";
import "../lib/forge-std/src/Script.sol";

contract AstrobearTakeoffScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address[] memory payees = new address[](1);
        payees[0] = 0xfaFe98Db6d7CE5D47ce5D392d3e699eEec566710;
        uint256[] memory shares = new uint256[](1);
        shares[0] = uint256(100);

        AstrobearTakeoff nftContract = new AstrobearTakeoff(
            "Astrobear",
            "ASTROBEAR-TAKEOFF",
            payees,
            shares,
            0.05 ether,
            0.075 ether,
            0.1 ether,
            "ipfs://QmVrbQx6JpPPzoekyoTri2LLWJik5hfhqNjEzwik9T4ndB/"
        );

        nftContract.setBaseUriClaimed("ipfs://QmVMEr94a9YgTCv9r3iKRfZV3oPgvBnEbNzdujM52mPJAb/");

        vm.stopBroadcast();
    }
}
