import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

// 추가: gas reporter 플러그인 설치 후 필요
import "hardhat-gas-reporter";

dotenv.config({ path: __dirname + "/.env" });
const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY || "";
console.log("PrivateKey set:", !!ACCOUNT_PRIVATE_KEY);

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.19",
      },
      {
        version: "0.8.24", // 또는 필요한 다른 버전 추가
      },
    ],
  },
  paths: {
    artifacts: "./src",
  },
  networks: {
    opencampus: {
      url: `https://rpc.open-campus-codex.gelato.digital/`,
      accounts: [ACCOUNT_PRIVATE_KEY],
    },
    // 다른 네트워크도 추가할 수 있음
  },
  etherscan: {
    apiKey: {
      opencampus: "xxx",
    },
    customChains: [
      {
        network: "opencampus",
        chainId: 656476,
        urls: {
          apiURL: "https://opencampus-codex.blockscout.com/api",
          browserURL: "https://opencampus-codex.blockscout.com",
        },
      },
    ],
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    outputFile: process.env.REPORT_GAS ? "gas-report.txt" : undefined,
    noColors: process.env.REPORT_GAS !== undefined,
  },
};

export default config;
