import { config as dotenvConfig } from "dotenv";
import { resolve } from "path";
import { homedir } from "os";
dotenvConfig({ path: resolve(__dirname, "./.env") });

var fs = require("fs");

var codegen = require("nethereum-codegen");

var crafting = require("../artifacts/contracts/Crafting.sol/Crafting.json");
var dividendFactory = require("../artifacts/contracts/DividendFactory.sol/DividendFactory.json");
var land = require("../artifacts/contracts/Land.sol/Land.json");
var transformations = require("../artifacts/contracts/Transformations.sol/Transformations.json");
var vesting = require("../artifacts/contracts/Vesting.sol/Vesting.json");
var softToken = require("../artifacts/contracts/tokens/SoftToken.sol/SoftToken.json");
var premiumToken = require("../artifacts/contracts/tokens/PremiumToken.sol/PremiumToken.json");
var items = require("../artifacts/contracts/tokens/Items.sol/Items.json");

var projectName = "VisionsContracts.csproj";
var basePath = "Nethereum/VisionsContracts";
var baseNamespace = "VisionsContracts.Contracts";

import { config } from "hardhat";

console.log("Generating C# classes...");
codegen.generateAllClasses(
  JSON.stringify(crafting.abi),
  JSON.stringify(crafting.bytecode),
  crafting.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(dividendFactory.abi),
  JSON.stringify(dividendFactory.bytecode),
  dividendFactory.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(land.abi),
  JSON.stringify(land.bytecode),
  land.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(transformations.abi),
  JSON.stringify(transformations.bytecode),
  transformations.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(vesting.abi),
  JSON.stringify(vesting.bytecode),
  vesting.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(softToken.abi),
  JSON.stringify(softToken.bytecode),
  softToken.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(premiumToken.abi),
  JSON.stringify(premiumToken.bytecode),
  premiumToken.contractName,
  baseNamespace,
  basePath,
  0,
);

codegen.generateAllClasses(
  JSON.stringify(items.abi),
  JSON.stringify(items.bytecode),
  items.contractName,
  baseNamespace,
  basePath,
  0,
);

//if .env file exists, and the value for CAFECOSMOS_UNITY
if (fs.existsSync(process.env.CAFECOSMOS_UNITY_PATH)) {
  console.log("Copying generated C# classes to Unity project...");
  fs.cp(
    "./Nethereum/VisionsContracts",
    process.env.CAFECOSMOS_UNITY_PATH + "/Assets/VisionsContracts",
    { recursive: true },
    err => {
      if (err) {
        console.error(err);
      }
    },
  );
}
