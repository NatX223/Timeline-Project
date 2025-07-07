const { log } = require('console');
const fs = require('fs'); 
const { ethers } = require('hardhat');

async function main() {
    const [signer] = await ethers.getSigners();
    const ownerAddress = await signer.getAddress();
    const zoraToken = "0x1111111111166b7FE7bd91427724B487980aFc69";

    console.log("Deploying with address:", ownerAddress);

    const managerFactory = await ethers.getContractFactory('RewardManagerFactory', signer);
    const managerfactory = await managerFactory.deploy(zoraToken);
    const managerfactoryAddress = await managerfactory.getAddress();

    console.log(`RewardManagerFactory deployed to: ${managerfactoryAddress}`);

    // Deploy RewardManager contract
    // console.log("deploying reward manager");
    // await deployRewardManager(managerfactoryAddress, signer);
    // console.log(`Deployed RewardManager contract`);

    // Get all deployed contracts to verify
    // const contractAddress = await managerfactory.getDeployedContract();
    // console.log("All deployed contract addresses:", contractAddress);

    // // Save all addresses to a file
    // const addresses = {
    //     rewardManagerFactory: managerfactoryAddress
    // };

    // fs.writeFileSync('deployedAddresses.json', JSON.stringify(addresses, null, 2));
    // console.log('All addresses have been saved to deployedAddresses.json');
}

async function deployRewardManager(managerfactoryAddress, signer) {
    console.log("Getting RewardManagerFactory contract at:", managerfactoryAddress);
    const managerfactoryContract = await ethers.getContractAt("RewardManagerFactory", managerfactoryAddress, signer);

    const addresses = [ "0xa94F8d94f0FcFFee6de5d0D4d7D2711B54133Dd0", "0x3627EB23F76B9Ae94Ed9729dA6d10a10233Cc875" ];
    const percentages = [ 6000, 4000];

    console.log("Prepared addresses:", addresses);
    console.log("Prepared percentages:", percentages);

    console.log("Sending deployRewardManager transaction...");
    const deployTx = await managerfactoryContract.deployRewardManager({
        gasLimit: 10000000,
        gasPrice: ethers.parseUnits('8', 'gwei')
    });

    console.log("Transaction sent. Hash:", deployTx.hash);
    console.log("Waiting for transaction to be mined...");

    const receipt = await deployTx.wait();

    console.log("Transaction mined in block:", receipt.blockNumber);
    console.log("Gas used:", receipt.gasUsed.toString());
    console.log("RewardManager deployed successfully.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});