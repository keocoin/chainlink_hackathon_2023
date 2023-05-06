// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "../interfaces/AAVEPool.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/ISwapRouter.sol";
contract Leverage {
    AAVEPool private aavePool;
    ISwapRouter private swapRouter;

    address lendingPoolAddress = 0x0b913A76beFF3887d35073b8e5530755D60F78C7;
    address uniswapRouterAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    uint24 public constant poolFee = 3000;

    constructor() {
        aavePool = AAVEPool(lendingPoolAddress);
        swapRouter = ISwapRouter(uniswapRouterAddress);
    }

    function leverage(
        address _from,
        uint256 _from_amount,
        address _mid,
        uint256 _mid_amount
    ) public {
        IERC20 from = IERC20(_from);
        require(
            from.approve(lendingPoolAddress, _from_amount),
            "Approval failed"
        );

        aavePool.supply(_from, _from_amount, address(this), 0);
        aavePool.borrow(_mid, _mid_amount, 2, 0, address(this));

        IERC20 mid = IERC20(_mid);
        mid.approve(uniswapRouterAddress, _mid_amount);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: _mid,
                tokenOut: _from,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: _mid_amount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        // The call to `exactInputSingle` executes the swap.
        uint256 amountOut = swapRouter.exactInputSingle(params);

        require(from.approve(lendingPoolAddress, amountOut), "Approval failed");
        aavePool.supply(_from, amountOut, address(this), 0);
    }

    receive() external payable {}
}
