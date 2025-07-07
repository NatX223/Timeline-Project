# Timeline
A Farcaster mini app that monitizes memories and acheivements on Farcaster by coining them on Zora.

---  

## Live Link - https://farcaster.xyz/miniapps/5RHnu11U9EzF/timeline
## Demo - https://www.loom.com/share/4f746c4085b749e58f62f88594ac7a3d?sid=918a6bf4-cb10-46ea-8602-584a73612ea0

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
  const createZoraCoin = async (metadataUrl: string, timelineName: string, rewardManager: string) => {
    if (!walletClient || !address) {
      console.error('Wallet client or address not available');
      throw new Error('Wallet not connected');
    }

    try {
      const coinParams = {
        name: timelineName,
        symbol: timelineName.substring(0, 3).toUpperCase(),
        uri: metadataUrl as ValidMetadataURI,
        owners: [address as Address],
        payoutRecipient: rewardManager as Address,
        platformReferrer: rewardManager as Address,
        chainId: base.id,
        currency: DeployCurrency.ZORA,
        initialPurchase: { 
          currency: InitialPurchaseCurrency.ETH,
          amount: parseEther("0.0005"),
        },
      };

      console.log('Creating coin with params:', coinParams);
      console.log('connected chain', publicClient.chain)
      const result = await createCoin(coinParams, walletClient, publicClient, {
        gasMultiplier: 120,
      });
});
```
The full code for how createCoin was used can be found [here](https://github.com/NatX223/timeline/blob/master/src/components/CreateTimeline.tsx). A transaction showing the use of the createCoin function can be found [here](https://basescan.org/tx/0x90805b77d28937801010ddfb12d45381909c0e15797bf168c459d793782d5374) 

- Trade Coin - Another key component that is integral to the project is the use of the trade Coin functionality. Timeline also gives users the ability 
to trade coins that other users have created.
Below is a code snippet showing how tradeCoin was used 
```typescript
  const handleBuy = async () => {
    if (!walletClient || !address || !timeline?.coinAddress || !amount) return;
    setTxLoading(true);
    setTxError(null);
    setTxSuccess(null);
    try {
      const account = walletClient.account || address;
      const tradeParameters: TradeParameters = {
        sell: {
          type: 'erc20',
          address: '0x1111111111166b7FE7bd91427724B487980aFc69', // ZORA
        },
        buy: {
          type: 'erc20',
          address: timeline.coinAddress,
        },
        amountIn: parseEther(amount),
        slippage: 0.04,
        sender: address,
      };
      await tradeCoin({ tradeParameters, walletClient, account, publicClient });
      setTxSuccess('Buy transaction successful!');
    } catch (err: any) {
      setTxError(err.message || 'Transaction failed');
    } finally {
      setTxLoading(false);
    }
  };

  const handleSell = async () => {
    if (!walletClient || !address || !timeline?.coinAddress || !amount) return;
    setTxLoading(true);
    setTxError(null);
    setTxSuccess(null);
    try {
      const account = walletClient.account || address;
      const tradeParameters: TradeParameters = {
        sell: {
          type: 'erc20',
          address: timeline.coinAddress,
        },
        buy: {
          type: 'erc20',
          address: '0x1111111111166b7FE7bd91427724B487980aFc69', // ZORA
        },
        amountIn: parseEther(amount),
        slippage: 0.04,
        sender: address,
      };
      await tradeCoin({ tradeParameters, walletClient, account, publicClient, validateTransaction: false });
      setTxSuccess('Sell transaction successful!');
    } catch (err: any) {
      setTxError(err.message || 'Transaction failed');
    } finally {
      setTxLoading(false);
    }
  };
``` 

The full code for how tradeCoin was used can be found [here](https://github.com/NatX223/timeline/blob/master/src/components/timeline/TimelineView.tsx). Transactions 
showing the use of the createCoin function can be found [here](https://basescan.org/tx/0x8c98a704ec7c4cf91097b3810a05e472a920b53a36bbb61102b03d8942f84ce7) and [here](https://basescan.org/tx/0x2fbe7296144752550939a15f3ac8d49b0f80d3df0b6498d9a81301a1abf7872f)

The table below showcases the different transaction types and some examples

| **TX type**         | **TX example**                                                                             |
|---------------------|--------------------------------------------------------------------------------------------|
| **Create Coin**     | https://basescan.org/tx/0x90805b77d28937801010ddfb12d45381909c0e15797bf168c459d793782d5374 |
| **Sell Coin**       | https://basescan.org/tx/0x8c98a704ec7c4cf91097b3810a05e472a920b53a36bbb61102b03d8942f84ce7 |
| **Buy Coin**        | https://basescan.org/tx/0x2fbe7296144752550939a15f3ac8d49b0f80d3df0b6498d9a81301a1abf7872f |
| **Claim fess**      | https://basescan.org/tx/0x2fbe7296144752550939a15f3ac8d49b0f80d3df0b6498d9a81301a1abf7872f |

### Farcaster

Farcaster is the platform we built on - making a mini-app for farcaster users to easily discover, engage with and share timelines. The Neynar API
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

The mini app manifast is shown below:

![mini app manifest](/manifest.png)

The full code for how the Neynar API and its responses was used can be found [here](https://github.com/NatX223/timeline/blob/master/src/app/api/user-profile/route.ts).

### Solidity

The reward manager factory contract was developed and deployed to aid the easy use of reward manager contracts and in turn the reward manager 
contracts were used to handle the supporter earnings payout.
- The smart contracts were deployed on the Base Sepolia testnet, below is a table showing the contracts deployed and their addreess

| **Contract**        | **Addres**                                 | **Function**                                  |
|---------------------|--------------------------------------------|-----------------------------------------------|
| **ManagerFactory**  | 0x10B84362072E1E71b390546B2324e0111E51a03c | Deploying reward manager contracts            |
| **RewardManager**   | 0xdd3cb7de06e209d760c8b886e6ca7bcc2a0f1c8b | payout recipient and Supporter earnings payout|

### Next.js

The Next.js code can be found [here](https://github.com/NatX223/timeline/)


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
  git clone https://github.com/NatX223/timeline  
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
