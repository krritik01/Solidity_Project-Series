// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;



contract MultiSignature {

    address[] public owners; //This array stores the addresses of owners and these owners is the people who is controlling this smart contract
    uint public numConfirmationsRequired; // Number of confirmations required from owners to approve and execute a transaction

// Structure to represent each transaction
    struct Transaction {
        address to; 
        uint value; 
        bool executed; 
        uint confirmationCount; 
    }

    Transaction[] public transactions; //here we store all our transaction
    mapping(uint => mapping(address => bool)) public isConfirmed;  //Weather our transaction is confirmed or not by each owner

    event TransactionSubmitted(uint transactionId, address sender, address receiver, uint amount);
    event TransactionConfirmed(uint transactionId);
    event TransactionExecuted(uint transactionId);
    event TransactionCancelled(uint transactionId);

    modifier onlyOwners() { //We use modifier here to restrict certain functions to be callable only by owners
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

//We use constructor heere to initialize the contract with owners and the required number of confirmations to confirm the transaction
    constructor(address[] memory _owners, uint _numConfirmationsRequired) {
        require(_owners.length > 1, "At least two owners are required");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "Invalid number of confirmations");

    
        for (uint i = 0; i < _owners.length; i++) { //We use loop here to add each owner address to the 'owners' array
            require(_owners[i] != address(0), "Invalid owner address");
            owners.push(_owners[i]);
        }
        numConfirmationsRequired = _numConfirmationsRequired; //its sets the required number of confirmations
    }

//Function to check if a given address is one of the owners of the wallet or not
    function isOwner(address _address) public view returns (bool) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == _address) {
                return true;
            }
        }
        return false;
    }

//Function to submit a new transaction to the wallet and we recording the transaction here only not transferring
    function submitTransaction(address _to, uint _value) public onlyOwners payable {
        require(_to != address(0), "Invalid receiver address");
        require(_value > 0, "The amount should be greater than zero");

        uint transactionId = transactions.length; //it get a unique transaction ID
        transactions.push(Transaction({to: _to,value: _value, executed: false,confirmationCount: 0}));  //its adds a new transaction to the 'transactions' array

        for (uint i = 0; i < owners.length; i++) { //here we are initializing the 'isConfirmed' mapping for this transaction
            isConfirmed[transactionId][owners[i]] = false;
        }
        emit TransactionSubmitted(transactionId, msg.sender, _to, _value);
    }

//Function to confirm a submitted transaction and this function is called by the owners of the multi Signature wallet, so that they can confirm the submitted transaction
    function confirmTransaction(uint _transactionId) public onlyOwners  {
        require(_transactionId < transactions.length, "Invalid transaction Id");

        Transaction storage transaction = transactions[_transactionId];
        require(!isConfirmed[_transactionId][msg.sender], "Transaction already confirmed by this owner");
        isConfirmed[_transactionId][msg.sender] = true;
        transaction.confirmationCount++; //it increment the confirmation count for this transaction

        emit TransactionConfirmed(_transactionId);

        if (transaction.confirmationCount >= numConfirmationsRequired) { //we use if so that we can check that the required confirmations are met or not, if met then execute the transaction
            executeTransaction(_transactionId);
        }
    }

//This function will execute a confirmed transaction
    function executeTransaction(uint _transactionId) public onlyOwners {
    require(_transactionId < transactions.length, "Invalid transaction Id");
    Transaction storage transaction = transactions[_transactionId];
    require(!transaction.executed, "Transaction already executed");
    require(transaction.confirmationCount >= numConfirmationsRequired, "Insufficient confirmations");
    
    (bool success, ) = transaction.to.call{value: transaction.value}("");
    require(success, "Transaction execution failed: External call reverted");

    transaction.executed = true;

    emit TransactionExecuted(_transactionId);
}

//This function will cancel any transaction
      function cancelTransaction(uint _transactionId) public onlyOwners {
        require(_transactionId < transactions.length, "Invalid transaction Id");
        Transaction storage transaction = transactions[_transactionId];
        require(!transaction.executed, "Cannot cancel an executed transaction");

        for (uint i = 0; i < owners.length; i++) {
            isConfirmed[_transactionId][owners[i]] = false;
        }
        delete transactions[_transactionId];

        emit TransactionCancelled(_transactionId);
    }


// Fallback function to receive Ether
    receive() external payable {
       
    }
}
