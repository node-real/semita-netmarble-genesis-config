// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

interface IChainConfig {

    function getActiveValidatorsLength() external view returns (uint32);

    function setActiveValidatorsLength(uint32 newValue) external;

    function getEpochBlockInterval() external view returns (uint32);

    function setEpochBlockInterval(uint32 newValue) external;

    function getMisdemeanorThreshold() external view returns (uint32);

    function setMisdemeanorThreshold(uint32 newValue) external;

    function getFelonyThreshold() external view returns (uint32);

    function setFelonyThreshold(uint32 newValue) external;

    function getValidatorJailEpochLength() external view returns (uint32);

    function setValidatorJailEpochLength(uint32 newValue) external;

    function getUndelegatePeriod() external view returns (uint32);

    function setUndelegatePeriod(uint32 newValue) external;

    function getMinValidatorStakeAmount() external view returns (uint256);

    function setMinValidatorStakeAmount(uint256 newValue) external;

    function getMinStakingAmount() external view returns (uint256);

    function setMinStakingAmount(uint256 newValue) external;

    function setFreeGasAddressAdmin(address freeGasAddressAdminAddress) external;

    function setFreeGasAddressSize(uint32 newFreeGasAddressSize) external;

    function addFreeGasAddress(address freeGasAddress) external;

    function removeFreeGasAddress(address freeGasAddress) external;

    function getFreeGasAddressList() external view returns (address[] memory);

    function isFreeGasAddress(address freeGasAddress) external view returns (bool);

    function getEnableDelegate() external view returns (bool);

    function setEnableDelegate(bool newValue) external;
}