pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "openzeppelin-solidity/contracts/AddressUtils.sol";
import "./interfaces/ERC677.sol";

contract ERC677Token is ERC677, DetailedERC20, StandardToken {

    event ContractFallbackCallFailed(address from, address to, uint256 value);

    constructor(string _name, string _symbol, uint8 _decimals)
    public DetailedERC20(_name, _symbol, _decimals) {
        // solhint-disable-previous-line no-empty-blocks
    }


    modifier validRecipient(address _recipient) {
        require(_recipient != address(0) && _recipient != address(this));
        /* solcov ignore next */
        _;
    }

    function transferAndCall(address _to, uint256 _value, bytes _data) external validRecipient(_to) returns (bool) {
        require(superTransfer(_to, _value));
        emit Transfer(msg.sender, _to, _value, _data);

        if (AddressUtils.isContract(_to)) {
            require(contractFallback(msg.sender, _to, _value, _data));
        }
        return true;
    }

    function superTransfer(address _to, uint256 _value) internal returns (bool) {
        return super.transfer(_to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(superTransfer(_to, _value));
        callAfterTransfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(super.transferFrom(_from, _to, _value));
        callAfterTransfer(_from, _to, _value);
        return true;
    }

    function callAfterTransfer(address _from, address _to, uint256 _value) internal {
        if (AddressUtils.isContract(_to) && !contractFallback(_from, _to, _value, new bytes(0))) {
            emit ContractFallbackCallFailed(_from, _to, _value);
        }
    }

    function contractFallback(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
        return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)", _from, _value, _data));
    }

}
