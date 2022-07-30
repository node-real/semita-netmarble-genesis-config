// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

interface IReserve {
    function release(address foundAddr, uint256 amount) external;
}