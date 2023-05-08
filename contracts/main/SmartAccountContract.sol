// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";
import "../interfaces/ILogicRegistryContract.sol";

// Smart account contract with logic actions and asset storage
contract SmartAccountContract {
    address public owner;
    address public logicRegistryAddress;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public blacklist;

    constructor(address _logicRegistryAddress) {
        logicRegistryAddress = _logicRegistryAddress;
        owner = msg.sender;
        whitelist[msg.sender] = true;
    }

    modifier onlyRegisteredLogicContract(address addr) {
        require(
            ILogicRegistryContract(logicRegistryAddress).isContractRegisted(
                addr
            ),
            "Only registered LogicContract can call this function"
        );
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyWhitelist() {
        address sender = msg.sender;
        require(!isBlacklisted(sender), "Address is blacklisted");
        if (!isWhitelisted(sender)) {
            require(
                isRegistered(sender),
                "Address is not allowed to call this function"
            );
        }
        _;
    }

    function isRegistered(address addr) public view returns (bool) {
        return
            ILogicRegistryContract(logicRegistryAddress).isContractRegisted(
                addr
            );
    }

    function isWhitelisted(address addr) public view returns (bool) {
        return whitelist[addr];
    }

    function isBlacklisted(address addr) public view returns (bool) {
        return blacklist[addr];
    }

    function executeFunction(
        address _contractAddr,
        bytes4 _functionSelector,
        bytes calldata _data
    ) external onlyWhitelist {
        (bool success, ) = _contractAddr.call(
            abi.encodePacked(_functionSelector, _data)
        );
        require(success, "Function call failed");
    }

    function withdrawERC20(address _token, uint256 _amount)
        external
        onlyWhitelist
    {
        IERC20 token = IERC20(_token);
        token.approve(address(this), _amount);
        require(
            token.transferFrom(address(this), msg.sender, _amount),
            "Token transfer failed"
        );
    }

    function toggleWhitelist(address _addr) external onlyOwner {
        whitelist[_addr] = !whitelist[_addr];
    }

    function toggleBlacklist(address _addr) external onlyOwner {
        blacklist[_addr] = !blacklist[_addr];
        if (blacklist[_addr]) {
            whitelist[_addr] = false;
        }
    }

    function updateLogicRegistryAddress(address _addr) external onlyOwner {
        logicRegistryAddress = _addr;
    }
}
