// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {CoinBank} from "../CoinBank.sol";
import {MockToken} from "../../mocks/MockToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenDeployer{
    IERC20 token;
    constructor() {
        token = new MockToken();
    }
    function t() public returns(address) {
        token.transfer(msg.sender, token.balanceOf(address(this)));
        return address(token);
    }
}

contract TestCoinBank is CoinBank(new TokenDeployer().t()) {

    function test_user_withdrawalable_doesnt_increase_after_withdraw(uint256 amount) public {
        (int128 allowance, int128 balance) = getTokenBalanceAndAllowance(msg.sender);
        int256 withdrawable_before = allowance + balance;
        this.withdraw(int256(amount), msg.sender);
        (int128 _allowance, int128 _balance) = getTokenBalanceAndAllowance(msg.sender);
        int256 withdrawable_after = _allowance + _balance;
        assert(withdrawable_after <= withdrawable_before);
    }
}