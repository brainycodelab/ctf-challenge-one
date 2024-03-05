// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CoinBank {
    address owner;
    mapping(address => int256) tokenBalancesAndAllowances;

    constructor() {
        owner = msg.sender;
    }

    function setTokenBalanceAndAllowance(address user, int128 balance, int128 allowance) external {
        require(msg.sender == owner, "Contract owner only!");
        // Pack balance and allowance into an int256 variable
        int256 packedValue = packValues(balance, allowance);

        // Store the packed value in the mapping
        tokenBalancesAndAllowances[user] = packedValue;
    }

    function getTokenBalanceAndAllowance(address user) external view returns (int128 balance, int128 allowance) {
        // Retrieve the packed value from the mapping
        int256 packedValue = tokenBalancesAndAllowances[user];

        // Unpack the values from the int256 variable
        (balance, allowance) = unpackValues(packedValue);
    }

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
