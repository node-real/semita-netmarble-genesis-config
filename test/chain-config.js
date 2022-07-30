/** @var artifacts {Array} */
/** @var web3 {Web3} */
/** @function contract */
/** @function it */
/** @function before */
/** @var assert */

const {newMockContract, expectError} = require('./helper')

contract("ChainConfig", async (accounts) => {
    const [owner] = accounts;
    it("add freeGasAddressAdmin", async () => {
        const {config} = await newMockContract(owner);
        // set  freeGasAddressAdmin
        const r1 = await config.setFreeGasAddressAdmin('0x0000000000000000000000000000000000000001')
        assert.equal(r1.logs[0].event, 'FreeGasAddressAdminChanged')
        assert.equal(r1.logs[0].args.newFreeGasAddressAdmin, '0x0000000000000000000000000000000000000001')
    });
    it("add freeGasAddress", async () => {
        const {config} = await newMockContract(owner);
        // test isFreeGasAddress func
        assert.equal(await config.isFreeGasAddress('0x0000000000000000000000000000000000000002'), false)

        // test addFreeGasAddress func
        const r1 = await config.addFreeGasAddress('0x0000000000000000000000000000000000000002')
        assert.equal(r1.logs[0].event, 'FreeGasAddressAdded')
        assert.equal(r1.logs[0].args.freeGasAddress, '0x0000000000000000000000000000000000000002')
        // test getFreeGasAddressList func
        assert.equal(await config.isFreeGasAddress('0x0000000000000000000000000000000000000002'), true)
        assert.equal(await config.getFreeGasAddressList(), '0x0000000000000000000000000000000000000002')

        // test removeFreeGasAddress func
        const r2 = await config.removeFreeGasAddress('0x0000000000000000000000000000000000000002')
        assert.equal(r2.logs[0].event, 'FreeGasAddressRemoved')
        assert.equal(r2.logs[0].args.freeGasAddress, '0x0000000000000000000000000000000000000002')
        assert.equal(await config.isFreeGasAddress('0x0000000000000000000000000000000000000002'), false)
        assert.equal(await config.getFreeGasAddressList(), '')
    });
    it("set freeGasAddressSize", async () => {
        const {config} = await newMockContract(owner);
        // test setFreeGasAddressSize func
        const r1 = await config.setFreeGasAddressSize('0')
        assert.equal(r1.logs[0].event, 'FreeGasAddressSizeChanged')
        assert.equal(r1.logs[0].args.newValue.toString(), '0')

        // test addFreeGasAddress func, will revert
        await expectError(config.addFreeGasAddress('0x0000000000000000000000000000000000000001'),
            'The freeGasAddressList size reached the limit!')
    })
});
