/** @var artifacts {Array} */
/** @var web3 {Web3} */
/** @function contract */
/** @function it */
/** @function before */
/** @var assert */

const {newMockContract, expectError} = require('./helper')

contract("Reward", async (accounts) => {
    const [owner, release1, release2] = accounts;
    it("burn", async () => {
        const {reward} = await newMockContract(owner);

        const balance = await web3.eth.getBalance(reward.address)
        assert.equal(balance, 0)
        await web3.eth.sendTransaction({to:reward.address, from:owner, value:web3.utils.toWei("10", "ether")})
        const balance1 = await web3.eth.getBalance(reward.address)
        assert.equal(balance1, 10000000000000000000)
        let res = await reward.burn('1000000000000000000', {from: owner})
        assert.equal(res.logs[0].args.amount.toString(), '1000000000000000000');
        assert.equal(await web3.eth.getBalance(reward.address), '9000000000000000000')
        const balance2 = await web3.eth.getBalance('0x000000000000000000000000000000000000dEaD')
        assert.equal(balance2, 1000000000000000000)
    });
    it("burn and release", async () => {
        const {reward, reserve} = await newMockContract(owner);

        const balance = await web3.eth.getBalance(reward.address)
        assert.equal(balance, 0)
        await web3.eth.sendTransaction({to:reward.address, from:owner, value:web3.utils.toWei("10", "ether")})
        const balance1 = await web3.eth.getBalance(reward.address)
        assert.equal(balance1, 10000000000000000000)
        await web3.eth.sendTransaction({to:reserve.address, from:owner, value:web3.utils.toWei("10", "ether")})
        const balance2 = await web3.eth.getBalance(reserve.address)
        assert.equal(balance2, 10000000000000000000)
        let res = await reward.burnAndReserveRelease('1000000000000000000', release1, '1000000000000000000', {from: owner})
        assert.equal(res.logs[0].args.amount.toString(), '1000000000000000000');
        assert.equal(res.logs[0].args.to, release1);
        assert.equal(res.logs[0].args.releaseAmount.toString(), '1000000000000000000');
        assert.equal(await web3.eth.getBalance(reward.address), '9000000000000000000')
        const balance3 = await web3.eth.getBalance('0x000000000000000000000000000000000000dEaD')
        assert.equal(balance3, 2000000000000000000)
    });
    it("claim", async () => {
        const {reward} = await newMockContract(owner);

        const balance = await web3.eth.getBalance(reward.address)
        assert.equal(balance, 0)
        await web3.eth.sendTransaction({to:reward.address, from:owner, value:web3.utils.toWei("10", "ether")})
        const balance1 = await web3.eth.getBalance(reward.address)
        assert.equal(balance1, 10000000000000000000)
        let res = await reward.claim(release2,'1000000000000000000', {from: owner})
        assert.equal(res.logs[0].args.amount.toString(), '1000000000000000000');
        assert.equal(res.logs[0].args.to, release2);
        assert.equal(await web3.eth.getBalance(reward.address), '9000000000000000000')
    });
    it("claim and burn", async () => {
        const {reward} = await newMockContract(owner);

        const balance = await web3.eth.getBalance(reward.address)
        assert.equal(balance, 0)
        await web3.eth.sendTransaction({to:reward.address, from:owner, value:web3.utils.toWei("10", "ether")})
        const balance1 = await web3.eth.getBalance(reward.address)
        assert.equal(balance1, 10000000000000000000)
        let res = await reward.claimAndBurn(release2,'1000000000000000000', '1000000000000000000', {from: owner})
        assert.equal(res.logs[0].args.to, release2);
        assert.equal(res.logs[0].args.amount.toString(), '1000000000000000000');
        assert.equal(res.logs[0].args.burnedAmount.toString(), '1000000000000000000');
        assert.equal(await web3.eth.getBalance(reward.address), '8000000000000000000')
    });
});