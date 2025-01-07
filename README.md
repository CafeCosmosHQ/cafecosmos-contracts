Install Juan Blanco's Solidity extension

# How to run the e2e in Nethereum

## Building the contracts
1. `$ chmod +x ./buildContracts.sh`
2. `$./buildContracts.sh`

## Adding systems and tables
3. Add new system's ABI to "paths" in `./nethereum-gen.multisettings` as
   `"out/[SYSTEM_NAME]System.sol/[SYSTEM_NAME]System.json"`
4. Right click `./nethereum-gen.multisettings` and click `Solidity: Code Generate Definitions...`
5. Go to `.../VisionsDotNet/VisionsContracts/Land/LandTablesServices.cs`
6. add `public [TABLE_NAME]TableService [TABLE_NAME] { get; private set; }` to the LandTableServices class
7. Intantiate `[TABLE_NAME] = new [TABLE_NAME]TableService(web3, contractAddress);` in the `LandTablesServices(...)` function
8. Pass in `[TABLE_NAME]` to `TableServices`
9.  Go to `./VisionsDotNet/VisionsContracts/Land/LandSystems.cs`
10. add `[SYSTEM_NAME]SystemService [SYSTEM_NAME] { get; private set; }` to the LandSystems class
11. Intantiate `[SYSTEM_NAME] = new [SYSTEM_NAME]SystemService(web3, contractAddress);` in the `LandSystems(...)` function
12. Pass in `[SYSTEM_NAME]` to `SystemServices`

## Running tests
1. run `anvil --init VisionsDotNet/testchain/anvil/genesis.json`
2. right click on VisionsDotNet/VisionsContracts and click debug. Then check the panel on the side with the bug and play button on the left of VSCode

## Extending contract functionality for Unity
`VisionsDotNet/VisionsContracts/[SYSTEM_NAME]InteractionSystemServiceExt.cs` is where you can write extensions of the contract functions for extending functionality. Good example is `LandItemInteractionSystemServiceExt.cs`

## Clearing Anvil cache

`rm -rf /root/.foundry/anvil/tmp/`


## Adding/Changing Items
Do not change the ID's

Go to `VisionsDotNet/VisionsContracts/Items/DefaultItems.cs`

## Adding / Changin Transformations

Go to `VisionsDotNet/VisionsContracts/Transformations/DefaultTransformations.cs`

## Deploying the contracts
1. `cd VisionsDotNet/VisionContracts.Deployment.Console`
2. `dotnet run`