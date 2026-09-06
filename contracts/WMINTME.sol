// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title  WMINTME — Wrapped MintMe
/// @notice ERC-20 wrapper for native MINTME coin.
///         Deposit MINTME to receive WMINTME 1:1.
///         Withdraw WMINTME to receive MINTME 1:1.
///         Identical in structure to WETH9, adapted for the MintMe chain.
contract WMINTME {
    string public constant name     = "Wrapped MintMe";
    string public constant symbol   = "WMINTME";
    uint8  public constant decimals = 18;

    // ── Events ────────────────────────────────────────────────────────────────

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Approval(address indexed src, address indexed guy, uint256 wad);

    // ── Storage ───────────────────────────────────────────────────────────────

    mapping(address => uint256)                      public balanceOf;
    mapping(address => mapping(address => uint256))  public allowance;

    // ── Wrap / Unwrap ─────────────────────────────────────────────────────────

    /// @notice Wrap native MINTME → WMINTME. Can also be triggered by sending MINTME directly.
    receive() external payable {
        deposit();
    }

    /// @notice Wrap native MINTME → WMINTME.
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
        emit Transfer(address(0), msg.sender, msg.value);
    }

    /// @notice Unwrap WMINTME → native MINTME.
    /// @param wad Amount of WMINTME to unwrap (in wei).
    function withdraw(uint256 wad) external {
        require(balanceOf[msg.sender] >= wad, "WMINTME: insufficient balance");
        balanceOf[msg.sender] -= wad;
        emit Withdrawal(msg.sender, wad);
        emit Transfer(msg.sender, address(0), wad);
        (bool ok, ) = msg.sender.call{value: wad}("");
        require(ok, "WMINTME: transfer failed");
    }

    // ── ERC-20 ────────────────────────────────────────────────────────────────

    function totalSupply() external view returns (uint256) {
        return address(this).balance;
    }

    function approve(address guy, uint256 wad) external returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
        require(balanceOf[src] >= wad, "WMINTME: insufficient balance");

        if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
            require(allowance[src][msg.sender] >= wad, "WMINTME: insufficient allowance");
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;
        emit Transfer(src, dst, wad);
        return true;
    }
}