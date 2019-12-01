const SwappableWrapToken = artifacts.require("SwappableWrapToken");

const argv = require("minimist")(process.argv.slice(), { string: ["name", "symbol", "wrappedToken"] });

const networks = {
    'kovan': {
        wrappedTokenAddress: '0xc4375b7de8af5a38a93548eb8453a498222c4ff2' //Dai
    }
};

module.exports = async function(deployer, network) {
    if (network !== 'development') {
        deployer.deploy(SwappableWrapToken, argv.name, argv.symbol, 18, argv.wrappedToken);
    }
};