// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "../interfaces/ISmartAccountContract.sol";

contract TestContract {
    function testLeverage(
        address _logicAddr,
        address _account,
        address _from,
        uint256 _amount
    ) public {
        ISmartAccountContract smartAccount = ISmartAccountContract(_account);

        bytes4 functionSelector = bytes4(
            keccak256("leverage(address,uint256)")
        );
        bytes memory data = abi.encode(_from, _amount);
        smartAccount.executeFunction(_logicAddr, functionSelector, data);
    }
}
