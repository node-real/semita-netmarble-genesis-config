// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "./InjectorContextHolder.sol";
import "./TimeLock.sol";

contract Reward is IReward, InjectorContextHolder, TimeLock {

    address constant deadAddress= 0x000000000000000000000000000000000000dEaD;
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

    function initialize(address _owner, uint256 _delay, address _foundationAddress, uint16 _burnRatio, uint16 _releaseRatio) external initializer {
        foundationAddress = _foundationAddress;
        require(_burnRatio <= RATIO_SCALE, "the burnRatio must be no greater than 10000");
        burnRatio = _burnRatio;
        require(_releaseRatio <= RATIO_SCALE, "the releaseRatio must be no greater than 10000");
        releaseRatio = _releaseRatio;
        __TimeLock_init(_owner, _delay);
    }

    modifier onlyThis() {
        require(msg.sender == address(this), "only this");
        _;
    }

    function getFoundationAddress() external view returns (address) {
        return foundationAddress;
    }

    function updateFoundationAddress(address _foundationAddress) public onlyThis {
        address preValue = foundationAddress;
        foundationAddress = _foundationAddress;
        emit UpdateFoundationAddress(preValue, _foundationAddress);
    }

    function queueUpdateFoundationAddress(address _foundationAddress, uint256 eta) external payable onlyAdmin returns (bytes32) {
        return queueTransaction(address(this), msg.value, "updateFoundationAddress(address)", abi.encode(_foundationAddress), eta);
    }

    function cancelUpdateFoundationAddress(address _foundationAddress, uint256 eta) external payable onlyAdmin {
        return cancelTransaction(address(this), msg.value, "updateFoundationAddress(address)", abi.encode(_foundationAddress), eta);
    }

    function executeUpdateFoundationAddress(address _foundationAddress, uint256 eta) external payable onlyAdmin {
        executeTransaction(address(this), msg.value, "updateFoundationAddress(address)", abi.encode(_foundationAddress), eta);
    }

    function getBurnRatio() external view returns(uint16) {
        return burnRatio;
    }

    function updateBurnRatio(uint16 _burnRatio) public onlyThis {
        uint16 preValue = burnRatio;
        require(_burnRatio <= RATIO_SCALE, "the burnRatio must be no greater than 10000");
        burnRatio = _burnRatio;
        emit UpdateBurnRatio(preValue, _burnRatio);
    }

    function queueUpdateBurnRatio(uint16 _burnRatio, uint256 eta) external payable onlyAdmin returns (bytes32) {
        return queueTransaction(address(this), msg.value, "updateBurnRatio(uint16)", abi.encode(_burnRatio), eta);
    }

    function cancelUpdateBurnRatio(uint16 _burnRatio, uint256 eta) external payable onlyAdmin {
        return cancelTransaction(address(this), msg.value, "updateBurnRatio(uint16)", abi.encode(_burnRatio), eta);
    }

    function executeUpdateBurnRatio(uint16 _burnRatio, uint256 eta) external payable onlyAdmin {
        executeTransaction(address(this), msg.value, "updateBurnRatio(uint16)", abi.encode(_burnRatio), eta);
    }

    function getReleaseRatio() external view returns(uint16) {
        return releaseRatio;
    }

    function updateReleaseRatio(uint16 _releaseRatio) public onlyThis {
        uint16 preValue = releaseRatio;
        require(releaseRatio <= RATIO_SCALE, "the releaseRatio must be no greater than 10000");
        releaseRatio = _releaseRatio;
        emit UpdateReleaseRatio(preValue, _releaseRatio);
    }


    function queueUpdateReleaseRatio(uint16 _releaseRatio, uint256 eta) external payable onlyAdmin returns (bytes32) {
        return queueTransaction(address(this), msg.value, "updateReleaseRatio(uint16)", abi.encode(_releaseRatio), eta);
    }

    function cancelUpdateReleaseRatio(uint16 _releaseRatio, uint256 eta) external payable onlyAdmin {
        return cancelTransaction(address(this), msg.value, "updateReleaseRatio(uint16)", abi.encode(_releaseRatio), eta);
    }

    function executeUpdateReleaseRatio(uint16 _releaseRatio, uint256 eta) external payable onlyAdmin {
        executeTransaction(address(this), msg.value, "updateReleaseRatio(uint16)", abi.encode(_releaseRatio), eta);
    }

    function burn() external {
        uint256 balance = address(this).balance;
        uint256 burned = balance * burnRatio / RATIO_SCALE;
        uint256 released = burned * releaseRatio / RATIO_SCALE;

        if (address(_RESERVE_CONTRACT).balance >= released) {
            payable(deadAddress).transfer(burned);
            uint256 unburned = balance - burned;
            payable(foundationAddress).transfer(unburned);
            _RESERVE_CONTRACT.release(foundationAddress, released);
            emit BurnedAndReserveReleased(burned, foundationAddress, unburned + released);
        } else {
            payable(foundationAddress).transfer(balance);
            emit BurnedAndReserveReleased(0, foundationAddress, balance);
        }
    }

    receive() external payable override onlyFromStaking {
        emit Rewarded(msg.sender, msg.value);
    }
}