// SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
pragma solidity ^0.8.0;

struct GuildDTO {
    uint32 guildId;
    uint256 guildAdmin;
    string guildName;
    uint256[] guildMembers;
}