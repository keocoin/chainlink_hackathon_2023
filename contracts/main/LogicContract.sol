// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import "./interfaces/ISmartAccountContract.sol";

// Logic contract containing the operation logic
contract LogicContract {
    function transferFunds(address _token, uint256 _amount) public {
        ISmartAccountContract _smartAccount = ISmartAccountContract(msg.sender);
        require(_amount > 0, "Invalid amount");
        _smartAccount.withdrawERC20(_token, _amount);
    }
}
