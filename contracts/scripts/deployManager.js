const { ethers } = require('hardhat');

async function main() {
    // The deployed RewardManagerFactory address
    const factoryAddress = "0xf87C8aDc1442e122fE0B68a1e615B105b6095f78";
    const [signer] = await ethers.getSigners();

    // Get the factory contract instance
    const factory = await ethers.getContractAt("RewardManagerFactory", factoryAddress, signer);

    // Deploy a new RewardManager contract
    console.log("Deploying new RewardManager contract...");
    const deployTx = await factory.deployRewardManager({
        gasLimit: 10000000,
        gasPrice: ethers.parseUnits('8', 'gwei')
    });
    await deployTx.wait();
    console.log("RewardManager contract deployed.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
