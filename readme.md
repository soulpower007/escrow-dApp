
# DeFi: Decentralized Escrow Application

This is an Escrow Dapp for my Blockchain final Project.

## Project Layout

There are three top-level folders:

1. `/app` - contains the front-end application
2. `/contracts` - contains the solidity contract
3. `/tests` - contains tests for the solidity contract

## Setup

Install dependencies in the top-level directory with `npm install`.

Go into the contracts folder

Compile the contracts using `npx hardhat compile`. The artifacts will be placed in the `/app` folder, which will make it available to the front-end. This path configuration can be found in the `hardhat.config.js` file.

You can alternatively use remix.ethereum.org to deploy the contract in `contracts/EscrowList.sol` and fetch the contract address and update the environment file with it.

## Front-End

`cd` into the `/app` directory and run `npm install`

To run the front-end application run `npm start` from the `/app` directory. Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

Reference: https://github.com/eduairet/escrow-hardhat
