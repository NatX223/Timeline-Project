# Timeline
A Farcaster mini app that monitizes memories and acheivements on Farcaster by coining them on Zora.

---  

## Live Link - https://farcaster.xyz/miniapps/5RHnu11U9EzF/timeline
## Demo - 

## Table of Contents  

1. [Overview](#overview)
2. [Problem Statement](#problem-statement)
3. [Solution](#solution)
4. [How It Works](#how-it-works)
5. [Technologies Used](#technologies-used)
6. [Setup and Deployment](#setup-and-deployment)  
7. [Future Improvements](#future-improvements)  
8. [Acknowledgments](#acknowledgments)  

---  

## Overview  

Timeline is a Farcaster-native platform that lets creators turn their social media moments into collectible, tokenized timelines. It helps users 
organize casts into story-driven sequences and earn support from the community.

Powered by Zora and Farcaster, Timeline makes it easy to publish on-chain content with built-in incentives for both creators and supporters. It's a 
simple way to preserve and monetize your digital story.

---  

## Problem Statement  

Decentralized platforms like Farcaster empower creators with ownership, but they lack tools for curating lasting content and generating sustainable 
rewards. Posts about a user's journey often disappear into feeds, offering limited value to both creators and supporters, who have few meaningful ways 
to engage or benefit 
from the content they support.

---  

## Solution  

Timeline is a platform where Farcaster users can easily curate and tokenize their journeys into tokenized timelines. Powered by Zora, each timeline 
can be seamlessly minted as a unique coin, enabling creators to monetize their stories and allow supporters to gain value through ownership and 
engagement. This makes it simple to discover, follow, and support a creator’s growth over time, while fostering a mutually rewarding ecosystem of 
storytelling and community interaction.

---  

## How It Works  

The working mechanism of the mini-app can be broken down into 8 steps

1. **Farcaster Connection**:
   - The user connects their farcaster account and wallet to the mini-app.
   - The FID of the user is then used to fetch details about them - username, pfp and wallet address.
2. **Timeline Creation**:  
   - User inputs basic Timeline data - name, cover image, tags, keyword(s) and supoorter allocation.  
   - The Neynar API is used to search for casts that relate to the keyword(s) and these casts are selected to compose the timeline.
   - The engagement on the each cast is then evealuated and then the percentage allocation for each user who interacts with the cast.
   - The reward manager contract for the Timeline is then initialized and supporter allocation set.
   - Zora SDK is used to tokenize the timeline with the reward manager contract address used as the `payoutRecipient` address.
3. **Supporter Rewards**:  
   - Whenever the timeline coin that was created is traded, it earns trading fees and they are split between the creator of the coin and the supporters
   - A supporter can claim their own share of the trading fees will is held in and paid out by the reward manager contract.

---  

## Technologies Used  

| **Technology**    | **Purpose**                                                 |  
|-------------------|-------------------------------------------------------------|
| **Zora**          | Use of Zora's createCoin and tradeCoin SDK functionalities. |  
| **Farcaster**     | Farcater mini-app development platform and Neynar API.      |
| **Solidity**      | Development and deployment of smart contracts.              |
| **Next.js**       | Frontend framework for building the user interface.         |  

### Zora

Zora is the engine behind timeline and it powers the tokenization of casts as well the engagement reward system. It was used in two primary ways.

- Coin Creation - The create coin function was used for easy creation of timeline coin, the ease of use made it possible for all users to create 
coins without having to worry about technicalities. The reward manager contract address was used as the `payoutRecipient` address.
Below is a code snippet showing how createCoin was used in the project.
```typescript
try {
  const coinParams = {
  name: timelineName,
  symbol: timelineName.substring(0, 3).toUpperCase(),
  uri: metadataUrl,
  payoutRecipient: rewardManager as Address,
  platformReferrer: rewardManager as Address,
  chainId: baseSepolia.id,
  currency: DeployCurrency.ETH,
};

console.log('Creating coin with params:', coinParams);
const result = await createCoin(coinParams, walletClient, publicClient, {
  gasMultiplier: 120,
});
```
The full code for how createCoin was used can be found [here](https://github.com/NatX223/farcaster-timeline/blob/master/src/components/CreateTimeline.
tsx). A transaction showing the use of the createCoin function can be found [here](https://sepolia.basescan.org/tx/
0x9aa8802e9d433dd64bfd63eca3859f6f5af7bb9bef6c4875d1dcdb3d11bc5194) 

- Trade Coin - Another key component that is integral to the project is the use of the trade Coin functionality. Timeline also gives users the ability 
to trade coins that other users have created.
Below is a code snippet showing how tradeCoin was used 
```typescript

``` 

### Farcaster

Farcaster is the platform we ebuilt on - making a mini-app for farcaster users to easily discover, engage with and share timelines. The Neynar API
was also instrumental in the project for fetching user profiles and casts.
Below is a code snippet showing how the Neynar API was used 
```typescript
const options = {
  method: 'GET',
  headers: {
    'x-neynar-experimental': 'false',
    'x-api-key': process.env.NEYNAR_API_KEY!,
  },
};
const response = await fetch(
  `https://api.neynar.com/v2/farcaster/user/bulk?fids=${fid}`,
  options
);
if (!response.ok) {
  return NextResponse.json({ error: 'Failed to fetch user profile' }, { status: response.status });
}
const data = await response.json();
if (data.users && data.users.length > 0) {
  return NextResponse.json({ user: data.users[0] });
}
return NextResponse.json({ error: 'User not found' }, { status: 404 });
``` 
The full code for how Neynar API and its responses was used can be found [here](https://github.com/NatX223/farcaster-timeline/blob/master/src/app/api/
user-profile/route.ts).

### Solidity

The reward manager factory contract was developed and deployed to aid the easy use of reward manager contracts and in turn the reward manager 
contracts were used to handle the supporter earnings payout.
- The smart contracts were deployed on the Base Sepolia testnet, below is a table showing the contracts deployed and their addreess

| **Contract**        | **Addres**                                 | **Function**                                                             |
|---------------------|--------------------------------------------|--------------------------------------------------------------------------|
| **ManagerFactory**  | 0xf87C8aDc1442e122fE0B68a1e615B105b6095f78 | Deploying reward manager contracts                                       |
| **RewardManager**   | 0x72b3d2f2127b7bbbb25d85c8d065687c472c6dfa | payout recipient and Supporter earnings payout                           |


### Next.js

The Next.js code can be found [here](https://github.com/NatX223/farcaster-timeline/)


## Setup and Deployment  

### Prerequisites  

- Node.js v16+
- Solidity development environment(Hardhat recommended)
- Blockchain wallets (private key)
- Farcaster app/account 

### Local Setup  

- Smart contracts

clone the repository first

```bash
  git clone https://github.com/NatX223/timeline-project  
```

1. Navigate to the smart contracts directory:  
  ```bash  
  cd contracts  
  ```  
2. Install dependencies:  
  ```bash  
  npm install  
  ```  
3. Set up environment variables:
  ```  
  SIGNER=<your private key>
  BASE_RPC_URL=https://base-sepolia.drpc.org
  ```  
4. set base sepolia as a network in the hardhat.config file
```javascript
  networks: {
    base: {
      url: process.env.BASE_RPC_URL,
      accounts: [process.env.SIGNER]
    },
  },
```
5. Compile smart contracts:
  ```bash  
  npx hardhat compile  
  ```  
6. Run some tests:
  ```bash
  npx hardhat test
  ```
7. Run deployment scripts:
  ```bash
  npx hardhat run scripts/rewardmanagerfactory.js --network base
  ```
  ```bash
  npx hardhat run scripts/deployManager.js --network base
  ```

- Mini-app

clone the repository

```bash
  git clone https://github.com/NatX223/farcaster-timeline  
```

1. Navigate to .env.example and set your parameters right
2. Run it localy:  
  ```bash  
  npm run dev  
  ```  
3. View the mini-app:
   Open the farcaster mobile app and enable developer settings
   Open the developer tab in the settings of the app
   Enter the url presented in step 2 in the terminal into the preview input

---

## Future Improvements

1. Fully publish the mini-app.
2. Make it available as a stand alone service/platform
3. Extensive audits on the protocol's smart contracts.
4. Mainnet deployment.

---  

## Acknowledgments  

Special thanks to **Zora Coinathon** organizers: Zora, Farcaster and Encode. The Zora SDK played a pivotal role in building Timeline functionality and 
impact.
