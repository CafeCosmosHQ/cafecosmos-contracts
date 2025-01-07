pragma solidity ^0.8.0; 

//import "forge-std/console.sol";
import "./interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./util/math/SafeMath.sol";
import "./interfaces/IRedistributor.sol";


// Import SafeMath or use Solidity ^0.8.0 which has overflow checks built-in
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Define the interfaces and contracts needed

contract Redistributor is Ownable, IRedistributor {
    using SafeMath for uint256; // If using a Solidity version below 0.8.0

    struct Pool {
        uint256 tokenBalance;
        uint256 totalShares;
        bool isActive;
    }

    struct SubSection {
        uint256 masterShares;
        uint256[] poolIds; // Store pool IDs instead of Pool objects
        string name;
    }

    struct SubSectionCreation {
        uint256 masterShares;
        string name;
        uint256[] poolIdentifiers;
    }

    IERC20 public token;
    address land;

    uint256 private precision = 1e18;
    uint256 private totalMasterShares;
    uint256 private heldInPools;
    SubSection[] public subSections;
    mapping(string => uint256) public subsectionNameToIndex; // Mapping from subsection name to index (for convenience);
    mapping(uint256 => Pool) private pools; // Mapping from pool ID to Pool object
    uint256 private nextPoolId; // Keep track of the next available pool ID
    mapping(uint256 => uint256) public identifierToPoolId;


    event PoolCreated(uint256 poolId, bool _isActive);
    event SharesMinted(uint256 poolId, uint256 shares);
    event FundsWithdrawn(uint256 poolId, uint256 amount);
    event PoolActivityChanged(uint256 _identifier, bool isActive);
    event EmptyWithdrawal(uint256 poolId, uint256 shares, uint256 totalShares);
    event SubSectionCreated(uint256 subsectionIndex, uint256 masterShares, string name);

    constructor(address _token, address _land) {
        token = IERC20(_token);
        land = _land;
        nextPoolId = 1;
    }

    modifier onlyLand() {
        require(msg.sender == land, "only the land contract is allowed to make this call");
        _;
    }

    function setLandAddress(address _land) public onlyOwner {
        land = _land;
    }

    function createSubSections(SubSectionCreation[] memory subsections) public onlyOwner {
        for (uint256 i = 0; i < subsections.length; i++) {
            uint256 subsectionIndex = createSubSection(subsections[i].masterShares, subsections[i].name);
            for (uint256 j = 0; j < subsections[i].poolIdentifiers.length; j++) {
                createPool(subsections[i].poolIdentifiers[j], subsectionIndex, true);
            }
        }
    }

    function createSubSection(uint256 _masterShares, string memory _name) public onlyOwner returns (uint256 subsectionIndex) {
        subsectionIndex = subSections.length; 
        SubSection memory newSubSection = SubSection({
            masterShares: _masterShares,
            poolIds: new uint256[](0),
            name: _name
        });
        subsectionNameToIndex[_name] = subsectionIndex;
        subSections.push(newSubSection); 
        totalMasterShares = totalMasterShares.add(_masterShares);

        emit SubSectionCreated(subsectionIndex, _masterShares, _name);
        return subsectionIndex;
    }

    //getSubsection
    function getSubSection(uint256 subsectionIndex) public view returns (SubSection memory subsection) {
        require(subsectionIndex < subSections.length, "Redistributor: Invalid subsection index");
        return subSections[subsectionIndex];
    }

    function createPool(uint256 _identifier, uint256 subsectionIndex, bool _isActive) public onlyOwner returns (uint256 poolId) {
        require(subsectionIndex < subSections.length, "Redistributor: Invalid subsection index");
        require(identifierToPoolId[_identifier] == 0, "Redistributor: Identifier already in use");

        poolId = nextPoolId++;
        Pool storage newPool = pools[poolId];
        newPool.isActive = _isActive;
        subSections[subsectionIndex].poolIds.push(poolId);
        identifierToPoolId[_identifier] = poolId;

        emit PoolCreated(_identifier, _isActive);
        return poolId;
    }

    function setPoolActivity(uint256 _identifier, bool _isActive) public onlyOwner {
        uint256 poolId = identifierToPoolId[_identifier];
        require(poolId > 0, "Redistributor: Invalid identifier");
        pools[poolId].isActive = _isActive;
        emit PoolActivityChanged(_identifier, _isActive);
    }

    function setSubSectionMasterShares(uint256 subsectionIndex, uint256 _masterShares) public onlyOwner {
        require(subsectionIndex < subSections.length, "Redistributor: Invalid subsection index");
        totalMasterShares = totalMasterShares.sub(subSections[subsectionIndex].masterShares).add(_masterShares);
        subSections[subsectionIndex].masterShares = _masterShares;
    }

    function redistributeFunds() external override {
        uint256 amount = token.balanceOf(address(this)) - heldInPools;
        if(amount == 0) return;
        for (uint256 i = 0; i < subSections.length; i++) {
            uint256 scaledAmount = amount.mul(precision);
            uint256 masterShareScaled = subSections[i].masterShares.mul(precision);
            uint256 subSectionDeposit = scaledAmount.mul(masterShareScaled).div(totalMasterShares).div(precision).div(precision);

            uint256 depositPerPool = subSectionDeposit.div(subSections[i].poolIds.length);
            for (uint256 j = 0; j < subSections[i].poolIds.length; j++) {
                uint256 poolId = subSections[i].poolIds[j];
                pools[poolId].tokenBalance += depositPerPool;
                heldInPools += depositPerPool;
            }
        }
    }


    function withdrawFunds(uint256 _identifier, uint256 shares) external override onlyLand returns (uint256) {
        uint256 poolId = identifierToPoolId[_identifier];
        require(poolId > 0, "Redistributor: Invalid identifier");
        require(shares <= pools[poolId].totalShares, "Redistributor: not enough shares");

        Pool storage pool = pools[poolId];

        if(pool.tokenBalance == 0){
            pool.totalShares -= shares;
            emit EmptyWithdrawal(_identifier, shares, pool.totalShares);
            return 0;
        }

        uint256 scaledAmount = pool.tokenBalance.mul(precision);
        uint256 sharesScaled = shares.mul(precision);
        uint256 withdrawalAmount = scaledAmount.mul(sharesScaled).div(pool.totalShares).div(precision).div(precision);

        pool.totalShares -= shares;
        pool.tokenBalance -= withdrawalAmount;
        heldInPools -= withdrawalAmount;
        token.transfer(land, withdrawalAmount);

        emit FundsWithdrawn(_identifier, withdrawalAmount);
        return withdrawalAmount;
    }

    function mintShares(uint256 _identifier, uint256 shares) external override onlyLand {
        uint256 poolId = identifierToPoolId[_identifier];
        require(poolId > 0, "Redistributor: Invalid identifier");
        require(pools[poolId].isActive, "Redistributor: Pool is inactive");
        pools[poolId].totalShares += shares;
        emit SharesMinted(poolId, shares);
    } 

    function burnShares(uint256 _identifier, uint256 shares) external override onlyLand {
        uint256 poolId = identifierToPoolId[_identifier];
        require(poolId > 0, "Redistributor: Invalid identifier");
        require(shares <= pools[poolId].totalShares, "Redistributor: not enough shares");
        pools[poolId].totalShares -= shares;
    }

    function getActivePools(uint256 subSectionIndex) private view returns (uint256 count) {
        count = 0;
        for (uint256 i = 0; i < subSections[subSectionIndex].poolIds.length; i++) {
            if (pools[subSections[subSectionIndex].poolIds[i]].isActive) {
                count++;
            }
        }
        return count;
    }

    function getPool(uint256 _identifier) public view returns (Pool memory pool) {
        uint256 poolId = identifierToPoolId[_identifier];
        require(poolId > 0, "Redistributor: Invalid identifier");
        return pools[poolId];
    }

    function getSubSections() public view returns (SubSection[] memory) {
        return subSections;
    }

}
