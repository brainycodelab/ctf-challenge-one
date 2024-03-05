// contracts/MockToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MockToken is ERC20  {
    constructor() ERC20("Mock", "MCK") {
        _mint(msg.sender, type(uint128).max);
    }
}

