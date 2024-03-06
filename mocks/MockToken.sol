// contracts/MockToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MockToken is ERC20  {
    constructor() ERC20("Mock", "MCK") {
        _mint(msg.sender, type(uint32).max); 
        _mint(address(0x10000), type(uint32).max);
        _mint(address(0x20000), type(uint32).max);
        _mint(address(0x30000), type(uint32).max);
    }
}

