# Voting Smart Contract
![W_msp2017030040-750x500-750x500](https://github.com/krritik01/Project-Voting-System-using-Solidity/assets/98963769/8301ba4b-16f7-42d6-98cc-abea7221a643)
## Overview
The Voting smart contract provides a decentralized platform for conducting secure and transparent voting processes. It allows registered voters to cast their votes for registered candidates, with the entire process managed on the Ethereum blockchain. The contract is designed to be user-friendly, providing functionality for voter registration, candidate registration, and vote casting.

## Design Choices:

- **Voter and Candidate Structs:** The use of Vote and Candidate structs provides a structured representation of votes and candidate information, enhancing readability and simplifying data management.

- **Mappings for Tracking:** Mappings such as registeredVoters, votes, and registeredCandidates are used for efficient data storage and retrieval. They help maintain a clear record of registered voters, cast votes, and registered candidates.

- **Array for Candidates:** The use of an array (candidates) to store candidate details allows for easy enumeration and retrieval of candidate information, providing a dynamic structure for candidate management.

## Security Considerations:

- **Modifiers for Access Control:** The onlyOwner and onlyRegisteredVoter modifiers ensure that certain functions can only be executed by the contract owner or registered voters, adding an extra layer of access control.

- **Voter Registration Check:** Before allowing a voter to register, the contract checks whether the voter is already registered, preventing duplicate registrations.

- **Vote Timestamp Check:** The contract checks whether a voter has already cast a vote by verifying the timestamp of the vote, ensuring that each voter can only vote once.

## Efficiency and Gas Optimization:

- **Use of Modifiers:** Modifiers such as onlyOwner and onlyRegisteredVoter optimize gas usage by preventing unnecessary execution of functions by unauthorized users.

- **Event Emission:** Events like RegisterVoter, StartVoting, StopVoting, AddVote, and AddCandidate are emitted to provide transparency without compromising gas efficiency.

## ⭐Additional Considerations:

**Flexibility for Changing Votes:** The contract includes a commented-out function (removeVote) that allows voters to remove their votes. Uncommenting this function would give voters the flexibility to change their votes if needed.

## 🎯 Project Purpose:
The TokenSale smart contract was created to provide a secure and transparent mechanism for conducting token sale events on the Ethereum blockchain. The project aims to empower token issuers with a customizable and feature-rich solution that ensures fairness, security, and efficiency throughout the presale and public sale phases. By leveraging proven standards like ERC-20 and incorporating additional safeguards, the TokenSale contract prioritizes a trustworthy and user-friendly experience for both token issuers and contributors.

## Features:

- **Voter Registration:** Users can register for voting, preventing duplicate registrations.

- **Candidate Registration:** Owner can add unique candidates, checking for candidate uniqueness.

- **Voting Process Control:** Owner-controlled process initiation and termination.

- **Vote Casting:** Registered voters can cast one vote each, with a timestamp check for vote validity.

- **Voting State Monitoring:** Public boolean (isVoting) indicates the voting status.

- **Events for Transparency:** Emits events for transparency and monitoring.

- **Efficient Data Storage:** Uses mappings and arrays for optimized data storage.

- **Access Control Modifiers:** Restricts functions to authorized users.

- **Flexibility for Changing Votes (Optional):** Optional functionality for voters to change votes.


## Instructions for Reviewers:

- Review the access control mechanisms implemented through modifiers to ensure that only authorized users can perform specific actions.

- Evaluate the gas efficiency of the contract, particularly with regard to event emission and conditional checks.

- Consider the flexibility provided for changing votes and assess whether this aligns with the intended use case.

- Verify that the storage structures, including structs and mappings, are appropriately used for efficient data management.

- Test the functions related to voter registration, candidate registration, and vote casting to ensure they function as expected.


    
## Feedback

If you have any feedback, please reach out to us at krritik0987@gmail.com

