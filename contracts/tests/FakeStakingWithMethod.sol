// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "../Staking.sol";

contract FakeStakingWithMethod is Staking {

    constructor(
        IStaking stakingContract,
        ISlashingIndicator slashingIndicatorContract,
        ISystemReward systemRewardContract,
        IStakingPool stakingPoolContract,
        IGovernance governanceContract,
        IChainConfig chainConfigContract,
        IRuntimeUpgrade runtimeUpgradeContract,
        IDeployerProxy deployerProxyContract,
        IReward rewardContract,
        IReserve reserveContract
    ) Staking(
        stakingContract,
        slashingIndicatorContract,
        systemRewardContract,
        stakingPoolContract,
        governanceContract,
        chainConfigContract,
        runtimeUpgradeContract,
        deployerProxyContract,
        rewardContract,
        reserveContract
    ) {
    }

    function thisIsMethod() external pure returns (uint256) {
        return 0x7b;
    }

    modifier onlyFromCoinbase() override {
        _;
    }

    modifier onlyFromSlashingIndicator() override {
        _;
    }

    modifier onlyFromGovernance() override {
        _;
    }

    modifier onlyBlock(uint64 /*blockNumber*/) override {
        _;
    }

    modifier onlyFromReward() override {
        _;
    }
}