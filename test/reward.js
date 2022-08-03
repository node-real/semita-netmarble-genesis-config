/** @var artifacts {Array} */
/** @var web3 {Web3} */
/** @function contract */
/** @function it */
/** @function before */
/** @var assert */

const {newMockContract, expectError} = require('./helper')

contract("Reward", async (accounts) => {
    const [owner, release1, release2] = accounts;

    it("burn and release: reserve enough", async () => {
        const {reward, reserve} = await newMockContract(owner, {'rewardOwnerAddress': release1, 'foundationAddress': release2});

        assert.equal(await web3.eth.getBalance(reward.address), 0)
        assert.equal(await web3.eth.getBalance(reserve.address), 0)

        await web3.eth.sendTransaction({to:reward.address, from:owner, value:web3.utils.toWei("10", "ether")})
        assert.equal(await web3.eth.getBalance(reward.address), 10000000000000000000)

        await web3.eth.sendTransaction({to:reserve.address, from:owner, value:web3.utils.toWei("10", "ether")})
        assert.equal(await web3.eth.getBalance(reserve.address), 10000000000000000000)

        let res = await reward.burn({from: owner})
        assert.equal(res.logs[0].args.amount.toString(), '5000000000000000000');
        assert.equal(res.logs[0].args.to, release2);
        assert.equal(res.logs[0].args.releaseAmount.toString(), '7500000000000000000');
        assert.equal(await web3.eth.getBalance(reward.address), '0')
        assert.equal(await web3.eth.getBalance('0x000000000000000000000000000000000000dEaD'), 5000000000000000000)
    });
    it("burn and release: reserve not enough", async () => {
        const {reward, reserve} = await newMockContract(owner, {'rewardOwnerAddress': release1, 'foundationAddress': release2});

        assert.equal(await web3.eth.getBalance(reward.address), 0)
        assert.equal(await web3.eth.getBalance(reserve.address), 0)
        assert.equal(await web3.eth.getBalance('0x000000000000000000000000000000000000dEaD'), 5000000000000000000)

        await web3.eth.sendTransaction({to:reward.address, from:owner, value:web3.utils.toWei("10", "ether")})
        assert.equal(await web3.eth.getBalance(reward.address), 10000000000000000000)

        // await web3.eth.sendTransaction({to:reserve.address, from:owner, value:web3.utils.toWei("10", "ether")})
        // assert.equal(await web3.eth.getBalance(reserve.address), 10000000000000000000)

        let res = await reward.burn({from: owner})
        assert.equal(res.logs[0].args.amount.toString(), '2500000000000000000');
        assert.equal(res.logs[0].args.to, release2);
        assert.equal(res.logs[0].args.releaseAmount.toString(), '7500000000000000000');
        assert.equal(await web3.eth.getBalance(reward.address), '0')
        assert.equal(await web3.eth.getBalance('0x000000000000000000000000000000000000dEaD'), 7500000000000000000)
    });

});