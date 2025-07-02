const { ethers } = require('hardhat');

async function main() {
    // Replace with your deployed RewardManager contract address
    const rewardManagerAddress = "0xc6b05c8bf7fa9b336be17b3f56279aa4ff29388a";

    const [signer] = await ethers.getSigners();

    // Get the contract instance
    const rewardManager = await ethers.getContractAt("RewardManager", rewardManagerAddress, signer);

    try {
        const userAllocation = await rewardManager.userEarnings(signer.address);
        console.log("User allocation:", userAllocation);

        const claimable = ethers.parseEther("0.00005")
        await rewardManager.claim(claimable);
        console.log("Earnings claimed!");

        // const tx = await signer.sendTransaction({
        //   to: rewardManagerAddress,
        //   value: ethers.parseEther("0.005")
        // });
        // await tx.wait();
        // console.log("ETH sent!");
      } catch (err) {
        console.error("Send failed:", err);
      }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});