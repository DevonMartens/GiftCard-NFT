/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require('dotenv').config()
 require("@nomiclabs/hardhat-etherscan");
 require("@nomiclabs/hardhat-waffle");
 require('hardhat-abi-exporter');
 require('hardhat-preprocessor');
 require('hardhat-spdx-license-identifier');
 require('hardhat-docgen');

 module.exports = {
   defaultNetwork: "ropsten",
   solidity: {
     version: "0.8.4",
     settings: {
       optimizer: {
         enabled: true,
         runs: 500
       }
     }
   },
   paths: {
     sources: "./contracts",
     cache: "./cache",
     artifacts: "./artifacts"
   },
   networks: {
     ropsten: {
       url: `https://ropsten.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
       accounts: [`0x${process.env.PRIVATE_KEY}`]
     },
     mainnet: {
         url: `https://mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
         accounts: [`0x${process.env.PRIVATE_KEY}`]
     },
     localhost: {
         url: "http://0.0.0.0:6690"
       }
   },
   abiExporter: {
     path: "./data/abi",
     clear: true,
     flat: true
   },
   docgen: {
     path: "./docs",
     clear: true,
     runOnCompile: true,
   },
   preprocess: {
   },
   etherscan: {
       apiKey: process.env.ETHERSCAN_KEY
   },
   spdxLicenseIdentifier: {
     overwrite: true,
     runOnCompile: true,
    }
};
