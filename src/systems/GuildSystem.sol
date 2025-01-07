
// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

import { LandAccessOperator } from "./LandAccessOperator.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { LandInfo, Guild, GuildInvitation, LandGuild, Guilds, GuildUniqueName, GuildData } from "../codegen/index.sol";
import { GuildDTO } from "../libraries/LibGuild.sol";
import { LibStrings } from "../libraries/LibStrings.sol";

contract GuildSystem is System, LandAccessOperator {

    event GuildCreated(uint32 guildId, string guildName, uint256 guildAdmin);
    event GuildMemberAdded(uint32 guildId, uint256 landId);
    event GuildMemberRemoved(uint32 guildId, uint256 landId);
    event GuildAdminChanged(uint32 guildId, uint256 landId);
    using LibStrings for string;

    function guildNameInUse(string memory guildName) public view returns (bool) {
        bytes32 guildNameHash =  getGuildNameHash(guildName);
        return GuildUniqueName.getExists(guildNameHash);
    }

    function guildNameHasValidCharacters(string memory guildName) public pure returns (bool) {
       return guildName.isAlphanumeric();
    }
      
    function createGuild(uint256 landId, string memory guildName) public onlyLandOperator(landId) returns (uint32 guildId) {
        //lowercase
        require(bytes(guildName).length > 0, "GuildSystem: Guild name cannot be empty");
        require(guildNameHasValidCharacters(guildName), "GuildSystem: Guild name can only contain ASCII characters");
        
        bytes32 guildNameHash = getGuildNameHash(guildName);
        require(GuildUniqueName.getExists(guildNameHash) == false, "GuildSystem: Guild name already exists");
        
        guildId = Guilds.getNonce() + 1;
        Guilds.setNonce(guildId);
        uint32 numGuilds = Guilds.getNumberOfGuilds();
        Guilds.setNumberOfGuilds(numGuilds + 1);   

        LandGuild.set(landId, guildId);
        
        Guild.setGuildName(guildId, guildName);
        Guild.setGuildAdmin(guildId, landId);
        Guild.setExists(guildId, true);

        Guild.pushGuildMembers(guildId, landId);

        GuildUniqueName.setExists(guildNameHash, true);
        GuildUniqueName.setGuildId(guildNameHash, guildId);
        emit GuildCreated(guildId, guildName, landId);
    }

    function getAllGuilds() public view returns (GuildDTO[] memory guilds) {
        uint32 numGuilds = Guilds.getNumberOfGuilds();
        guilds = new GuildDTO[](numGuilds);
        uint32 count = 0;
        uint32 nonce = Guilds.getNonce();
        for (uint32 i = 1; i <= nonce; i++) {
            GuildData memory guild = Guild.get(i);
            if(guild.exists){
                guilds[count] = GuildDTO({
                    guildId: i,
                    guildName: guild.guildName,
                    guildAdmin: guild.guildAdmin,
                    guildMembers: guild.guildMembers
                });
                count++;
            }
        }
    }

    function removeGuildMember(uint32 guildId, uint256 landId) private  {
      uint256[] memory guildMembers = Guild.getGuildMembers(guildId);
      uint256[] memory newGuildMembers = new uint256[](guildMembers.length - 1);
      uint256 count = 0;
      for (uint i = 0; i < guildMembers.length; i++) {
          if (guildMembers[i] == landId) {
              continue;
          }
          newGuildMembers[count] = guildMembers[i];
          count++;
       }
       Guild.setGuildMembers(guildId, newGuildMembers);
       emit GuildMemberRemoved(guildId, landId);
    }

    function getGuildNameHash(string memory guildName) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(LibStrings.toLower(guildName)));
    }

    function getGuildIdByName(string memory guildName) public view returns (uint32 guildId) {
        bytes32 guildNameHash = getGuildNameHash(guildName);
        return GuildUniqueName.getGuildId(guildNameHash);
    }


    function exitGuild(uint256 landId) public onlyLandOperator(landId) {
        uint32 guildId = LandGuild.get(landId);

        require(guildId > 0, "GuildSystem: You are not in a guild");
        LandGuild.set(landId, 0);
        removeGuildMember(guildId, landId);
        
        if (Guild.getGuildAdmin(guildId) == landId) {
            Guild.setGuildAdmin(guildId, 0);
        }
        emit GuildMemberRemoved(guildId, landId);
    }

    function setNewGuildAdmin(uint256 landId, uint256 newAdminId) public onlyLandOperator(landId) {
        uint32 guildId = LandGuild.get(landId);
        require(guildId > 0, "GuildSystem: You are not in a guild");
        require(Guild.getGuildAdmin(guildId) == landId, "GuildSystem: You are not a guild admin");
        require(LandGuild.get(newAdminId) == guildId, "GuildSystem: You are not in the same guild");
        Guild.setGuildAdmin(guildId, newAdminId);
        emit GuildAdminChanged(guildId, newAdminId);
    }

    function claimGuildAdmin(uint256 landId) public onlyLandOperator(landId) {
        uint32 guildId = LandGuild.get(landId);
        require(guildId > 0, "GuildSystem: You are not in a guild");
        require(Guild.getGuildAdmin(guildId) == 0, "GuildSystem: Guild admin already exists");
        Guild.setGuildAdmin(guildId, landId);
        emit GuildAdminChanged(guildId, landId);
    }

    function inviteToGuild(uint256 landId, uint256 invitedLandId) public onlyLandOperator(landId) {
        uint32 guildId = LandGuild.get(landId);
        require(guildId > 0, "GuildSystem: You are not in a guild");
        GuildInvitation.setIsInvited(invitedLandId, guildId, true);
    }

    function acceptGuildInvitation(uint256 landId, uint32 guildId) public onlyLandOperator(landId) {
        require(GuildInvitation.getIsInvited(landId, guildId), "GuildSystem: You are not invited to this guild");
         uint32 currentGuildId = LandGuild.get(landId);
         if(currentGuildId > 0) {
            exitGuild(landId);
         }

        GuildInvitation.setIsInvited(landId, guildId, false);
        GuildInvitation.deleteRecord(landId, guildId);
        LandGuild.set(landId, guildId);
        Guild.pushGuildMembers(guildId, landId);
        emit GuildMemberAdded(guildId, landId);
    }

    function kickFromGuild(uint256 landId, uint256 kickedLandId) public onlyLandOperator(landId) {
        uint32 guildId = LandGuild.get(landId);
        require(guildId > 0, "GuildSystem: You are not in a guild");
        require(Guild.getGuildAdmin(guildId) == landId, "GuildSystem: You are not a guild admin");
        require(LandGuild.get(kickedLandId) == guildId, "GuildSystem: You are not in the same guild");
        LandGuild.setGuildId(kickedLandId, 0);
        removeGuildMember(guildId, kickedLandId);
    }
    
}