var Vaccinator = artifacts.require("./Vaccinator.sol");

module.exports = function(deployer) {
    deployer.deploy(Vaccinator, ["0x0000000000000000000000000000000000000000"], ["11", "12", "13", "14", "15"]);
  };