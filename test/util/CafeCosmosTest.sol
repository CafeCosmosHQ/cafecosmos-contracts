import {Items} from "../../src/tokens/Items.sol";
import {TransformationsData} from "../../src/codegen/tables/Transformations.sol";
import {LandTablesAndChairsContract} from "../../src/systems/LandTablesAndChairsContract.sol";
import {LandTransform} from "../../src/systems/LandTransform.sol";
import {PerlinItemConfig} from "../../src/PerlinItemConfig.sol";
import {SoftToken} from "../../src/tokens/SoftToken.sol";
import {LandNFTs} from "../../src/tokens/LandNFTs.sol";
import {Redistributor} from "../../src/Redistributor.sol";
import {Vesting} from "../../src/Vesting.sol";
import {LandQuestTaskProgressUpdate} from "../../src/systems/LandQuestTaskProgressUpdate.sol";
import {MI} from "../MockItems.sol";
import {MockERC1155Receiver} from "./MockERC1155Receiver.sol";
import "forge-std/console.sol";
import {IWorld} from "../../src/codegen/world/IWorld.sol";
import { ActiveStoves, CafeCosmosConfig, ConfigAddresses, Inventory, 
        ItemInfo, LandCell, LandInfo, LandItem, LandItemCookingState, 
        LandPermissions, StackableItem, WaterController, 
        LandTablesAndChairs, Transformations} from "../../src/codegen/index.sol";
import {MudTestFoundry} from "./MudTestFoundry.t.sol";


