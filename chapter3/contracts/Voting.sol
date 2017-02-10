pragma solidity ^0.4.6; //We have to specify what version of the compiler this code will use

contract Voting {

  struct voter {
     address voterAddress;
     uint tokensBought;
     uint[] tokensUsedPerCandidate;
  }

  /* mapping is equivalent to an associate array or hash
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer which used to store the vote count
  */

  mapping (address => voter) public voterInfo;

  /* Solidity doesn't let you return an array of strings yet. We will use an array of bytes32 instead to store
  the list of candidates
  */

  mapping (bytes32 => uint) public votesReceived;

  bytes32[] public candidateList;
  uint public totalTokens;
  uint public balanceTokens;
  uint public tokenPrice;

  // Initialize the total number of tokens for sale, cost per token and all the candidates
  function Voting(uint tokens, uint pricePerToken, bytes32[] candidateNames) {
    candidateList = candidateNames;
    totalTokens = tokens;
    balanceTokens = tokens;
    tokenPrice = pricePerToken;
  }

  function totalVotesFor(bytes32 candidate) returns (uint) {
    return votesReceived[candidate];
  }

  function voteForCandidate(bytes32 candidate, uint totalTokens) {
    uint index = indexOfCandidate(candidate);
    if (index == uint(-1)) throw;

    if (voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {
      for(uint i = 0; i < candidateList.length; i++) {
        voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
      }
    }

    uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokensUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
    if (availableTokens < totalTokens) throw;
    votesReceived[candidate] += totalTokens;
    // Store how many tokens were used for this candidate
    voterInfo[msg.sender].tokensUsedPerCandidate[index] += totalTokens;
  }

  function totalTokensUsed(uint[] _tokensUsedPerCandidate) private returns (uint) {
    uint totalUsedTokens = 0;
    for(uint i = 0; i < _tokensUsedPerCandidate.length; i++) {
      totalUsedTokens += _tokensUsedPerCandidate[i];
    }
    return totalUsedTokens;
  }

  function indexOfCandidate(bytes32 candidate) returns (uint) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return i;
      }
    }
    return uint(-1);
  }

  function buy() payable returns (uint) {
    uint tokensToBuy = msg.value / tokenPrice;
    if (tokensToBuy > balanceTokens) throw;
    voterInfo[msg.sender].voterAddress = msg.sender;
    voterInfo[msg.sender].tokensBought += tokensToBuy;
    balanceTokens -= tokensToBuy;
    return tokensToBuy;
  }

  function tokensSold() returns (uint) {
    return totalTokens - balanceTokens;
  }

  function voterDetails(address user) returns (uint, uint[]) {
    return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
  }

  function transferTo(address account) {
    if (!account.send(this.balance)) throw;
  }

  function allCandidates() returns (bytes32[]) {
    return candidateList;
  }

}

