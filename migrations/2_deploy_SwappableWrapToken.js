const SwappableWrapToken = artifacts.require("SwappableWrapToken");

const networks = {
    'kovan': {
        wrappedTokenAddress: '0xc4375b7de8af5a38a93548eb8453a498222c4ff2' //Dai
    }
};

module.exports = async function(deployer, network) {
    deployer.deploy(SwappableWrapToken, 'TestSwappable', 'TSWAP', 18, '0xc4375b7de8af5a38a93548eb8453a498222c4ff2');
};