pragma solidity ^0.4.10; //We have to specify what version of the compiler this code will use

contract Voting {

  // We use the struct datatype to store the voter information.
  struct voter {
    address voterAddress; // The address of the voter
    uint tokensBought;    // The total no. of tokens this voter owns
    uint[] tokensUsedPerCandidate; // Array to keep track of votes per candidate.
    /* We have an array of candidates initialized below.
     Every time this voter votes with her tokens, the value at that
     index is incremented. Example, if candidateList array declared
     below has ["Rama", "Nick", "Jose"] and this
     voter votes 10 tokens to Nick, the tokensUsedPerCandidate[1]
     will be incremented by 10.
     */
  }

  /* mapping is equivalent to an associate array or hash
   The key of the mapping is candidate name stored as type bytes32 and value is
   an unsigned integer which used to store the vote count
   */

  mapping (address => voter) public voterInfo;

  /* Solidity doesn't let you return an array of strings yet. We will use an array of bytes32
   instead to store the list of candidates
   */

  mapping (bytes32 => uint) public votesReceived;

  bytes32[] public candidateList;

  uint public totalTokens; // Total no. of tokens available for this election
  uint public balanceTokens; // Total no. of tokens still available for purchase
  uint public tokenPrice; // Price per token

  /* When the contract is deployed on the blockchain, we will initialize
   the total number of tokens for sale, cost per token and all the candidates
   */
  function Voting(uint tokens, uint pricePerToken, bytes32[] candidateNames) {
    candidateList = candidateNames;
    totalTokens = tokens;
    balanceTokens = tokens;
    tokenPrice = pricePerToken;
  }

  function totalVotesFor(bytes32 candidate) constant returns (uint) {
    return votesReceived[candidate];
  }

  /* Instead of just taking the candidate name as an argument, we now also
   require the no. of tokens this voter wants to vote for the candidate
   */
  function voteForCandidate(bytes32 candidate, uint votesInTokens) {
    uint index = indexOfCandidate(candidate);
    if (index == uint(-1)) throw;

    // msg.sender gives us the address of the account/voter who is trying
    // to call this function
    if (voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {
      for(uint i = 0; i < candidateList.length; i++) {
        voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
      }
    }

    // Make sure this voter has enough tokens to cast the vote
    uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokensUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
    if (availableTokens < votesInTokens) throw;

    votesReceived[candidate] += votesInTokens;

    // Store how many tokens were used for this candidate
    voterInfo[msg.sender].tokensUsedPerCandidate[index] += votesInTokens;
  }

  // Return the sum of all the tokens used by this voter.
  function totalTokensUsed(uint[] _tokensUsedPerCandidate) private constant returns (uint) {
    uint totalUsedTokens = 0;
    for(uint i = 0; i < _tokensUsedPerCandidate.length; i++) {
      totalUsedTokens += _tokensUsedPerCandidate[i];
    }
    return totalUsedTokens;
  }

  function indexOfCandidate(bytes32 candidate) constant returns (uint) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return i;
      }
    }
    return uint(-1);
  }

  /* This function is used to purchase the tokens. Note the keyword 'payable'
   below. By just adding that one keyword to a function, your contract can
   now accept Ether from anyone who calls this function. Accepting money can
   not get any easier than this!
   */

  function buy() payable returns (uint) {
    uint tokensToBuy = msg.value / tokenPrice;
    if (tokensToBuy > balanceTokens) throw;
    voterInfo[msg.sender].voterAddress = msg.sender;
    voterInfo[msg.sender].tokensBought += tokensToBuy;
    balanceTokens -= tokensToBuy;
    return tokensToBuy;
  }

  function tokensSold() constant returns (uint) {
    return totalTokens - balanceTokens;
  }

  function voterDetails(address user) constant returns (uint, uint[]) {
    return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
  }

  /* All the ether sent by voters who purchased the tokens is in this
   contract's account. This method will be used to transfer out all those ethers
   in to another account. *** The way this function is written currently, anyone can call
   this method and transfer the balance in to their account. In reality, you should add
   check to make sure only the owner of this contract can cash out.
   */

  function transferTo(address account) {
    account.transfer(this.balance);
  }

  function allCandidates() constant returns (bytes32[]) {
    return candidateList;
  }

}
