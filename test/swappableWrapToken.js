const utils = require('./helpers/Utils');
const SwappableWrapToken = artifacts.require("SwappableWrapToken");
const TestnetERC20 = artifacts.require("TestnetERC20");

let erc20_a;
let erc20_b;

async function initSwappable() {
    return await SwappableWrapToken.new('Test Swappable', 'TSWAP', 18, erc20_a.address);
}

contract('SwappableWrapToken', (accounts) => {
    before(async () => {
        erc20_a = await TestnetERC20.new('ERC20A', 'ERC20A', 18);
        await erc20_a.allocateTo(accounts[0], '1000');

        erc20_b = await TestnetERC20.new('ERC20B', 'ERC20B', 18);
        await erc20_b.allocateTo(accounts[0], '1000');

    });

    it('verifies that original swappable token is intialised correctly', async () => {
        let swappable = await initSwappable();
        assert.equal(await swappable.wrappedToken(), erc20_a.address);
    });


    it('verifies that the owner is the creator of the account', async () => {
        let swappable = await initSwappable();
        assert.equal(await swappable.owner(), accounts[0]);
    });

    it('should throw if an account tries to wrap without approving the swappable first', async () => {
        let swappable = await initSwappable();
        await utils.catchRevert(swappable.wrap(10));
    });

    it('verifies that an token can be wrapped once the swappable is approved', async () => {
        let swappable = await initSwappable();

        await erc20_a.approve(swappable.address, '1000000000000000000'); //1e18
        await swappable.wrap('100');

        assert.equal(await swappable.balanceOf(accounts[0]), '100');
    });

    it('verifies that an token can be swapped by the owner', async () => {
        let swappable = await initSwappable();

        await erc20_a.approve(swappable.address, '1000000000000000000'); //1e18
        await swappable.wrap('100');

        let preswap_a_bal = await erc20_a.balanceOf(accounts[0]);
        let preswap_b_bal = await erc20_b.balanceOf(accounts[0]);

        await erc20_b.approve(swappable.address, '1000000000000000000'); //1e18
        await swappable.swapWrap(erc20_b.address);

        let postswap_a_bal = await erc20_a.balanceOf(accounts[0]);
        let postswap_b_bal = await erc20_b.balanceOf(accounts[0]);

        assert.equal(postswap_a_bal - preswap_a_bal, 100);
        assert.equal(postswap_b_bal - preswap_b_bal, -100);
        assert.equal(await swappable.wrappedToken(), erc20_b.address);

    });


});