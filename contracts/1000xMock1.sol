// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract OpenTradeTokenMock is ERC20, ERC20Burnable, Ownable {
    constructor(address initialOwner)
        ERC20("OpenTrade Token Mock", "TRADE")
        Ownable(initialOwner)
    {}

    function decimals() public pure override returns (uint8) {
        return 12;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}