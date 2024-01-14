# TokenSwap Smart Contract
![Alt text](https://miro.medium.com/v2/resize:fit:1400/1*MqklyIEoxg3E22rccq_MQA.jpeg)
## Overview
The TokenSwap smart contract facilitates the exchange of two ERC-20 tokens, Token A and Token B, at a specified exchange rate. It allows users to swap Token A for Token B and vice versa. The contract aims to provide a decentralized and transparent mechanism for token swaps with an adjustable exchange rate.

## 🖥️Installation:
Ensure you have the required dependencies installed. This contract relies on OpenZeppelin contracts and SafeMath:

```bash
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

```

## 🎨Design Choices:

- **Ownership:** The contract is Ownable, ensuring that critical functions like setting the exchange rate can only be accessed by the contract owner, enhancing control and security.

- **SafeMath:** SafeMath is utilized to secure unsigned integer arithmetic, mitigating the risks of overflow and underflow during calculations.

- **Constructor Initialization:** The constructor is used to initialize the contract with addresses of Token A, Token B, and the initial exchange rate.

## 🛡️Security Considerations:

- **Ownership Control::** Critical functions, such as setting the exchange rate, are restricted to the owner, preventing unauthorized modifications.

- **Balance Checks:** Before executing swaps, the contract checks whether it has sufficient balances of both Token A and Token B, as well as verifying that the user has an adequate balance of the token they want to swap.

- **Input Validation:** The contract validates that input amounts are greater than zero and the new exchange rate is a positive value.

## 💡Efficiency and Gas Optimization:

- **SafeMath Usage:** SafeMath is employed to prevent potential vulnerabilities associated with integer overflow or underflow, contributing to gas efficiency.

- **Event Emission:** The contract emits the `Swap` event to provide transparency without compromising gas efficiency, allowing external applications to monitor swap occurrences.

## 🎯 Project Purpose:
The TokenSwap smart contract is designed to serve as a decentralized and transparent platform for exchanging ERC-20 tokens. The primary purpose of this project is to enable users to swap Token A for Token B and vice versa, utilizing a flexible and owner-controlled exchange rate. This project addresses the need for a secure and efficient mechanism for token swaps on the Ethereum blockchain


## 📝Instructions for Reviewers:

- Evaluate the ownership control mechanisms, ensuring that only the contract owner can modify critical parameters.

- Test the contract thoroughly, considering various scenarios for swapping Token A to B and vice versa.

- Assess the security considerations implemented, including balance checks and input validation.

- Verify the gas efficiency of the contract, identifying areas where optimizations can be made.

- Consider the flexibility and user-friendliness of the contract for token swaps.

    
## 📩 Feedback

If you have any feedback, please reach out to us at krritik0987@gmail.com
<p align="center">
<img src="https://img.shields.io/badge/Author-@Ritik-critical" />
</p>
<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ritik-kumar-0243b9260/) 
</div>


