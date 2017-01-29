let contractInstance = Voting.deployed();
let candidates = {"Rama": "candidate-1", "Nick": "candidate-2", "Jose": "candidate-3"}

function voteForCandidate(candidate) {
  let candidateName = $("#candidate").val();
  try {
    $("#msg").html("Vote has been submitted. The vote count will increment as soon as the vote is recorded on the blockchain. Please wait.")
    $("#candidate").val("");
    return contractInstance.voteForCandidate(candidateName, {gas: 140000, from: web3.eth.accounts[0]}).then(function() {
      let div_id = candidates[candidateName];
      return contractInstance.totalVotesFor.call(candidateName).then(function(v) {
        $("#" + div_id).html(v.toString());
        $("#msg").html("");
      });
    });
  } catch (err) {
    console.log(err);
  }
}

$( document ).ready(function() {
  candidateNames = Object.keys(candidates);
  for (var i = 0; i < candidateNames.length; i++) {
    let name = candidateNames[i];
    contractInstance.totalVotesFor.call(name).then(function(v) {
      $("#" + candidates[name]).html(v.toString());
    });
  }
});

