// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "./SmartAccountContract.sol";

contract TestContract {
    function transferFunds(
        address _account,
        address _token,
        uint256 _amount
    ) public {
        SmartAccountContract smartAccount = SmartAccountContract(_account);

        bytes4 functionSelector = bytes4(
            keccak256("transferFunds(address,uint256)")
        );
        bytes memory data = abi.encode(_token, _amount);
        smartAccount.executeFunction(functionSelector, data);
    }
}
