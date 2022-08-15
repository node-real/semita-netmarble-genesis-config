/** @var artifacts {Array} */
/** @var web3 {Web3} */
/** @function contract */
/** @function it */
/** @function before */
/** @var assert */

const {newMockContract, expectError} = require('./helper')

function sleep(delay) {
    let start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}

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

        let res = await reward.burnAndRelease({from: owner})
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

        let res = await reward.burnAndRelease({from: owner})
        assert.equal(res.logs[0].args.amount.toString(), '0');
        assert.equal(res.logs[0].args.to, release2);
        assert.equal(res.logs[0].args.releaseAmount.toString(), '10000000000000000000');
        assert.equal(await web3.eth.getBalance(reward.address), '0')
        assert.equal(await web3.eth.getBalance('0x000000000000000000000000000000000000dEaD'), 5000000000000000000)
    });


    // ** NOTE ** change MINIMUM_DELAY to 0 before uncomment below test cases.

    // it.only("set foundationAddress", async () => {
    //     const {reward} = await newMockContract(owner, {'rewardOwnerAddress': release1, 'foundationAddress': release2, 'delay': 0});
    //
    //     assert.equal(await reward.getFoundationAddress({from: owner}), release2);
    //     let now = Math.floor(Date.now() / 1000);
    //     let wait = 3;
    //     await reward.queueUpdateFoundationAddress(release1, now+wait, {from:release1});
    //
    //     sleep(wait*1000);
    //     await reward.executeUpdateFoundationAddress(release1, now+wait, {from: release1});
    //     assert.equal(await reward.getFoundationAddress({from: owner}), release1);
    //     expectError(reward.executeUpdateFoundationAddress(release1, now+wait, {from: release1}), "Transaction hasn't been queued");
    // });
    // it.only("set burn ratio", async () => {
    //     const {reward} = await newMockContract(owner, {'rewardOwnerAddress': release1, 'foundationAddress': release2, 'delay': 0});
    //
    //     assert.equal(await reward.getBurnRatio({from: release1}), 5000);
    //     let now = Math.floor(Date.now() / 1000);
    //     let wait = 3;
    //     await reward.queueUpdateBurnRatio(6000, now+wait, {from:release1});
    //
    //     sleep(wait*1000);
    //     await reward.executeUpdateBurnRatio(6000, now+wait, {from: release1});
    //     assert.equal(await reward.getBurnRatio({from: owner}), 6000);
    //     expectError(reward.executeUpdateReleaseRatio(6000, now+wait, {from: release1}), "Transaction hasn't been queued");
    // });
    // it.only("set release ratio", async () => {
    //     const {reward} = await newMockContract(owner, {'rewardOwnerAddress': release1, 'foundationAddress': release2, 'delay': 0});
    //
    //     assert.equal(await reward.getReleaseRatio({from: release1}), 5000);
    //     let now = Math.floor(Date.now() / 1000);
    //     let wait = 3;
    //     await reward.queueUpdateReleaseRatio(6000, now+wait, {from:release1});
    //
    //     sleep(wait*1000);
    //     await reward.executeUpdateReleaseRatio(6000, now+wait, {from: release1});
    //     assert.equal(await reward.getReleaseRatio({from: owner}), 6000);
    //     expectError(reward.executeUpdateReleaseRatio(6000, now+wait, {from: release1}), "Transaction hasn't been queued")
    // })

});