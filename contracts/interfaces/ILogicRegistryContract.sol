// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

interface ILogicRegistryContract {
    function setLogicContract(address _logicContractAddress) external;

    function isContractRegisted(address _logicContractAddress)
        external
        view 
        returns (bool);
}
