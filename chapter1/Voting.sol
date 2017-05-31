pragma solidity ^0.4.10; //We have to specify what version of compiler this code will use

contract Voting {
  /* mapping is equivalent to an associate array or hash
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer which used to store the vote count
  */
  mapping (bytes32 => uint8) public votesReceived;
  
  /* Solidity doesn't let you create an array of strings yet. We will use an array of bytes32 instead to store
  the list of candidates
  */
  
  bytes32[] public candidateList;

  // Initialize all the contestants
  function Voting(bytes32[] candidateNames) {
    candidateList = candidateNames;
  }

  function totalVotesFor(bytes32 candidate) returns (uint8) {
    if (validCandidate(candidate) == false) throw;
    return votesReceived[candidate];
  }

  function voteForCandidate(bytes32 candidate) {
    if (validCandidate(candidate) == false) throw;
    votesReceived[candidate] += 1;
  }

  function validCandidate(bytes32 candidate) returns (bool) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return true;
      }
    }
    return false;
  }
}

