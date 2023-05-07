// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

// Registry contract to store LogicContract address
contract LogicRegistryContract {
    address public logicContractAddress;

    function setLogicContract(address _logicContractAddress) public {
        logicContractAddress = _logicContractAddress;
    }
}