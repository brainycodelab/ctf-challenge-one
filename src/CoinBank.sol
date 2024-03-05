// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {IERC20} from "./interfaces/IERC20.sol";

contract CoinBank {
    address public owner;
    IERC20 public token;
    mapping(address => int256) tokenAllowancesAndBalances;

    constructor(address _token) {
        owner = msg.sender;
        token = IERC20(_token);
    }

    function increaseTokenAllowance(address user, int128 amount, bool increment) external {
        require(msg.sender == owner, "Contract owner only!");
        
        //retrieve current allowance
        (int128 allowance, int128 balance) = getTokenBalanceAndAllowance(user);
        if(increment){
            //add increment to previous allowance
            allowance += amount;
        }else {
            //decrement allowance
            allowance -= amount;
        }
       
        // Pack balance and allowance into an int256 variable
        int256 packedValue = packValues(allowance, balance);

        // Store the packed value in the mapping
        tokenAllowancesAndBalances[user] = packedValue;
    }

    function deposit(int256 amount) external {
        require(amount > 0);
        token.transferFrom(msg.sender, address(this), uint256(amount));

        (int128 allowance, int128 balance) = getTokenBalanceAndAllowance(msg.sender);
   
        balance += int128(amount);
       
        // Pack balance and allowance into an int256 variable
        int256 packedValue = packValues(allowance, balance);

        // Store the packed value in the mapping
        tokenAllowancesAndBalances[msg.sender] = packedValue;

    }

    function withdraw(int256 amount, address receiver) external {
        require(amount > 0, "amount must be greater than zero");
        require(address(receiver) != address(0), "receiver cannot be null address");
        require(token.balanceOf(address(this)) >= uint256(amount), "insufficient balance in contract");
        (int128 allowance, int128 balance) = getTokenBalanceAndAllowance(msg.sender);
        int256 withdrawable = allowance + balance;
        require(amount <= withdrawable, "insufficient user balance");
        token.transfer(receiver, uint256(amount));
        balance -= int128(amount);
        int256 packedValue = packValues(allowance, balance);

        // Store the packed value in the mapping
        tokenAllowancesAndBalances[msg.sender] = packedValue;
    }

    function getTokenBalanceAndAllowance(address user) public view returns (int128 allowance, int128 balance) {
        // Retrieve the packed value from the mapping
        int256 packedValue = tokenAllowancesAndBalances[user];

        // Unpack the values from the int256 variable
        (allowance, balance) = unpackValues(packedValue);
    }

    
    /* ***********INTERNAL FUNCTIONS**********/

    // Helper function to pack two int128 values into an int256 variable
    function packValues(int128 value1, int128 value2) internal pure returns (int256) {
        // Use bitwise OR to pack the values
        return (int256(value1) << 128) | int256(int128(value2));
    }

    // Helper function to unpack two int128 values from an int256 variable
    function unpackValues(int256 packedValue) internal pure returns (int128, int128) {
        // Use bitwise shift and masking to unpack the values
        int128 value1 = int128(packedValue >> 128);
        int128 value2 = int128(int128(packedValue));

        return (value1, value2);
    }
}
