const Voting = artifacts.require("Voting");

module.exports = function(deployer) {
  deployer.deploy(Voting, ['Rama', 'Nick', 'Jose'].map(name => web3.utils.asciiToHex(name)));
};
