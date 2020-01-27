pragma solidity ^0.5.0;

contract IERC20Wrapper {
    event  ERC20Wrap(address indexed dst, uint wad);
    event  ERC20Unwrap(address indexed src, uint wad);

    function wrap(uint wad) public returns (bool);
    function unwrap(uint wad) public returns (bool);

}
