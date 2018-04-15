pragma solidity ^0.4.18;
import "./ECRecovery.sol";

contract Voting {
  using ECRecovery for bytes32;

  mapping (bytes32 => uint8) public votesReceived;

  mapping(bytes32 => bytes32) public candidateHash;

  mapping(address => bool) public voterStatus;

  mapping(bytes32 => bool) public validCandidates;

  function Voting(bytes32[] _candidateNames, bytes32[] _candidateHashes) public {
    for(uint i = 0; i < _candidateNames.length; i++) {
      validCandidates[_candidateNames[i]] = true;
      candidateHash[_candidateNames[i]] = _candidateHashes[i];
    }
  }

  function totalVotesFor(bytes32 _candidate) view public returns (uint8) {
    require(validCandidates[_candidate]);
    return votesReceived[_candidate];
  }

  function voteForCandidate(bytes32 _candidate, address _voter, bytes _signedMessage) public {
    require(!voterStatus[_voter]);

    bytes32 voteHash = candidateHash[_candidate];
    address recoveredAddress = voteHash.recover(_signedMessage);

    require(recoveredAddress == _voter);
    require(validCandidates[_candidate]);

    votesReceived[_candidate] += 1;
    voterStatus[_voter] = true;
  }
}

