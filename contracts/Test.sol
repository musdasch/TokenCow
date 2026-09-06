// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;


import "./interfaces/IOpenTradeRouter.sol";
import "./interfaces/IERC20.sol";

contract Test {
    address thxTokenAddress;
    IERC20 thxToken;

    address openTradeTokenAdddres;
    IERC20 openTradeToken;

    address openTradeRouterAddress;
    IOpenTradeRouter openTradeRouter;
    
    constructor() {
        thxTokenAddress = 0x7b535379bBAfD9cD12b35D91aDdAbF617Df902B2;
        thxToken = IERC20(thxTokenAddress);

        openTradeTokenAdddres = 0xBe575E593d845502E1eC7211009a73D06861e324;
        openTradeToken = IERC20(openTradeTokenAdddres);

        openTradeRouterAddress = 0xad273E2Db43F2CE235cE7D9B259dd8F1eA497ECC;
        openTradeRouter = IOpenTradeRouter(openTradeRouterAddress);
    }

    function testSwap() public returns (uint256[] memory amounts) {
        uint256 amountIn = 100000000000;
        bool transferSuccess = thxToken.transferFrom(msg.sender, address(this), amountIn);
        require(transferSuccess, "Test: TRANSFER_FROM_FAILED");

        address[] memory path;
        path[0] = thxTokenAddress;
        path[1] = openTradeTokenAdddres;
        
        uint256[] memory swapAmounts = openTradeRouter.getAmountsOut(amountIn, path);

        bool approveSuccess = thxToken.approve(openTradeRouterAddress, swapAmounts[0]);
        require(approveSuccess, "Test: APPROVE_FAILED");

        return openTradeRouter.swapExactTokensForTokens(swapAmounts[0], swapAmounts[1], path, msg.sender, block.timestamp+1000);
    }
}