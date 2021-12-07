const HDWalletProvider = require("truffle-hdwallet-provider");

const MNEMONIC = process.env.MNEMONIC;
const NODE_API_KEY = process.env.INFURA_KEY || process.env.ALCHEMY_KEY;
const isInfura = !!process.env.INFURA_KEY;

const needsNodeAPI =
  process.env.npm_config_argv &&
  (process.env.npm_config_argv.includes("rinkeby") ||
    process.env.npm_config_argv.includes("live"));

if ((!MNEMONIC || !NODE_API_KEY) && needsNodeAPI) {
  console.error("Please set a mnemonic and ALCHEMY_KEY or INFURA_KEY.");
  process.exit(0);
}

const rinkebyNodeUrl = isInfura
  ? "https://rinkeby.infura.io/v3/" + NODE_API_KEY
  : "https://eth-rinkeby.alchemyapi.io/v2/" + NODE_API_KEY;

const mainnetNodeUrl = isInfura
  ? "https://mainnet.infura.io/v3/" + NODE_API_KEY
  : "https://eth-mainnet.alchemyapi.io/v2/" + NODE_API_KEY;

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      gas: 5000000,
      network_id: "*", // Match any network id
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(MNEMONIC, rinkebyNodeUrl);
      },
      gas: 5000000, // This is set to 5,000,000 wei as default gas which should be fine for your Rinkeby tests, adjust if needed more
      network_id: 4,
      skipDryRun: true,
    },
    live: {
      network_id: 1,
      provider: function () {
        return new HDWalletProvider(MNEMONIC, mainnetNodeUrl);
      },
      gas: 3000000, // Set this to a realistic gas needed that you will get from tests on Rinkeby
      gasPrice: 160000000000, // Set this to a realistic gas price on the day you deploy to mainnet, 50gwei = 50000000000
    },
  },
  mocha: {
    reporter: "eth-gas-reporter",
    reporterOptions: {
      currency: "USD",
      gasPrice: 2,
    },
  },
  compilers: {
    solc: {
      version: "0.8.7",
      settings: {
        optimizer: {
          enabled: true,
          runs: 20
        },
      },
    },
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: '' // Set this to your Etherscan API to enable truffle contract verification
  }
};