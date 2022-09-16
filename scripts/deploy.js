const hre = require("hardhat");

async function main() {




  // We get the contract to deploy
  const NFTGiftCard = await hre.ethers.getContractFactory("NFTGiftCard");
  const nftGiftCard = await NFTGiftCard.deploy("GiftCard", "GNFT");

  await nftGiftCard.deployed();

  console.log("NFTGiftCard contract deployed to:", nftGiftCard.address);
}
//deploy me using the line below
//   npx hardhat run scripts/deploy.js --network ropsten
//verify me
//npx hardhat verify contact address --network ropsten contstructor args



// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
