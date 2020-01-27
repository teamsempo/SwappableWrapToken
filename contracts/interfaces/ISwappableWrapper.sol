pragma solidity ^0.5.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ISwappableWrapper is ERC20 {
    event WrapSwap(address indexed _originalToken, address indexed _newToken, address _swappingAccount);

    function swapWrap(address _newTokenAddress) public returns (bool);

}