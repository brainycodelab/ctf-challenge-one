// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CoinBank} from "../src/CoinBank.sol";

contract CoinBankTest is Test {
    CoinBank public cb;
    address owner = address(this);
    address user1 = vm.addr(1);

    function setUp() public {
        cb = new CoinBank();
    }

    function test_access_control() public {
        vm.prank(user1);
        vm.expectRevert("Contract owner only!");
        cb.setTokenBalanceAndAllowance(user1, 1000, 5000);
  
    }

    function test_positive_values() public {
        vm.prank(owner);
        cb.setTokenBalanceAndAllowance(user1, 1000, 5000);
        (int128 balance, int128 allowance) = cb.getTokenBalanceAndAllowance(user1);
        assertEq(balance, 1000);
        assertEq(allowance, 5000);
    }

    function test_negative_values() public {
        vm.prank(owner);
        cb.setTokenBalanceAndAllowance(user1, -6000, 800);
        (int128 balance, int128 allowance) = cb.getTokenBalanceAndAllowance(user1);
        assertEq(balance, -6000);
        assertEq(allowance, 800); 
    }

}
