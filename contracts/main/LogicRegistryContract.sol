// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;
import "../interfaces/ILogicRegistryContract.sol";

contract LogicRegistryContract is ILogicRegistryContract {
    mapping(address => bool) logicContractAddresses;

    function setLogicContract(address _logicContractAddress) public {
        logicContractAddresses[_logicContractAddress] = logicContractAddresses[
            _logicContractAddress
        ];
    }

    function isContractRegisted(address _logicContractAddress)
        public
        view
        returns (bool)
    {
        return logicContractAddresses[_logicContractAddress];
    }
}
