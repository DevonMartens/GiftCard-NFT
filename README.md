# Gift Card NFT

To run

### Run

```
npm i
```

### Create an .env following with the following information
```
PRIVATE_KEY = Your Private Key
ETHERSCAN_KEY = Your Etherscan Key
INFURA_PROJECT_ID = Your Project Id Key
```

# About Project

This is a gamified gift Card NFT app.

The NFT contract that sells the NFT's uses a merkle tree for cheaper storage of the whitelist's address.

This is gamified so it is set up with the ERC-20 contract so that if a user tries to spend tokens but doesn't have the gift card or doesnt send the gift card with a sale the new holder can come claim.

The user can use ERC-20 tokens to buy ERC-721 tokens by burning them.

There is a contract that deploys the gambling contracts.

The rewards for these are ERC-20 and ERC-721. 



Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
