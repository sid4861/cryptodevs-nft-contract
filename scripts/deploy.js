const { ethers } = require("hardhat");
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

const main = async () => {
    const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs")
    const deployedCryptoDevsContract = await cryptoDevsContract.deploy(METADATA_URL, WHITELIST_CONTRACT_ADDRESS);
    await deployedCryptoDevsContract.deployed();

    console.log(deployedCryptoDevsContract.address);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    })