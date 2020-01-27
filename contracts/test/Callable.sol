pragma solidity ^0.5.0;

contract Callable {

    uint256 public amountReceived;
    address public receivedFrom;
    bytes public dataIn;

    function onTokenTransfer(address from, uint256 amount, bytes memory data) public returns (bool success)
    {
        amountReceived = amount;
        receivedFrom = from;
        dataIn = data;

        return true;
    }
}
