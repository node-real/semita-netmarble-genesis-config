// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "../Reward.sol";

contract FakeReward is Reward {

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
    ) Reward(
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

    modifier onlyFromCoinbase() override {
        _;
    }

    modifier onlyFromStaking() override {
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