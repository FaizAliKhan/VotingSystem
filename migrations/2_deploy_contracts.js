var VotingSystem = artifacts.require("./VotingSystem.sol")
module.exports = function(deployer){
  deployer.deploy(VotingSystem, 10000, web3.toWei('1', 'ether'), ['Candidate 1', 'Candidate 2', 'Candidate 3']);
};
