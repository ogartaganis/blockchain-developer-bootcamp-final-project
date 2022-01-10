var Vaccinator = artifacts.require("./Vaccinator.sol")

contract("Vaccinator", function(accounts) {
    const [contractOwner, Artemis, Babis, Carlos] = accounts;
    const txParams = {
        from: accounts[0]
    };
    let catchRevert = require("./exceptions.js").catchRevert;

    beforeEach(async () => {
        instance = await Vaccinator.new([Artemis], ["11", "12"], txParams);
    });

    // Just a first test
    it("Sanity check. Ready for testing!", async() => {
        const eth100 = 100e18;
        assert.equal(await web3.eth.getBalance(Artemis), eth100.toString());
    });

    // Checking the ownable
    it("is owned by owner", async() => {
        assert.equal(await instance.owner.call(), contractOwner, "owner is not correct");
    });
    
    // Checking registration
    it("should only register legit serial numbers", async() => {
        // Arrange
        const legitSerialNumber = "11"
        const nonLegitSerialNumber = "10"
        const name = "Orestis"

        // Act
        var result = await instance.registerVaccinatedPerson(name, legitSerialNumber, { from : Artemis })
        var message = result.logs[0].args.message;

        // Assert
        assert.equal(message,"11pasok")

        // Act 2.0
        result = await instance.registerVaccinatedPerson(name, nonLegitSerialNumber, { from : Artemis })
        var shouldFailMessage = result.logs[0].args.message;

        // Assert 2.0
        assert.equal(shouldFailMessage,"not legit serial number!")
    });

    it("should only register legit serial numbers ONCE", async() => {
        // Arrange
        const legitSerialNumber = "11"
        const name = "Orestis"

        // Act
        var result = await instance.registerVaccinatedPerson(name, legitSerialNumber, { from : Artemis })
        var message = result.logs[0].args.message;

        // Assert
        assert.equal(message,"11pasok")

        // Act 2.0
        var result = await instance.registerVaccinatedPerson(name, legitSerialNumber, { from : Artemis })
        message = result.logs[0].args.message;

        // Assert 2.0
        assert.equal(message,"not legit serial number!")
    });

    it("onlyVerifiers are allowed to verify", async() => {
        // Arrange
        const legitSerialNumber = "11"
        const name = "Orestis"

        // Act
        await instance.registerVaccinatedPerson(name, legitSerialNumber, { from : Artemis });
        const registeredName = await instance.verifyRegisteredPerson(legitSerialNumber, { from : Artemis })

        // Assert - Artemis is the only verifier here.
        assert.equal(name, registeredName)

        // And trying from a different user should revert
        await catchRevert(instance.verifyRegisteredPerson(legitSerialNumber, { from : Babis }));    
    });

    it("only owner should be able to add verifiers", async() => {
        // Arrange
        var babisIsVerifier = await instance.verifiers(Babis, {from: Artemis});
        assert.equal(babisIsVerifier, false);

        // Act - Assert
        await catchRevert(instance.addVerifier(Babis, {from: Artemis}));
        babisIsVerifier = await instance.verifiers(Babis, {from: Artemis});
        assert.equal(babisIsVerifier, false);

        // Act - Assert v2.0
        await instance.addVerifier(Babis, {from: contractOwner});
        babisIsVerifier = await instance.verifiers(Babis, {from: Artemis});
        assert.equal(babisIsVerifier, true);
    })
});