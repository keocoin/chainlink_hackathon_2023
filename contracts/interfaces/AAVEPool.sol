// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

interface AAVEPool {
    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external;

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external;
}
