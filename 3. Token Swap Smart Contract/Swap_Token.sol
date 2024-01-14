// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

contract TokenSwap is Ownable(msg.sender) {
    using SafeMath for uint256; //secure all unsigned interger
    ERC20 public tokenA;
    ERC20 public tokenB;
    uint256 public exchangeRate;

    event Swap(address indexed sender, uint256 amountA, uint256 amountB);

//We use constructor here to initialize the contract with addresses of Token A, Token B, and the initial exchange rate
    constructor(
        address _tokenA,
        address _tokenB,
        uint256 _initialExchangeRate
    ) {
        tokenA = ERC20(_tokenA);
        tokenB = ERC20(_tokenB);
        exchangeRate = _initialExchangeRate;
    }
// Function to set a new exchange rate and it is only accessible by the owner the of contract
    function setExchangeRate(uint256 _newRate) external onlyOwner {
        require(_newRate > 0, "Exchange rate must be greater than zero");
        exchangeRate = _newRate;
    }

//This function will do swapping of Token A for Token B
    function swapAToB(uint256 _amountA) external {
        require(_amountA > 0, "Amount must be greater than zero");

        uint256 amountB = _amountA.mul(exchangeRate);  //it will calculate the equivalent amount of Token B based on the exchange rate
        require(tokenA.balanceOf(msg.sender) >= _amountA, "Insufficient balance of Token A");
        require(tokenB.balanceOf(address(this)) >= amountB, "Insufficient balance of Token B");

        tokenA.transferFrom(msg.sender, address(this), _amountA); //it will perform the swap means it transfer Token A from the user to the contract, and transfer Token B from the contract to the user
        tokenB.transfer(msg.sender, amountB);

        emit Swap(msg.sender, _amountA, amountB);
    }


//This function will do swapping of Token B for Token A
    function swapBToA(uint256 _amountB) external {
        require(_amountB > 0, "Amount must be greater than zero");

        uint256 amountA = _amountB.div(exchangeRate);  //it will calculate the equivalent amount of Token A based on the exchange rate
        require(tokenB.balanceOf(msg.sender) >= _amountB, "Insufficient balance of Token B");
        require(tokenA.balanceOf(address(this)) >= amountA, "Insufficient balance of Token A");

        tokenB.transferFrom(msg.sender, address(this), _amountB); //it will perform the swap means it transfer Token B from the user to the contract, and transfer Token A from the contract to the user
        tokenA.transfer(msg.sender, amountA);

        emit Swap(msg.sender, amountA, _amountB);
    }
}
