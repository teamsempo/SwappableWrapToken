pragma solidity ^0.5.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

import "./interfaces/ISwappableWrapper.sol";
import "./interfaces/IERC20Wrapper.sol";
import "./ERC677Token.sol";

contract SwappableWrapToken is ERC677Token, ISwappableWrapper, IERC20Wrapper, Ownable {

    ERC20 public wrappedToken;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, address _wrappedToken)
        public
        ERC677Token(_name, _symbol, _decimals)
    {
        require(Address.isContract(_wrappedToken));
        wrappedToken = ERC20(_wrappedToken);
    }

    /**
     * @dev transfer tokens of the 'wrappedToken' type to the contract to receive same amount of swappable token
     * @param wad the amount to be wrapped
     */
    function wrap(uint wad) public returns (bool){
        _mint(msg.sender, wad);

        wrappedToken.transferFrom(msg.sender, address(this), wad);

        emit ERC20Wrap(msg.sender, wad);
        emit Transfer(address(0), msg.sender, wad);

        return true;
    }

    /**
     * @dev return swappable token to the contract to receive back the same amount of the 'wrappedToken' type
     * @param wad the amount to be unwrapped
     */
    function unwrap(uint wad) public returns (bool){
        require(balanceOf(msg.sender) >= wad, "not enough balance");

        _burn(msg.sender, wad);

        wrappedToken.transfer(msg.sender, wad);

        emit ERC20Unwrap(msg.sender, wad);
        emit Transfer(msg.sender, address(0), wad);

    return true;
    }


    /**
     * @dev swap the ERC20 token that is being wrapped.
     This involves transferring the contract's balance of the original wrap token to the swapping account,
     and transferring the same amount of the new wrap token from the swapping account to the contract
     * @param _newToken the new token that will act as the wrapped token
     */
    function swapWrap(address _newToken) public onlyOwner returns (bool){
        require(Address.isContract(_newToken), "address is not a contract");

        ERC20 originalToken = wrappedToken;

        wrappedToken = ERC20(_newToken);

        require(wrappedToken.balanceOf(msg.sender) >= totalSupply(), "Not enough balance of new token");

        wrappedToken.transferFrom(msg.sender, address(this), totalSupply());
        originalToken.transfer(msg.sender, totalSupply());

        emit WrapSwap(address(originalToken), address(wrappedToken), msg.sender);

        return true;
    }

}


