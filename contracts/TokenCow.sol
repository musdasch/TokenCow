// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

import "./interfaces/IOpenTradeRouter.sol";

contract TokenCow is ERC721, ERC721Burnable {
    uint256 private _nextTokenId;

    constructor() ERC721("TokenCow", "TCOW") {}
    

    function safeMint(address to) public returns (uint256)
    {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        return tokenId;
    }

    function burn(uint256 tokenId) public override  {
        ERC721Burnable.burn(tokenId);
    }
}