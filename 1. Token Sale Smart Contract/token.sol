// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

//This smart contract will interact with some token smart contract so we usE ERC20 Interface
//To make the calculations safe and not ease to hack then we use SafeMath
//To define ownmership we use Ownable.sol

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

contract TokenSale is ERC20, Ownable(msg.sender){ //The TokenSale contract inherits the features from both ERC20 and Ownable contracts, combining all their functionalities.
    using SafeMath for uint256; //secure all unsigned interger
    //Now we declare state variable which store the information about the tokenSale
    uint256 public presaleCap;
    uint256 public publicSaleCap;                
    uint256 public minPresaleContribution;
    uint256 public maxPresaleContribution;
    uint256 public minPublicSaleContribution;
    uint256 public maxPublicSaleContribution;
    bool public presaleEnded;
    uint256 public presaleEndTime;

    //Now we declare the events. Events are a way for the contract to communicate with the outside world and allow external applications to listen for specific occurrences on the blockchain.
    event TokensPurchased(address indexed buyer, uint256 etherAmount,uint256 tokenAmount); //we use indexed keyword to make this parameter searchable in event logs
    event TokensDistributed(address indexed recipient, uint256 amount);
    event RefundClaimed(address indexed contributor, uint256 amount);

    constructor(
        string memory name, string memory symbol,
        uint256 _presaleCap, uint256 _publicSaleCap,
        uint256 _minPresaleContribution, uint256 _maxPresaleContribution,
        uint256 _minPublicSaleContribution, uint256 _maxPublicSaleContribution,
        uint256 _presaleEndTime
    ) ERC20(name, symbol) {
        presaleCap = _presaleCap;
        publicSaleCap = _publicSaleCap;
        minPresaleContribution = _minPresaleContribution;
        maxPresaleContribution = _maxPresaleContribution;
        minPublicSaleContribution = _minPublicSaleContribution;
        maxPublicSaleContribution = _maxPublicSaleContribution;
        presaleEndTime = _presaleEndTime;
    }

    modifier onlyBeforePresaleEnd() {
        require(!presaleEnded && block.timestamp < presaleEndTime,"Presale has ended");
        _;
    }

    //The contributeToPresale function allows users to contribute Ether to the presale, but it can only be executed if the presale has not ended (onlyBeforePresaleEnd modifier) and the contribution meets certain conditions.
    function contributeToPresale() external payable onlyBeforePresaleEnd {
        require(msg.value >= minPresaleContribution &&msg.value <= maxPresaleContribution, "Please enter the valid amount");
        require(totalSupply() + msg.value <= presaleCap,"Presale Cap has reached");

        uint256 tokensPurchased = msg.value; //It calculates the number of tokens to be minted (tokensPurchased) based on the amount of Ether sent in the transaction (msg.value).
        _mint(msg.sender, tokensPurchased); //_mint function to mint and assign tokens to the contributor address.
        emit TokensPurchased(msg.sender, msg.value, tokensPurchased); //TokensPurchased event is emitted to log the purchase.
    }

    function endPresale() external onlyOwner {
        presaleEnded = true;
    }

    modifier onlyAfterPresaleEnd() {
        require(presaleEnded,"First presale must complete then public sale start" );
        _;
    } //This modifier checks if the presale ended or not if it is ended then it will start the Public sale

    function contributeToPublicSale() external payable onlyAfterPresaleEnd{
        require(msg.value >= minPublicSaleContribution &&msg.value <= maxPublicSaleContribution,"Please enter the valid amount");
        require(totalSupply() <= publicSaleCap, "Public sale cap reached");

        uint256 tokensPurchased = msg.value;
        _mint(msg.sender, tokensPurchased);
        emit TokensPurchased(msg.sender, msg.value, tokensPurchased);
    }

    function distributeTokens(address recipient, uint256 amount) external onlyOwner{
        require(totalSupply() + amount <= publicSaleCap,"Amount is greater than publicSale cap");

        _mint(recipient, amount);
        emit TokensDistributed(recipient, amount);
    }

    function claimRefund() external {
        require(presaleEnded && block.timestamp >= presaleEndTime,"Presale must be completed");
        require(totalSupply() < presaleCap, "Minimum cap is not reached yet!");

        uint256 refundAmount = balanceOf(msg.sender);
        require(refundAmount > 0, "It should be greater than zero");

        _burn(msg.sender, refundAmount); // _burn function, which is typically part of an ERC-20 token contract. It burns the specified amount of tokens from the caller's balance.
        payable(msg.sender).transfer(refundAmount);
        emit RefundClaimed(msg.sender, refundAmount);
    }

    receive() external payable {//We use Fallback function to reject Ether without a specified function if someone sends by mistake
        revert("Ether not accepted without a specified function");
    }

    
}
