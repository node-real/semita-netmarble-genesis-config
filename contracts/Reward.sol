// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "./InjectorContextHolder.sol";

contract Reward is IReward, InjectorContextHolder {

    address constant deadAddress= 0x000000000000000000000000000000000000dEaD;
    address internal owner;
    address internal foundationAddress;

    uint16 constant RATIO_SCALE = 10000;
    uint16 internal burnRatio;
    uint16 internal releaseRatio;

    event UpdateOwner(address preValue, address newValue);
    event UpdateFoundationAddress(address preValue, address newValue);
    event UpdateBurnRatio(uint16 prevValue, uint16 newValue);
    event UpdateReleaseRatio(uint16 prevValue, uint16 newValue);

    event Rewarded(address from, uint256 amount);
    event BurnedAndReserveReleased(uint256 amount, address indexed to, uint256 releaseAmount);

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

    function initialize(address _owner, address _foundationAddress, uint16 _burnRatio, uint16 _releaseRatio) external initializer {
        owner = _owner;
        foundationAddress = _foundationAddress;
        require(_burnRatio <= RATIO_SCALE, "the burnRatio must be no greater than 10000");
        burnRatio = _burnRatio;
        require(_releaseRatio <= RATIO_SCALE, "the releaseRatio must be no greater than 10000");
        releaseRatio = _releaseRatio;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function updateOwner(address _owner) external onlyOwner {
        address preValue = owner;
        owner = _owner;
        emit UpdateOwner(preValue, _owner);
    }

    function getFoundationAddress() external view returns (address) {
        return foundationAddress;
    }

    function updateFoundationAddress(address _foundationAddress) external onlyOwner {
        address preValue = foundationAddress;
        foundationAddress = _foundationAddress;
        emit UpdateFoundationAddress(preValue, _foundationAddress);
    }

    function getBurnRatio() external view returns(uint16) {
        return burnRatio;
    }

    function updateBurnRatio(uint16 _burnRatio) external onlyOwner {
        uint16 preValue = burnRatio;
        require(_burnRatio <= RATIO_SCALE, "the burnRatio must be no greater than 10000");
        burnRatio = _burnRatio;
        emit UpdateBurnRatio(preValue, _burnRatio);
    }

    function getReleaseRatio() external view returns(uint16) {
        return releaseRatio;
    }

    function updateReleaseRatio(uint16 _releaseRatio) external onlyOwner {
        uint16 preValue = releaseRatio;
        require(releaseRatio <= RATIO_SCALE, "the releaseRatio must be no greater than 10000");
        releaseRatio = _releaseRatio;
        emit UpdateReleaseRatio(preValue, _releaseRatio);
    }

    function burn() external {
        uint256 burned = address(this).balance * burnRatio / RATIO_SCALE;
        uint256 unburned = address(this).balance - burned;
        uint256 released = burned * releaseRatio / RATIO_SCALE;

        if (address(_RESERVE_CONTRACT).balance >= released) {
            payable(deadAddress).transfer(burned);
            payable(foundationAddress).transfer(unburned);
            _RESERVE_CONTRACT.release(foundationAddress, released);
            emit BurnedAndReserveReleased(burned, foundationAddress, unburned + released);
        } else {
            payable(deadAddress).transfer(burned-released);
            payable(foundationAddress).transfer(unburned+released);
            emit BurnedAndReserveReleased(burned-released, foundationAddress, unburned + released);
        }
    }

    receive() external payable onlyFromCoinbase {
        emit Rewarded(msg.sender, msg.value);
    }
}