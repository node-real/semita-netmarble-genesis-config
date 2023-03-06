// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "./InjectorContextHolder.sol";
import "./interfaces/IChainConfig.sol";

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
    event EnableDelegateChanged(bool preValue, bool newValue);

   /** FNCY II upgrade Events**/
    event GasPriceChanged(uint256 preValue, uint256 newValue);
    event DistributeRewardsShareChanged(address account, uint16 share);
    event ValidatorRewardsShareChanged(uint16 share);
    event FoundationAddressChanged(address preValue, address newValue);

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
    bool private enableDelegate;

    address public freeGasAddressAdmin;
    uint32 public freeGasAddressSize;
    address[] private _freeGasAddressList;
    mapping(address => uint256) private _freeGasAddressMap;


    /** FNCY II upgrade parameters**/

    uint256 private gasPrice;
    uint16 internal constant SHARE_MIN_VALUE = 0; // 0%
    uint16 internal constant SHARE_MAX_VALUE = 10000; // 100%
    DistributeRewardsShare[] internal _distributeRewardsShares;
    uint16 validatorRewardsShare;
    address private foundationAddress;

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
        require(_freeGasAddressAdmin != address(0), "zero address");
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
        require(_freeGasAddressAdmin != address(0), "zero address");
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

    function getEnableDelegate() external view returns (bool) {
        return enableDelegate;
    }

    function setEnableDelegate(bool newValue) external override onlyFromGovernance {
        bool prevValue = enableDelegate;
        enableDelegate = newValue;
        emit EnableDelegateChanged(prevValue, newValue);
    }

    /**
        - min 1 gwei
        - max 1,200,000 gwei
    */
    function setGasPrice(uint256 newValue) external override onlyFromGovernance {
        require(newValue >= 1000000000 && newValue <= 1200000000000000, "bad value");
        require(gasPrice != newValue, "same value");
        uint256 prevValue = gasPrice;
        gasPrice = newValue;
        emit GasPriceChanged(prevValue, newValue);
    }

    function getGasPrice() external view returns(uint256) {
        return gasPrice;
    }

    function getDistributeRewardsShares() external view override returns (uint16 , DistributeRewardsShare[] memory) {
        return (validatorRewardsShare, _distributeRewardsShares);
    }

    function updateDistributeRewardsShares(uint16 validatorShare, address[] calldata accounts, uint16[] calldata shares) external virtual override onlyFromGovernance {
        _updateDistributeRewardsShares(validatorShare, accounts, shares);
    }

    function _updateDistributeRewardsShares(uint16 validatorShare, address[] calldata accounts, uint16[] calldata shares) internal {
        require(accounts.length == shares.length, "bad length");
        require(accounts.length <= 5, "too many accounts");
        require(validatorShare >= SHARE_MIN_VALUE && validatorShare <= SHARE_MAX_VALUE, "bad validator share distribution");
        validatorRewardsShare = validatorShare;
        emit ValidatorRewardsShareChanged(validatorShare);
        uint16 totalShares = 0;
        uint16 targetShares = SHARE_MAX_VALUE - validatorShare;
        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];
            uint16 share = shares[i];
            require(share > SHARE_MIN_VALUE && share <= SHARE_MAX_VALUE, "bad share distribution");
            if (i >= _distributeRewardsShares.length) {
                _distributeRewardsShares.push(DistributeRewardsShare(account, share));
            } else {
                _distributeRewardsShares[i] = DistributeRewardsShare(account, share);
            }
            emit DistributeRewardsShareChanged(account, share);
            totalShares += share;
        }
        require(totalShares == targetShares, "bad share distribution");
        assembly {
            sstore(_distributeRewardsShares.slot, accounts.length)
        }
    }

    function setFoundationAddress(address newValue) external override onlyFromGovernance {
        require(newValue != address(0x00), "bas address");
        require(foundationAddress != newValue, "same address");
        address prevValue = foundationAddress;
        foundationAddress = newValue;
        emit FoundationAddressChanged(prevValue, newValue);
    }

     function getFoundationAddress() external view override returns (address) {
        return foundationAddress;
    }
   
}
