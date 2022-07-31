/** @var artifacts {Array} */
/** @var web3 {Web3} */
/** @function contract */
/** @function it */
/** @function before */
/** @var assert */

const {newMockContract, expectError} = require('./helper')

contract("Reserve", async (accounts) => {
    const [owner, release1] = accounts;
    it("transfer fee", async () => {
        const {reserve} = await newMockContract(owner);

        const balance = await web3.eth.getBalance(reserve.address)
        assert.equal(balance, 0)
        await web3.eth.sendTransaction({to:reserve.address, from:owner, value:web3.utils.toWei("1", "ether")})
        const balance1 = await web3.eth.getBalance(reserve.address)
        assert.equal(balance1, 1000000000000000000)
        let res = await reserve.release(release1, '1000000000000000000', {from: owner})
        assert.equal(res.logs[0].args.addr, release1);
        assert.equal(res.logs[0].args.amount.toString(), '1000000000000000000');
        assert.equal(await web3.eth.getBalance(reserve.address), 0)
    });
});