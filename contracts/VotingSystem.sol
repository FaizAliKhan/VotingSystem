pragma solidity ^0.4.21;

contract VotingSystem {

  struct voter {
  address voterAddress; // Address on the blockchain
  uint votesAvailable; // How many votes this voter can cast
  uint[] votesCastPerCandidate; // Who this voter has already voted for
  }

  // Variable Declarations
  mapping (address => voter) public voterInfo;
  mapping (bytes32 => uint) public votesReceived; // for each candidate

  bytes32[] public candidateList;

  uint public totalVotes;
  uint public votesRemaining;
  uint public votesPerETH;

  //Constructor
  function VotingSystem(uint votes, uint ETHtoVote, bytes32[] candidateNames) public {
  candidateList = candidateNames; // Can be done in a separate method but this ensures a fixed number of candidates
  totalVotes = votes; // Total number of registered votes
  votesRemaining = votes; // to be reduced as votes are claimed and cast
  votesPerETH = ETHtoVote; // How many votes will be claimed when trading ether
  }

  // trade Ether for votes - amount to be declared in deployment when itialising contract
  function buy() payable public returns (uint) {
  uint claimVotes = msg.value / votesPerETH;
  require(claimVotes <= votesRemaining);
  // by using the following line we can ensure voters can only by a limited number of tokens:
  require(voterInfo[msg.sender].votesAvailable < 3); // one voter can only cast up to 3 votes
  voterInfo[msg.sender].voterAddress = msg.sender;
  voterInfo[msg.sender].votesAvailable += claimVotes;
  votesRemaining -= claimVotes;
  return claimVotes;
  }

  // Allow users to cast votes by calling this method
  function castVote(bytes32 voteFor, uint numberOfVotes) public {
  // Variable declarations for candidate and number of tokens
  uint index = indexOfCandidate(voteFor);
  require(index != uint(-1));

  uint availableVotes = voterInfo[msg.sender].votesAvailable - totalVotesCast(voterInfo[msg.sender].votesCastPerCandidate);
  require (availableVotes >= numberOfVotes);
  if (voterInfo[msg.sender].votesCastPerCandidate.length == 0) {
    for(uint i = 0; i < candidateList.length; i++) {
    voterInfo[msg.sender].votesCastPerCandidate.push(0);
   }
  }

  votesReceived[voteFor] += numberOfVotes;
  voterInfo[msg.sender].votesCastPerCandidate[index] += numberOfVotes;
  }

  function totalVotesFor(bytes32 candidate) view public returns (uint) {
  return votesReceived[candidate];
  }

  function totalVotesCast(uint[] _votesCastPerCandidate) private pure returns (uint) {
  uint totalVotesCast = 0;
  for(uint i = 0; i < _votesCastPerCandidate.length; i++) {
   totalVotesCast += _votesCastPerCandidate[i];
  }
  return totalVotesCast;
  }

  function indexOfCandidate(bytes32 candidate) view public returns (uint) {
  for(uint i = 0; i < candidateList.length; i++) {
   if (candidateList[i] == candidate) {
    return i;
   }
  }
  return uint(-1);
  }

  function voterDetails(address user) view public returns (uint, uint[]) {
  return (voterInfo[user].votesAvailable, voterInfo[user].votesCastPerCandidate);
  }

  function transferTo(address account) public {
  account.transfer(this.balance);
  }

  function allCandidates() view public returns (bytes32[]) {
  return candidateList;
  }

  // The following functions are used to populate the front-end
  function votesDistributed() view public returns (uint) {
  return totalVotes - votesRemaining;
  }

  function votesRemaining() view public returns (uint){
   return votesRemaining;
  }


}
