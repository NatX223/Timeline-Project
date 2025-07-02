const { ethers } = require('hardhat');

async function main() {
    // Replace with your deployed RewardManager contract address
    const rewardManagerAddress = "0xc6b05c8bf7fa9b336be17b3f56279aa4ff29388a";

    const addresses = [ "0xa94F8d94f0FcFFee6de5d0D4d7D2711B54133Dd0", "0x3627EB23F76B9Ae94Ed9729dA6d10a10233Cc875" ];
    const percentages = [ 6000, 4000]

    const [signer] = await ethers.getSigners();

    // Get the contract instance
    const rewardManager = await ethers.getContractAt("RewardManager", rewardManagerAddress, signer);

    // Call the initialize function
    const tx = await rewardManager.initialize(addresses, percentages, {
        gasLimit: 1000000,
        gasPrice: ethers.parseUnits('8', 'gwei')
    });
    await tx.wait();

    console.log(`RewardManager at ${rewardManagerAddress} initialized.`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});