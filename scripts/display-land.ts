// Load Hardhat and other necessary libraries
const hre = require("hardhat");
const ethers = hre.ethers;
import { displayLand } from "../test/util/testHelpers";

// Define the script
async function main() {
  // Read the target address and land contract address from environment variables
  const targetAddress = process.env.PLAYER;
  const landContractAddress = process.env.LAND;

  console.log("Target address:", targetAddress);
  console.log("Land contract address:", landContractAddress);

  if (!targetAddress) {
    console.error("Error: Missing target address.");
    process.exit(1);
  }

  if (!landContractAddress) {
    console.error("Error: Missing land contract address.");
    process.exit(1);
  }

  // Load the deployed Land contract
  const landContract = await hre.ethers.getContractAt("Land", landContractAddress);
  await displayLand(landContract, targetAddress);
  // Call the getLand function with the target address
}

// Run the script
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
