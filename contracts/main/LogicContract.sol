// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";
import "../interfaces/ISmartAccountContract.sol";
import "../interfaces/IAAVEPool.sol";
import "../interfaces/ISwapRouter.sol";

contract LogicContract {
    address public lendingPoolAddress =
        0x0b913A76beFF3887d35073b8e5530755D60F78C7;
    address public uniswapRouterAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    uint24 public constant poolFee = 3000;

    function withdrawERC20(
        address _smartAccountAddr,
        address _token,
        uint256 _amount
    ) internal {
        ISmartAccountContract _smartAccount = ISmartAccountContract(
            _smartAccountAddr
        );
        _smartAccount.withdrawERC20(_token, _amount);
    }

    function swapToken(
        address _from,
        address _to,
        uint256 _fromAmount
    ) internal returns (uint256 amountOut) {
        ISwapRouter swapRouter = ISwapRouter(uniswapRouterAddress);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: _from,
                tokenOut: _to,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: _fromAmount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
        return amountOut;
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        //Logic goes here

        uint256 totalAmount = amount + premium;
        IERC20(asset).approve(address(lendingPoolAddress), totalAmount);

        return true;
    }

    function leverage(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        IAAVEPool aavePool = IAAVEPool(lendingPoolAddress);

        aavePool.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    receive() external payable {}
}
