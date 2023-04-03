const hre = require("hardhat");
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../Constatnts");

async function main() {
  const whiteListAddress = WHITELIST_CONTRACT_ADDRESS;

  const metaURL = METADATA_URL;

  const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");
  const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
    whiteListAddress,
    metaURL
  );

  await deployedCryptoDevsContract.deployed();

  console.log(
    `crypto devs contract deployed at address ${deployedCryptoDevsContract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