contract CafeCosmosTest is MudTestFoundry {

    LandTablesAndChairsContract private landTablesAndChairsContract;
    LandTransform private landTransform;
    PerlinItemConfig private perlinItemConfig;
    LandQuestTaskProgressUpdate private landQuestTaskProgressUpdate;
  
    Redistributor internal redistributor;
    Vesting internal vesting;
    SoftToken internal softToken;
    Items internal items;
    LandNFTs internal landNFTs;

    //land settings
    uint256 SOFTCOST = 300;
    uint256 PREMIUMCOST = 25;
    uint256 LAND_X = 3;
    uint256 LAND_Y = 3;
    uint256 SCALE = 1;
    uint256 COOKING_TIME = 120;
    uint256 COOKING_TIMEOUT = 600;
    uint256 COOKINGCOST = 10;

    //VRGDA
    int256 constant targetPrice = 10;
    int256 constant priceDecayPercent = 0.31e18;
    int256 constant perTimeUnit = 2e18;

    uint160 constant SEED_MASK = (1 << 32) - 1;
    uint256 constant DEFAULT_LAND_TYPE = 0;

    //water controller settings
    uint256 numSamples = 31;
    uint256 blockInterval = 1000;
    uint256 minYieldTime = 387;
    uint256 maxYieldTime = 707412;
    uint256 endBlockSlippage = 100;
    int256 minDelta = -54067095249;
    int256 maxDelta = 3870911308;

    enum RedistributorCategories {mains, drinks, desserts}
    RedistributorCategories foodCategories;

    function setUp() public virtual override {
        super.setUp();

        softToken = new SoftToken("SOFT", "SOFT");
        landNFTs = new LandNFTs("LAND", "LAND");
        items = new Items("http://ipfs.io/");
        redistributor = new Redistributor(address(softToken), worldAddress);
        vesting = new Vesting(address(redistributor), address(softToken));
        perlinItemConfig = new PerlinItemConfig();
        landTransform = new LandTransform();
        landTablesAndChairsContract = new LandTablesAndChairsContract();
        landQuestTaskProgressUpdate = new LandQuestTaskProgressUpdate();
        
        landNFTs.setLand(worldAddress);
        items.setMinter(worldAddress, true);
        redistributor.setLandAddress(worldAddress);

        ConfigAddresses.setSoftTokenAddress(address(softToken));
        ConfigAddresses.setLandNFTsAddress(address(landNFTs));
        ConfigAddresses.setSoftDestinationAddress(address(vesting));
        ConfigAddresses.setRedistributorAddress(address(redistributor));
        ConfigAddresses.setVestingAddress(address(vesting));
        ConfigAddresses.setPerlinItemConfigAddress(address(perlinItemConfig));
        ConfigAddresses.setLandTransformAddress(address(landTransform));
        ConfigAddresses.setLandTablesAndChairsAddress(address(landTablesAndChairsContract));
        ConfigAddresses.setItemsAddress(address(items));
        ConfigAddresses.setLandQuestTaskProgressUpdateAddress(address(landQuestTaskProgressUpdate));
        
        CafeCosmosConfig.setInitialLimitX(LAND_X);
        CafeCosmosConfig.setInitialLimitY(LAND_Y);
        CafeCosmosConfig.setSeedMask(SEED_MASK);
        CafeCosmosConfig.setChunkSize(100);

        world.setVrgdaParameters(targetPrice, priceDecayPercent, perTimeUnit);

        //tools
        uint256[] memory startingTools = new uint256[](5);
        startingTools[0] = 1010;
        startingTools[1] = 110;
        startingTools[2] = 111;
        startingTools[3] = 112;
        startingTools[4] = 108;
        
        CafeCosmosConfig.setStartingItems(startingTools);

        uint256[] memory startingToolsQuantities = new uint256[](5);
        startingToolsQuantities[0] = 1;
        startingToolsQuantities[1] = 1;
        startingToolsQuantities[2] = 1;
        startingToolsQuantities[3] = 1;
        startingToolsQuantities[4] = 1;

        CafeCosmosConfig.setStartingItemsQuantities(startingToolsQuantities);

        StackableItem.set(MI.FLOOR, MI.STOVE, true);
        StackableItem.set(MI.FLOOR, MI.CHAIR, true);
        StackableItem.set(MI.FLOOR, MI.TABLE, true);

        ItemInfo.setIsChair(MI.CHAIR, true);
        ItemInfo.setIsTable(MI.TABLE, true);

        //redistributor
        redistributor.createSubSection(65, "mains");
        redistributor.createSubSection(25, "desserts"); 
        redistributor.createSubSection(10, "drinks");
        
        redistributor.createPool(MI.MAC_N_CHEESE, uint256(RedistributorCategories.mains), true);
        redistributor.createPool(MI.SHAWARMA, uint256(RedistributorCategories.mains), true);
        redistributor.createPool(MI.PIZZA, uint256(RedistributorCategories.mains), true);
        redistributor.createPool(MI.BURGER, uint256(RedistributorCategories.mains), true);
    
        redistributor.createPool(MI.SMOOTHIE, uint256(RedistributorCategories.desserts), true);
        redistributor.createPool(MI.BANANA_MILK, uint256(RedistributorCategories.desserts), true);
        redistributor.createPool(MI.COFFEE, uint256(RedistributorCategories.desserts), true);
    
        redistributor.createPool(MI.CROISSANT, uint256(RedistributorCategories.drinks), true);
        redistributor.createPool(MI.CUPCAKE, uint256(RedistributorCategories.desserts), true);

        ItemInfo.setNonPlaceable(MI.MAC_N_CHEESE, true);
        ItemInfo.setNonPlaceable(MI.SHAWARMA, true);
        ItemInfo.setNonPlaceable(MI.PIZZA, true);
        ItemInfo.setNonPlaceable(MI.BURGER, true);
        ItemInfo.setNonPlaceable(MI.SMOOTHIE, true);
        ItemInfo.setNonPlaceable(MI.BANANA_MILK, true);
        ItemInfo.setNonPlaceable(MI.COFFEE, true);
        ItemInfo.setNonPlaceable(MI.CROISSANT, true);
        ItemInfo.setNonPlaceable(MI.CUPCAKE, true);

        //set non removable
        ItemInfo.setNonRemovable(MI.STOVE_COOKING, true);
        ItemInfo.setNonRemovable(MI.STONE, true);
        ItemInfo.setNonRemovable(MI.GRASS, true);
    }

    function setupPlayer(address _playerAddress) public returns (uint256 landId) {
        uint256 cost = world.calculateLandCost(LAND_X, LAND_Y);
        softToken.transfer(_playerAddress, cost);
        vm.startPrank(_playerAddress);
        softToken.approve(worldAddress, cost);
        landId = world.createLand(LAND_X, LAND_Y);
        vm.stopPrank();
    }
    
    function setupPlayer(address _playerAddress, uint256 landX, uint256 landY) public returns (uint256 landId) {
        uint256 cost = world.calculateLandCost(landX, landY);
        softToken.transfer(_playerAddress, cost);
        
        vm.startPrank(_playerAddress);
        softToken.approve(worldAddress, cost);
        landId = world.createLand(landX, landY);
        vm.stopPrank();
    }

    function adminPrank(address _playerAddress) public {
        vm.startPrank(_playerAddress);
    }

}