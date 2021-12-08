# Sample ERC-721 contract

This is a sample contract that I used to deploy my Solar collection with. It's provided as is and it should only be used at your own risk. I strongly recommend doing your own research into both how Solidity contracts work and the deployment itself, as there are numerous moving parts in each contract that can bite you if not done correctly.

## **Requirements**

### **Node version**

Either make sure you're running a version of node compliant with the engines requirement in package.json, or install Node Version Manager `nvm` and run `nvm use` to use the correct version of node.

## **Set-up**

1. Run `yarn install` at the root of your directory to install all dependencies
2. Open up `contracts/ERC721Contract.sol`, rename the contract to your liking and set Name and SYMBOL in the contract's constructor along with any other changes you wish to do to the contract itself
3. Create you ASCII art, an important step.
4. Go to https://etherscan.io/apis and get your Etherscan Api, input that in `truffle-config.js` under `api_keys/etherscan` to enable contract verification
5. Go to either https://www.alchemy.com/ or https://infura.io/ to get your Ethereum API (choose either one or the other, they both work)

## **Deployment**

### **Deploying to the Rinkeby network**

1. Add faux Ether for testing purposes on https://faucet.rinkeby.io
2. Using your API key (either Alchemy or Infura) and the mnemonic for your Metamask wallet run the below (make sure you're using a Metamask seed phrase that you're comfortable using for testing purposes).

```
set ALCHEMY_KEY="<your_alchemy_project_id>"
set MNEMONIC="<metamask_mnemonic>"
yarn truffle deploy --network rinkeby
```

Once deployed and tokens minted they will start showing up here:

```
https://testnets.opensea.io/assets/<contract_address>/<token_number>
```

### **Deploying to the Mainnet**

Check everything works on Rinkeby, then run the below. Make sure you double check both gas limit and gas price in `truffle-config.js`

```
set ALCHEMY_KEY="<your_alchemy_project_id>"
set MNEMONIC="<metamask_mnemonic>"
yarn truffle deploy --network live
```

### **Contract verification**

Run the below for Rinkeby verification with your contract name:

```
truffle run verify <contract_name> --network rinkeby
```

or this for Mainnet:

```
truffle run verify <contract_name> --network live
```

## **Fin**

If all went well you've successfully deployed and verified your smart contract. Congrats!