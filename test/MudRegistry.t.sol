import { CafeCosmosConfig } from "../src/codegen/tables/CafeCosmosConfig.sol";
import { MudTestFoundry } from "./util/MudTestFoundry.t.sol";
// import { QuestDTO, RewardDTO, QuestTaskDTO } from "../src/libraries/Types.sol";
import { QuestData, Quest, RewardData, QuestTaskData } from "../src/codegen/index.sol";
import { QuestTaskDTO, QuestDTO, RewardDTO, QuestTaskDTO } from "../src/libraries/LibQuests.sol";
import { InitialLandItem } from "../src/libraries/LibInitialLandItemsStorage.sol";

contract MudRegistryTest is MudTestFoundry {

    function setUp() public virtual override {
        super.setUp();
    }

    function test_TableRegistry() public {
        assertEq(CafeCosmosConfig.getCookingCost(), 0);
    }

    function test_SystemRegistry() public {
        // world.calculateLandCost(1, 1);
    }

    function test_SystemRegistryCustomType() public {

        InitialLandItem[] memory items = new InitialLandItem[](1);
        items[0] = InitialLandItem(1, 1, 1, 1, true);

        world.setInitialLandItems(items, 1, 1);
    }
}


