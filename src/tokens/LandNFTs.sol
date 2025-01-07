// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/ILandNFTs.sol";
//import "hardhat/console.sol";

//import "forge-std/console.sol";

contract LandNFTs is ERC721, ERC721Enumerable, Ownable {

    address land;
    string URI;
    uint256 nonce;
    mapping(string => uint256) landNameToId;
    mapping(uint256 => string) landIdToName;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function setLand(address _land) public onlyOwner {
        require(land==address(0));
        land = _land;
    }

    function setLandName(uint256 landId, string memory name) public  {
        require(msg.sender==land, "LandNFTs: only land can set name");
        require(landNameToId[name]==0, "LandNFTs: name already exists");
        landNameToId[name] = landId;
        landIdToName[landId] = name;    
    }

    function getLandId(string memory name) public view returns (uint256) {
        return landNameToId[name];
    }

    function getLandName(uint256 landId) public view returns (string memory) {
        return landIdToName[landId];
    }

    function getAllLands() public view returns (LandMetadata[] memory) {
        LandMetadata[] memory lands = new LandMetadata[](nonce);
        for(uint256 i=1; i<=nonce; i++) {
            lands[i-1] = LandMetadata(i, landIdToName[i]);
        }
        return lands;
    }

    function setURI(string memory _URI) public onlyOwner {
        URI = _URI;
    }

    function _baseURI() internal view override returns (string memory) {
        return URI;
    }

    function mint(address to) external returns (uint256) {
        require(msg.sender==land, "LandNFTs: only land can mint");
        nonce++;
        _mint(to, nonce);
        return nonce;
    }

     function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    } 

   function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


}