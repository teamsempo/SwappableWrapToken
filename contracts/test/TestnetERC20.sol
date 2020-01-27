pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";

/**
 * @title An implementation of ERC20 with the same interface as the Compound project's testnet tokens (mainly DAI)
 * @dev This contract can be deployed or the interface can be used to communicate with Compound's ERC20 tokens.  Note:
 * this token should never be used to store real value since it allows permissionless minting.
 */
contract TestnetERC20 is ERC20Mintable {

    string public name;
    string public symbol;
    uint8 public decimals; // solhint-disable-line const-name-snakecase

    constructor(string memory _name, string memory _symbol, uint8 _decimals)
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
