// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CoinBank} from "../src/CoinBank.sol";
import {MockToken} from "../mocks/MockToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoinBankTest is Test {
    CoinBank public cb;
    IERC20 public token;
    address owner = address(this);
    address user1 = vm.addr(1);

    function setUp() public {
        token = new MockToken();
        cb = new CoinBank(address(token));
    }

    function test_only_owner_can_increase_allowance() public {
        vm.prank(user1);
        vm.expectRevert("Contract owner only!");
        cb.increaseTokenAllowance(user1, 1000, true);
  
    }

    function test_deposit_increase_user_balance() public {
        token.transfer(user1, 100000);
        vm.startPrank(user1);
        (, int128 before_balance) = cb.getTokenBalanceAndAllowance(user1);
        assertEq(before_balance, 0);
        token.approve(address(cb), 1000);
        cb.deposit(1000);
        (, int128 after_balance) = cb.getTokenBalanceAndAllowance(user1);
        assertEq(after_balance, 1000);
    }

    

}
