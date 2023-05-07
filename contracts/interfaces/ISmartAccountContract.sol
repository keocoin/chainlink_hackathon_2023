// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

// Smart account contract with logic actions and asset storage
interface ISmartAccountContract {
    function withdrawERC20(address _token, uint256 _amount) external;
}
