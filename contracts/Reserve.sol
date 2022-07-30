// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "./InjectorContextHolder.sol";

contract Reserve is IReserve, InjectorContextHolder {

    event Released(address indexed addr, uint256 amount);

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
    ) InjectorContextHolder(
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

    function initialize() external initializer {
    }

    function release(address addr, uint256 amount) external onlyFromReward {
        payable(address(addr)).transfer(amount);
        emit Released(addr, amount);
    }
}