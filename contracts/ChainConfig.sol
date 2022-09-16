// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "./InjectorContextHolder.sol";

contract ChainConfig is InjectorContextHolder, IChainConfig {

    event ActiveValidatorsLengthChanged(uint32 prevValue, uint32 newValue);
    event EpochBlockIntervalChanged(uint32 prevValue, uint32 newValue);
    event MisdemeanorThresholdChanged(uint32 prevValue, uint32 newValue);
    event FelonyThresholdChanged(uint32 prevValue, uint32 newValue);
    event ValidatorJailEpochLengthChanged(uint32 prevValue, uint32 newValue);
    event UndelegatePeriodChanged(uint32 prevValue, uint32 newValue);
    event MinValidatorStakeAmountChanged(uint256 prevValue, uint256 newValue);
    event MinStakingAmountChanged(uint256 prevValue, uint256 newValue);
    event FreeGasAddressAdded(address freeGasAddress);
    event FreeGasAddressRemoved(address freeGasAddress);
    event FreeGasAddressSizeChanged(uint32 prevValue, uint32 newValue);
    event FreeGasAddressAdminChanged(address oldFreeGasAddressAdmin, address newFreeGasAddressAdmin);

    struct ConsensusParams {
        uint32 activeValidatorsLength;
        uint32 epochBlockInterval;
        uint32 misdemeanorThreshold;
        uint32 felonyThreshold;
        uint32 validatorJailEpochLength;
        uint32 undelegatePeriod;
        uint256 minValidatorStakeAmount;
        uint256 minStakingAmount;
    }

    ConsensusParams private _consensusParams;

    address public freeGasAddressAdmin;
    uint32 public freeGasAddressSize;
    address[] private _freeGasAddressList;
    mapping(address => uint256) private _freeGasAddressMap;

    constructor(
        IStaking stakingContract,
        ISlashingIndicator slashingIndicatorContract,
        ISystemReward systemRewardContract,
        IStakingPool stakingPoolContract,
        IGovernance governanceContract,
        IChainConfig chainConfigContract,
        IRuntimeUpgrade runtimeUpgradeContract,
        IDeployerProxy deployerProxyContract
    ) InjectorContextHolder(
        stakingContract,
        slashingIndicatorContract,
        systemRewardContract,
        stakingPoolContract,
        governanceContract,
        chainConfigContract,
        runtimeUpgradeContract,
        deployerProxyContract
    ) {
    }

    function initialize(
        uint32 activeValidatorsLength,
        uint32 epochBlockInterval,
        uint32 misdemeanorThreshold,
        uint32 felonyThreshold,
        uint32 validatorJailEpochLength,
        uint32 undelegatePeriod,
        uint256 minValidatorStakeAmount,
        uint256 minStakingAmount,
        address _freeGasAddressAdmin
    ) external initializer {
        _consensusParams.activeValidatorsLength = activeValidatorsLength;
        emit ActiveValidatorsLengthChanged(0, activeValidatorsLength);
        _consensusParams.epochBlockInterval = epochBlockInterval;
        emit EpochBlockIntervalChanged(0, epochBlockInterval);
        _consensusParams.misdemeanorThreshold = misdemeanorThreshold;
        emit MisdemeanorThresholdChanged(0, misdemeanorThreshold);
        _consensusParams.felonyThreshold = felonyThreshold;
        emit FelonyThresholdChanged(0, felonyThreshold);
        _consensusParams.validatorJailEpochLength = validatorJailEpochLength;
        emit ValidatorJailEpochLengthChanged(0, validatorJailEpochLength);
        _consensusParams.undelegatePeriod = undelegatePeriod;
        emit UndelegatePeriodChanged(0, undelegatePeriod);
        _consensusParams.minValidatorStakeAmount = minValidatorStakeAmount;
        emit MinValidatorStakeAmountChanged(0, minValidatorStakeAmount);
        _consensusParams.minStakingAmount = minStakingAmount;
        emit MinStakingAmountChanged(0, minStakingAmount);
        freeGasAddressSize = 100;
        emit FreeGasAddressSizeChanged(0, 100);
        freeGasAddressAdmin = _freeGasAddressAdmin;
        emit FreeGasAddressAdminChanged(freeGasAddressAdmin, _freeGasAddressAdmin);
    }

    function getActiveValidatorsLength() external view override returns (uint32) {
        return _consensusParams.activeValidatorsLength;
    }

    function setActiveValidatorsLength(uint32 newValue) external override onlyFromGovernance {
        uint32 prevValue = _consensusParams.activeValidatorsLength;
        _consensusParams.activeValidatorsLength = newValue;
        emit ActiveValidatorsLengthChanged(prevValue, newValue);
    }

    function getEpochBlockInterval() external view override returns (uint32) {
        return _consensusParams.epochBlockInterval;
    }

    function setEpochBlockInterval(uint32 newValue) external override onlyFromGovernance {
        uint32 prevValue = _consensusParams.epochBlockInterval;
        _consensusParams.epochBlockInterval = newValue;
        emit EpochBlockIntervalChanged(prevValue, newValue);
    }

    function getMisdemeanorThreshold() external view override returns (uint32) {
        return _consensusParams.misdemeanorThreshold;
    }

    function setMisdemeanorThreshold(uint32 newValue) external override onlyFromGovernance {
        uint32 prevValue = _consensusParams.misdemeanorThreshold;
        _consensusParams.misdemeanorThreshold = newValue;
        emit MisdemeanorThresholdChanged(prevValue, newValue);
    }

    function getFelonyThreshold() external view override returns (uint32) {
        return _consensusParams.felonyThreshold;
    }

    function setFelonyThreshold(uint32 newValue) external override onlyFromGovernance {
        uint32 prevValue = _consensusParams.felonyThreshold;
        _consensusParams.felonyThreshold = newValue;
        emit FelonyThresholdChanged(prevValue, newValue);
    }

    function getValidatorJailEpochLength() external view override returns (uint32) {
        return _consensusParams.validatorJailEpochLength;
    }

    function setValidatorJailEpochLength(uint32 newValue) external override onlyFromGovernance {
        uint32 prevValue = _consensusParams.validatorJailEpochLength;
        _consensusParams.validatorJailEpochLength = newValue;
        emit ValidatorJailEpochLengthChanged(prevValue, newValue);
    }

    function getUndelegatePeriod() external view override returns (uint32) {
        return _consensusParams.undelegatePeriod;
    }

    function setUndelegatePeriod(uint32 newValue) external override onlyFromGovernance {
        uint32 prevValue = _consensusParams.undelegatePeriod;
        _consensusParams.undelegatePeriod = newValue;
        emit UndelegatePeriodChanged(prevValue, newValue);
    }

    function getMinValidatorStakeAmount() external view returns (uint256) {
        return _consensusParams.minValidatorStakeAmount;
    }

    function setMinValidatorStakeAmount(uint256 newValue) external override onlyFromGovernance {
        uint256 prevValue = _consensusParams.minValidatorStakeAmount;
        _consensusParams.minValidatorStakeAmount = newValue;
        emit MinValidatorStakeAmountChanged(prevValue, newValue);
    }

    function getMinStakingAmount() external view returns (uint256) {
        return _consensusParams.minStakingAmount;
    }

    function setMinStakingAmount(uint256 newValue) external override onlyFromGovernance {
        uint256 prevValue = _consensusParams.minStakingAmount;
        _consensusParams.minStakingAmount = newValue;
        emit MinStakingAmountChanged(prevValue, newValue);
    }


    function setFreeGasAddressAdmin(address _freeGasAddressAdmin) external onlyFromGovernance virtual override  {
        _setFreeGasAddressAdmin(_freeGasAddressAdmin);
    }

    function _setFreeGasAddressAdmin(address _freeGasAddressAdmin) internal {
        require(_freeGasAddressAdmin != freeGasAddressAdmin, "Same admin!");
        address temp = freeGasAddressAdmin;
        freeGasAddressAdmin = _freeGasAddressAdmin;
        emit FreeGasAddressAdminChanged(temp, freeGasAddressAdmin);
    }

    function setFreeGasAddressSize(uint32 _freeGasAddressSize) external onlyFromGovernance virtual override  {
        _setFreeGasAddressSize(_freeGasAddressSize);
    }

    function _setFreeGasAddressSize(uint32 _freeGasAddressSize) internal {
        require(freeGasAddressSize != _freeGasAddressSize, "Same size!");
        uint32 temp = freeGasAddressSize;
        freeGasAddressSize = _freeGasAddressSize;
        emit FreeGasAddressSizeChanged(temp, _freeGasAddressSize);
    }

    function addFreeGasAddress(address freeGasAddress) external onlyFromFreeGasAddressAdmin virtual override {
        _addFreeGasAddress(freeGasAddress);
    }

    function _addFreeGasAddress(address freeGasAddress) internal {
        require(_freeGasAddressList.length < freeGasAddressSize, "The freeGasAddressList size reached the limit!");
        require(_freeGasAddressMap[freeGasAddress] == 0, "The address already exist!");
        _freeGasAddressList.push(freeGasAddress);
        _freeGasAddressMap[freeGasAddress] = _freeGasAddressList.length;
        emit FreeGasAddressAdded(freeGasAddress);
    }

    function removeFreeGasAddress(address freeGasAddress) external onlyFromFreeGasAddressAdmin virtual override {
        _removeFreeGasAddress(freeGasAddress);
    }

    function _removeFreeGasAddress(address freeGasAddress) internal {
        uint256 position = _freeGasAddressMap[freeGasAddress];
        // remove freeGasAddress
        if (position > 0) {
            uint256 indexOf = position - 1;
            if (_freeGasAddressList.length > 1 && indexOf != _freeGasAddressList.length - 1) {
                address lastAddress =  _freeGasAddressList[_freeGasAddressList.length - 1];
                _freeGasAddressList[indexOf] = lastAddress;
                _freeGasAddressMap[lastAddress] = indexOf + 1;
            }
            _freeGasAddressList.pop();
            delete _freeGasAddressMap[freeGasAddress];
            emit FreeGasAddressRemoved(freeGasAddress);
        }
    }

    function getFreeGasAddressList() external view returns (address[] memory) {
        return _freeGasAddressList;
    }

    function getSizeOfFreeGasAddressList() external view returns (uint256) {
        return _freeGasAddressList.length;
    }

    function isFreeGasAddress(address freeGasAddress) external view returns (bool) {
        return _freeGasAddressMap[freeGasAddress] != 0;
    }

    modifier onlyFromFreeGasAddressAdmin() virtual {
        require(msg.sender == freeGasAddressAdmin, "change freeGasAddressList: only admin");
        _;
    }
}
