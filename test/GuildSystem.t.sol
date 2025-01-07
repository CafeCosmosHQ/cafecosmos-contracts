// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { CafeCosmosTest } from "./util/CafeCosmosTest.sol";
import "forge-std/console.sol";
import { LandInfo, GuildExists, GuildInvitation, PlayerGuild } from "../src/codegen/index.sol";

contract GuildSystemTest is CafeCosmosTest {
    
    address public alice = address(0x01);
    address public bob = address(0x02);
    address public claire = address(0x03);

    uint256 public alice_landId;
    uint256 public bob_landId;
    uint256 public claire_landId;

    function setUp() public override {
        super.setUp();
        
        alice_landId = setupPlayer(alice);
        bob_landId = setupPlayer(bob);
        claire_landId = setupPlayer(claire);
    }

    function test_CreateGuild() public {
        vm.startPrank(alice);
        uint8 yggId = world.createGuild(alice_landId, "YGG");
        
        assertEq(PlayerGuild.getGuildName(alice_landId), "YGG");
        assertTrue(PlayerGuild.getIsGuildAdmin(alice_landId));
        assertTrue(GuildExists.getExists(yggId));
    }

    function test_CreateGuild_RevertIfEmpty() public {
        vm.startPrank(alice);
        vm.expectRevert("GuildSystem: Guild name cannot be empty");
        world.createGuild(alice_landId, "");
    }

    function test_ExitGuild() public {
        // Setup: Create guild first
        vm.startPrank(alice);
        world.createGuild(alice_landId, "YGG");
        
        world.exitGuild(alice_landId);
        
        assertEq(PlayerGuild.getGuildName(alice_landId), "");
        assertFalse(PlayerGuild.getIsGuildAdmin(alice_landId));
    }

    function test_ExitGuild_RevertIfNotInGuild() public {
        vm.startPrank(bob);
        vm.expectRevert("GuildSystem: You are not in a guild");
        world.exitGuild(bob_landId);
    }

    function test_InviteToGuild() public {
        // Setup: Create guild first
        vm.startPrank(alice);
        uint8 guildId = world.createGuild(alice_landId, "YGG");
        
        world.inviteToGuild(alice_landId, bob_landId);
        
        assertTrue(GuildInvitation.getIsInvited(bob_landId, guildId));
    }

    function test_AcceptGuildInvitation() public {
        // Setup: Create guild and invite
        vm.startPrank(alice);
        world.createGuild(alice_landId, "YGG");
        world.inviteToGuild(alice_landId, bob_landId);
        
        vm.startPrank(bob);
        world.acceptGuildInvitation(bob_landId, "YGG");
        
    }

    function test_AcceptGuildInvitation_RevertIfNotInvited() public {
        vm.startPrank(bob);
        vm.expectRevert("GuildSystem: You are not invited to this guild");
        world.acceptGuildInvitation(bob_landId, "YGG");
    }

    function test_KickFromGuild() public {
        // Setup: Create guild and add member
        vm.startPrank(alice);
        world.createGuild(alice_landId, "YGG");
        world.inviteToGuild(alice_landId, bob_landId);
        
        vm.startPrank(bob);
        world.acceptGuildInvitation(bob_landId, "YGG");
        
        vm.startPrank(alice);
        world.kickFromGuild(alice_landId, bob_landId);
        
        assertEq(PlayerGuild.getGuildName(bob_landId), "");
    }

    function test_KickFromGuild_RevertIfNotAdmin() public {
        // Setup: Create guild and add member
        vm.startPrank(alice);
        world.createGuild(alice_landId, "YGG");
        world.inviteToGuild(alice_landId, bob_landId);
        
        vm.startPrank(bob);
        world.acceptGuildInvitation(bob_landId, "YGG");
        
        vm.expectRevert("GuildSystem: You are not a guild admin");
        world.kickFromGuild(bob_landId, alice_landId);
    }

    function test_FullGuildFlow() public {
        // 1. Alice creates guild
        vm.startPrank(alice);
        world.createGuild(alice_landId, "YGG");
        
        // 2. Alice invites Bob
        world.inviteToGuild(alice_landId, bob_landId);
        
        // 3. Bob accepts
        vm.startPrank(bob);
        world.acceptGuildInvitation(bob_landId, "YGG");
        
        // 4. Alice kicks Bob
        vm.startPrank(alice);
        world.kickFromGuild(alice_landId, bob_landId);
        
        // 5. Alice exits guild
        world.exitGuild(alice_landId);
        
        // Verify final state
        assertEq(PlayerGuild.getGuildName(alice_landId), "");
        assertEq(PlayerGuild.getGuildName(bob_landId), "");
        assertFalse(PlayerGuild.getIsGuildAdmin(alice_landId));
        assertFalse(PlayerGuild.getIsGuildAdmin(bob_landId));
    }
}