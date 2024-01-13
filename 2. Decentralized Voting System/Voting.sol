// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Voting{
    
    bool public isVoting;
    address public owner;

    struct Vote{   //Struct to represent a vote
        address receiver;
        uint timestamp;
    }

    struct Candidate{ // Struct to represent a candidate
        string name;
        address candidateAddress;
    }

    mapping (address=>bool) public registeredVoters; // Mapping to track registered voters
    mapping (address=>Vote) public votes; // Mapping to store votes, indexed by voter's address
    mapping (address=>bool) public registeredCandidates; // Mapping to track registered candidates

    Candidate[] public candidates; //We use array to store candidate details

    event RegisterVoter(address voter);
    event StartVoting(address startedBy);
    event StopVoting(address stopedBy);
    event AddVote(address indexed voter, address receiver, uint timestamp);
    event AddCandidate(address indexed owner,string name, address candidateAddress);

    // event RemoveVote(address voter); We can use this if we want to give voters the flexibility to change their votes.

    modifier onlyOwner(){
        require(msg.sender==owner,"ONly owner can call this function");
        _;
    }
    modifier onlyRegisteredVoter(){
        require(registeredVoters[msg.sender],"Only registered voters can call this function");
        _;
    }

    constructor (){
        isVoting=false;
        owner=msg.sender;
    }

// Function for voters to register
    function registerToVote() external returns (bool){
        require(!registeredVoters[msg.sender], "You are already registered");
        registeredVoters[msg.sender]=true;
        emit RegisterVoter(msg.sender);
        return true;
    }

// Function for the owner to start the voting process
    function startVoting() external onlyOwner returns(bool){
        isVoting=true;
        emit StartVoting(msg.sender);
        return true;
    }

//Function for owner to stop voteing process
    function stopVoting() external onlyOwner returns (bool) {
        isVoting=false;
        emit StopVoting(msg.sender);
        return true;
    }

 // Function for registered voters to cast a vote
    function addVote(address receiver) external onlyRegisteredVoter returns(bool){
        require(isVoting, "Currently voting is not  allowed");
        require(votes[msg.sender].timestamp ==0,"You have already voted.");

        votes[msg.sender] =Vote(receiver, block.timestamp); //this line records the vote. It creates a Vote struct with the receiver address and the current block timestamp, and assigns it to the votes mapping with the sender's address as the key.
        emit AddVote(msg.sender, receiver, block.timestamp);
        return true;
    }

//  // Function for registered voters to remove their vote. We can use this if we want to give voters the flexibility to change their votes.
//     function removeVote() external onlyRegisteredVoter returns (bool) {
//         require(isVoting, "Voting is not currently allowed");
//         delete votes[msg.sender];
//         emit RemoveVote(msg.sender);
//         return true;
//     }

// Function to get the candidate address voted for by a specific voter

    function getVote(address voterAddress) external view returns(address candidateAddress){
        return votes[voterAddress].receiver;
    }

// Function for the owner to add a new candidate
    function addCandidate(string memory name, address candidateAddress) external onlyOwner returns(bool){
        require(!registeredCandidates[candidateAddress],"This candidate is already registered");
        registeredCandidates[candidateAddress]=true;

        candidates.push(Candidate(name,candidateAddress)); //Store the data of candidate in the array
        emit AddCandidate(msg.sender, name, candidateAddress);
        return true;
    }

 // Function to get the number of registered candidates
    function getCandidateCount() external view returns(uint){
        return candidates.length;
    }

// Function to get candidate details by index
    function getCandidateByIndex(uint256 index) external view returns (string memory name, address candidateAddress) {
        require(index < candidates.length, "Invalid index");
        Candidate memory candidate = candidates[index];
        return (candidate.name, candidate.candidateAddress);
    }
}
