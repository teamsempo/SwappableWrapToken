pragma solidity ^0.5.0;

interface IUpgradeabilityOwnerStorage {
    function upgradeabilityOwner() external view returns (address);
}
