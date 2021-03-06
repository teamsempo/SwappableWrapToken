pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

/**
 * @title An implementation of ERC20 with the same interface as the Compound project's testnet tokens (mainly DAI)
 * @dev This contract can be deployed or the interface can be used to communicate with Compound's ERC20 tokens.  Note:
 * this token should never be used to store real value since it allows permissionless minting.
 */
contract TestnetERC20 is MintableToken {

    string public name;
    string public symbol;
    uint8 public decimals; // solhint-disable-line const-name-snakecase

    constructor(string _name, string _symbol, uint8 _decimals)
    public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /**
     * @notice Mints value tokens to the owner address.
     */
    function allocateTo(address _owner, uint value) external {
        mint(_owner, value);
    }
}
