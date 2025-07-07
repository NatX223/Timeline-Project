const { ethers } = require('hardhat');

async function main() {
    // The deployed RewardManagerFactory address
    const factoryAddress = "0x10B84362072E1E71b390546B2324e0111E51a03c";
    const [signer] = await ethers.getSigners();

    // Get the factory contract instance
    const factory = await ethers.getContractAt("RewardManagerFactory", factoryAddress, signer);

    // Deploy a new RewardManager contract
    console.log("Deploying new RewardManager contract...");
    const deployTx = await factory.deployRewardManager();
    await deployTx.wait();
    console.log("RewardManager contract deployed.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
