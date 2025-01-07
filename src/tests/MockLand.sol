/*
import "../Land.sol";


contract MockLand is Land {

    bool _limitByChunk = false; 

    constructor() Land(address(123), 0, "0x0003") {}

    function getYieldShares(uint256 landId, uint256 x, uint256 y) public view returns (uint256) {
        return ls().lands[landId].yieldShares[x][y];
    }

    function getCollateral(uint256 landId, uint256 x, uint256 y) public view returns (uint256) {
        return ls().lands[landId].collateral[x][y];
    }

    function getRecipeId(uint256 landId, uint256 x, uint256 y) public view returns (uint256) {
        return ls().lands[landId].recipeId[x][y];
    }

    function getStoveId(uint256 landId, uint256 x, uint256 y) public view returns (uint256) {
        return ls().lands[landId].stoveId[x][y];
    }

    function getRedistributor() public view returns (address) {
        return address(ls().redistributor);
    }

    function mockAxiomV2Callback(uint256 avgFee, uint256 startBlock, uint256 endBlock, uint256 numSamples) public {
        require(ls().numSamples == numSamples, "max samples don't match");
        require(ls().lastUpdate == startBlock, "start block doesn't match");
        require(endBlock >= block.number-ls().endBlockSlippage, "end block is too late");
        //_updateWaterYield(avgFee);
    } 
   
    function setProperties(uint256 lastUpdate_, uint256 lastTWAP_, uint256 waterYieldTime_) public {
        ls().lastUpdate = lastUpdate_;
        ls().lastTWAP = lastTWAP_;
        ls().waterYieldTime = waterYieldTime_;
    }

    function updateWaterYield(uint256 avgFee) public {
       // _updateWaterYield(avgFee);
    }


    function getTransformationsAddress() public view returns (address) {
        return ls().transformationsAddress;
    }

    function calculateWaterYieldTime(int256 delta) public view returns (uint256) {
        return _calculateWaterYieldTime(delta);
    }

    function getDeltas() public view returns (int256[2] memory) {
        return [ls().minDelta, ls().maxDelta];
    }

    function getUnlockTimes(uint256 landId, uint256 x, uint256 y) public view returns (uint256[2] memory) {
        return [ls().lands[landId].dynamicUnlockTimes[x][y], ls().lands[landId].dynamicTimeoutTimes[x][y]];
    }

    function getLastTWAP() public view returns (uint256) {
        return ls().lastTWAP;
    }

    function limitByChunk() public {
        _limitByChunk = true;
    }

    function _checkBounds(uint256 landId, uint256 x, uint256 y) internal override view returns (bool) {
        if(_limitByChunk){
            return ls().lands[landId].landInfo.limitY > y && ls().lands[landId].landInfo.yBound[y] > x;
        }
        else{
            return ls().lands[landId].landInfo.limitY > y && ls().lands[landId].landInfo.limitX > x;
        }
    }
    

    function getYBound(uint256 landId) public view returns (uint256[] memory) {
        return ls().lands[landId].landInfo.yBound;
    }
    function mintPlaceItem(uint256 landId, uint256 x, uint256 y, uint256 itemId) public {
        _mint(landId, itemId, 1);
        placeItem(landId, x, y, itemId);
    }

    function getMinStartingLimits() public view returns (uint256[2] memory) {
        return [ls().minStartingX, ls().minStartingY];
    }

}
*/
