# Foundry Template [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gitpod]: https://gitpod.io/#https://github.com/Wildanzr/base-x-rareskills
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/Wildanzr/base-x-rareskills/actions
[gha-badge]: https://github.com/Wildanzr/base-x-rareskills/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

A Foundry-based template for developing Solidity smart contracts, with sensible defaults. Forked from
[PaulRBerg/foundry-template](https://github.com/PaulRBerg/foundry-template).

## Base x RareSkills

This is a learning bootcamp from Base in collaboration with RareSkills. Learning about Blacklists, blacklist bypasses,
pausable tokens, fee-on-transfer-tokens, re-entrancy, WETH, tokens with an unusual number of decimals, SafeTransferFrom,
SafeApprove, and corner cases with zero transfers or the zero address, ERC-721, ERC-1155, wrapped NFTs.

### Homework 1

Creating an implementation of ERC20 token but not using any standard library like OpenZeppelin. The goal is to learn how
to implement the ERC20 token from scratch (NOT RECOMMENDED FOR PRODUCTION). Also creating a simple contract to deposit
ERC20 with proper safe transfer from OpenZeppelin library.

### Homework 2

Helpful reading:

https://www.rareskills.io/post/solidity-beginner-mistakes

https://github.com/d-xo/weird-erc20

Finding a bug in the implementation of ERC20 token freeze utility and spot other serious vulnerabilities in the code.

#### Method to expliot the bug:

1. Using `transferFrom` instead of `transfer` to bypass the freeze check, because the check is depends on the
   `msg.sender`.
2. Even though it's being frozen, it can still be burned.

Vulnerabilities found:

1. Anyone can burn someone else's tokens.

#### Notes for NotBasedRewarder contract:

1. Any deposit to the contract will transfer `rewardToken`, not the `depositToken`, but the withdraw function will
   transfer the `depositToken`, not the `rewardToken`.
2. The check for `deposit` function is greater than the allowance given, leading to the depositor can't deposit all of
   their allowance, and only able for allowance - 1.
3. The check for for `withdraw` function is greater than deposit amount, leading to the depositor can't withdraw all of
   their deposit, and only able for depositedAmount - 1.

#### Method to make deposited token got stuck:

1. When rewardToken or depositToken is paused, then any transfer will be reverted.
2. When rewarder doesn't have enough rewardToken to transfer, then transfer event of the rewardToken will be reverted.

## License

This project is licensed under MIT.
