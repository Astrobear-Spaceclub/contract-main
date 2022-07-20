// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/AstrobearTakeoff.sol";

contract AstrobearTakeoffTest is Test {
    AstrobearTakeoff nftContract;
    address mainReceiver;

    function setUp() public {
        mainReceiver = vm.addr(1);

        address[] memory payees = new address[](1);
        payees[0] = mainReceiver;
        uint256[] memory shares = new uint256[](1);
        shares[0] = uint256(100);

        nftContract = new AstrobearTakeoff(
            "Astrobear",
            "AST-TAKEOFF",
            payees,
            shares,
            0.05 ether,
            0.075 ether,
            0.1 ether,
            "ipfs://QmbUQHnXWgSgpPke6gcQaqvp2z6yeaHzZRvza7cQ2CiViC/"
        );
    }

    function testSupplies() public {
        assertEq(uint256(1954), nftContract.totalSupply());
    }

    function testSaleNotStartedOrEnded() public {
        vm.expectRevert(abi.encodeWithSignature("SaleNotStarted()"));
        nftContract.mint{value: 0.1 ether}(1);
    }

    function testInvalidPaymentForGenesis() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Genesis);
        vm.expectRevert(abi.encodeWithSignature("PaymentNotCorrect()"));
        nftContract.mint{value: 0.049 ether}(1);
    }

    function testInvalidPaymentForWhitelist() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Whitelist);
        vm.expectRevert(abi.encodeWithSignature("PaymentNotCorrect()"));
        nftContract.mint{value: 0.074 ether}(1);
    }

    function testInvalidPaymentForPublic() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Public);
        vm.expectRevert(abi.encodeWithSignature("PaymentNotCorrect()"));
        nftContract.mint{value: 0.099 ether}(1);
    }

    function testNotPartOfGenesisList() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Genesis);
        vm.expectRevert(abi.encodeWithSignature("AlreadyMintedMaxAmount()"));
        nftContract.mint{value: 0.05 ether}(1);
    }

    function testNotPartOfWhitelist() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Whitelist);
        vm.expectRevert(abi.encodeWithSignature("AlreadyMintedMaxAmount()"));
        nftContract.mint{value: 0.075 ether}(1);
    }

    function testMintOneGenesis() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Genesis);
        address[] memory addresses = new address[](1);
        addresses[0] = address(1);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = uint256(1);
        nftContract.addAddressesToGenesisList(addresses, amounts);

        vm.deal(address(1), 0.05 ether);
        vm.prank(address(1));

        nftContract.mint{value: 0.05 ether}(1);
        assertEq(1, nftContract.balanceOf(address(1)));
    }

    function testMintSeveralGenesis() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Genesis);
        address[] memory addresses = new address[](1);
        addresses[0] = address(1);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = uint256(3);
        nftContract.addAddressesToGenesisList(addresses, amounts);

        vm.deal(address(1), 0.15 ether);
        vm.startPrank(address(1));

        nftContract.mint{value: 0.05 ether}(1);
        assertEq(1, nftContract.balanceOf(address(1)));

        nftContract.mint{value: 0.1 ether}(2);
        assertEq(3, nftContract.balanceOf(address(1)));

        vm.stopPrank();
    }

    function testClaimingOfSculptureAndTokenUriForClaimed() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Public);
        nftContract.setBaseUriClaimed("ipfs://QmbUQHnXWgSgpPke6gcQvpaq2z6yeaHzZRvza7cQ2CiViC/");
        nftContract.mint{value: 0.2 ether}(2);
        nftContract.claimSculpture(1);

        assertEq("ipfs://QmbUQHnXWgSgpPke6gcQvpaq2z6yeaHzZRvza7cQ2CiViC/1", nftContract.tokenURI(1));
    }

    function testClaimingSculptureRevertsForWrongOwner() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Public);
        nftContract.mint{value: 0.2 ether}(2);
        nftContract.claimSculpture(1);

        vm.prank(address(1));
        vm.expectRevert(abi.encodeWithSignature("NotOwnerOfToken()"));
        nftContract.claimSculpture(1);
    }

    function testClaimingSculptureRevertsForAlreadyClaimed() public {
        nftContract.setSaleState(AstrobearTakeoff.SaleState.Public);
        nftContract.mint{value: 0.2 ether}(2);

        nftContract.claimSculpture(1);
        vm.expectRevert(abi.encodeWithSignature("AlreadyClaimedSculpture()"));
        nftContract.claimSculpture(1);
    }

    function testOwnerMint() public {
        nftContract.ownerMint(15);
        nftContract.ownerOf(1954); // first token should start at 1869 after non reserved supply
    }

    function testOwnerMintRevertsOnMaxSupply() public {
        nftContract.ownerMint(15);
        vm.expectRevert(abi.encodeWithSignature("NoSupplyLeft()"));
        nftContract.ownerMint(1);
    }

    function testTokenUriForNotClaimed() public {
        assertEq("ipfs://QmbUQHnXWgSgpPke6gcQaqvp2z6yeaHzZRvza7cQ2CiViC/1", nftContract.tokenURI(1));
    }
}
