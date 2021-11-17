var Vaccinator = artifacts.require("./Vaccinator.sol");

module.exports = function(deployer) {
  deployer.deploy(Vaccinator);
};
