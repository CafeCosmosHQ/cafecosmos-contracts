import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract, Wallet } from "ethers";
import { ethers, network, waffle } from "hardhat";

//import mockItems from "../test/util/mockItems";
import { ether } from "../test/util/testHelpers";

import { config as dotenvConfig } from "dotenv";
import { resolve } from "path";
import { homedir } from "os";
dotenvConfig({ path: resolve(__dirname, "./.env") });

var fs = require("fs");

//open json file and read it
const rawdata = fs.readFileSync("./static/CCItemIds/itemIds.json");
const itemIds = JSON.parse(rawdata);

const COOKINGCOST = ether(1);
const SOFTCOST = ether(300);
const PREMIUMCOST = ether(25);

const SCALE = 1;

async function main() {
  let [owner, burn, DAO, test_player, any] = await ethers.getSigners();

  let nethereum_player = "0x12890d2cce102216644c59dae5baed380d84830c";
  await any.sendTransaction({
    to: nethereum_player,
    value: ethers.utils.parseEther("20"),
  });

  const blockNumBefore = await ethers.provider.getBlockNumber();
  const blockBefore = await ethers.provider.getBlock(blockNumBefore);
  const timestampBefore = blockBefore.timestamp;
  const FOUR_YEARS = 4 * 365 * 24 * 60 * 60;

  const SoftToken = await ethers.getContractFactory("SoftToken");
  const Items = await ethers.getContractFactory("Items");
  const Land = await ethers.getContractFactory("Land");
  const Transformations = await ethers.getContractFactory("Transformations");
  const DividendFactory = await ethers.getContractFactory("DividendFactory");
  const Vesting = await ethers.getContractFactory("Vesting");

  console.log("Deploying contracts...");
  console.log("deploying softToken...");
  const softToken = await SoftToken.deploy("CafeCoin", "CAFE");
  console.log("deploying premiumToken...");
  console.log("deploying Items...");
  const items = await Items.deploy("http://ipfs.io/");
  const land = await Land.deploy();
  console.log("deploying Transformations...");
  const transformation = await Transformations.deploy();
  console.log("deploying DividendFactory...");
  const dividendFactory = await DividendFactory.deploy();
  console.log("deploying Vesting...");
  const vesting = await Vesting.deploy(dividendFactory.address, timestampBefore, FOUR_YEARS, softToken.address);

  console.log("Configuring land...");
  //config
  await land.setPremiumToken(softToken.address);
  await land.setItems(items.address);
  await land.setPremiumCost(PREMIUMCOST);
  await land.setPremiumDestination(DAO.address);
  await land.setDividendFactory(dividendFactory.address);
  await land.setCookingCost(COOKINGCOST);
  await land.setChair(itemIds.pink_chair, true);
  await land.setTable(itemIds.pink_table, true);
  await land.setVesting(vesting.address);

  console.log("Configuring items...");
  //items
  await items.setLand(land.address); //for transformation minting

  console.log("Transfering to vesting...");
  //vesting
  softToken.transfer(vesting.address, ether(10000));

  console.log("Configuring dividendFactory...");
  //dividend factory
  await dividendFactory.setRewardToken(softToken.address);
  await dividendFactory.setMinter(land.address, true);
  await dividendFactory.createPool(itemIds.pizza);
  let poolId = await dividendFactory.getPoolIdFromIdentifier(itemIds.pizza);

  console.log("Configuring land parameters...");
  //config land
  //TODO: this is being declared twice we need to get rid of this function

  const addresses = {
    softToken: softToken.address,
    items: items.address,
    land: land.address,
    transformation: transformation.address,
    dividendFactory: dividendFactory.address,
    vesting: vesting.address,
  };

  if (!fs.existsSync("./static/deployment")) {
    fs.mkdirSync("./static/deployment");
  }
  fs.writeFileSync(`./static/deployment/addresses.json`, JSON.stringify(addresses));

  //if unity path configured save to unity
  if (process.env.CAFECOSMOS_UNITY_PATH) {
    const unity_path = (process.env.CAFECOSMOS_UNITY_PATH + "/Assets").replace("~", homedir());

    if (fs.statSync(unity_path)) {
      console.log("Saving addresses to unity assets...");
      fs.writeFileSync(unity_path + "/addresses.json", JSON.stringify(addresses));
    } else {
      console.log("Unity directory does not exist");
    }
  } else {
    "Unity path not configured in .env" + process.env.CAFECOSMOS_UNITY_PATH;
  }

  console.log("softToken", softToken.address);
  console.log("premiumToken", premiumToken.address);
  console.log("items", items.address);
  console.log("land", land.address);
  console.log("transformation", transformation.address);
  console.log("dividendFactory", dividendFactory.address);
  console.log("vesting", vesting.address);

  //setting up test parameters
  await items.mint(nethereum_player, itemIds.pink_chair, 100, "0x0003");
  await items.mint(nethereum_player, itemIds.avocado, 100, "0x0003");
  await items.mint(nethereum_player, itemIds.avocado, 100, "0x0003");
  await items.mintBatch(
    nethereum_player,
    [
      1, 2, 107, 4, 106, 3, 22, 5, 6, 8, 9, 10, 11, 16, 15, 12, 113, 37, 13, 14, 43, 18, 49, 92, 90, 80, 34, 98, 97, 93,
      94, 16, 114, 116, 115, 83, 76, 72, 79, 82, 95, 68, 96,
    ],
    [
      9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900,
      9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900, 9900,
      9900, 9900, 9900, 9900, 9900,
    ],
    "0x0003",
  );

  await land.initializePlayer();
  let [soft_cost, premium_cost] = await land.calculateLandCost(owner.address, 2, 2);
  softToken.transfer(nethereum_player, soft_cost.mul(300));
  premiumToken.transfer(nethereum_player, premium_cost.mul(300));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
