pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./interfaces/ERC677.sol";

contract ERC677Token is ERC20, ERC20Detailed, ERC677 {

    event ContractFallbackCallFailed(address from, address to, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals)
    public ERC20Detailed(_name, _symbol, _decimals) {
        // solhint-disable-previous-line no-empty-blocks
    }


    modifier validRecipient(address _recipient) {
        require(_recipient != address(0) && _recipient != address(this));
        /* solcov ignore next */
        _;
    }

    function transferAndCall(address _to, uint256 _value, bytes calldata _data) external validRecipient(_to) returns (bool) {
        require(superTransfer(_to, _value));

        if (Address.isContract(_to)) {
            require(contractFallback(msg.sender, _to, _value, _data));
        }
        return true;
    }

    function superTransfer(address _to, uint256 _value) internal returns (bool) {
        return super.transfer(_to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(superTransfer(_to, _value));
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(super.transferFrom(_from, _to, _value));
        return true;
    }

    function contractFallback(address _from, address _to, uint256 _value, bytes memory _data) private returns (bool) {
        (bool success, ) = _to.call(
            abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)", _from, _value, _data));

        return success;
    }

}
