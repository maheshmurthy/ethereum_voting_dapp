module.exports = function(deployer) {
  deployer.deploy(Voting, ['Rama', 'Nick', 'Jose'], {gas: 290000});
};
