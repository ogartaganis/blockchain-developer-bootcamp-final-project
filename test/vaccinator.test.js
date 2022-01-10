var Vaccinator = artifacts.require("./Vaccinator.sol")

contract("Vaccinator", function(accounts) {
    const [contractOwner, varoutsos] = accounts;

    beforeEach(async () => {
        instance = await Vaccinator([varoutsos], ["11", "12"]).new();
      });
    
    it("Sanity check. Ready for testing!", async() => {
        const eth100 = 100e18;
        assert.equal(await web3.eth.getBalance(varoutsos), eth100.toString());
    });

    it("is owned by owner", async() => {
        assert.equal(
            await instance.owner.call(),
            contractOwner,
            "owner is not correct",
          );
    });
});