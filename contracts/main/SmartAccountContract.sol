// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import "./LogicRegistryContract.sol";
import "./LogicContract.sol";

// Smart account contract with logic actions and asset storage
contract SmartAccountContract {
    LogicRegistryContract public logicRegistryContract;

    constructor(address _logicRegistryContractAddress) {
        logicRegistryContract = LogicRegistryContract(
            _logicRegistryContractAddress
        );
    }

    modifier onlyRegisteredLogicContract() {
        require(
            msg.sender == address(logicContract()),
            "Only registered LogicContract can call this function"
        );
        _;
    }

    function logicContract() public view returns (LogicContract) {
        return LogicContract(logicRegistryContract.logicContractAddress());
    }

    function executeFunction(bytes4 _functionSelector, bytes calldata _data)
        public
    {
        (bool success, ) = address(logicContract()).call(
            abi.encodePacked(_functionSelector, _data)
        );

        if (!success) {
            revert("Function call failed");
        }
    }

    function withdrawERC20(address _token, uint256 _amount)
        public
        onlyRegisteredLogicContract
    {
        IERC20 token = IERC20(_token);
        token.approve(address(this), _amount);
        require(
            token.transferFrom(address(this), msg.sender, _amount),
            "Token transfer failed"
        );
    }
}