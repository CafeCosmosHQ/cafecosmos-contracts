# Cafe Cosmos Contracts

Smart contracts for Cafe Cosmos, an on-chain multiplayer game built with MUD v2 where players manage virtual cafes, craft items, complete quests, and participate in a dynamic player-driven economy.

## Overview

Cafe Cosmos is a fully on-chain game where players own land NFTs that serve as their cafe spaces. Players can place items, craft recipes, complete quests, join guilds, and trade through an integrated marketplace. The game features procedural generation using Perlin noise, dynamic pricing through VRGDA mechanisms, and oracle integration via Axiom for advanced game mechanics.

## Core Features

### Land Management
- **Land NFTs**: ERC721 tokens representing expandable cafe plots
- **Coordinate System**: Grid-based placement with x, y, z coordinates for 3D item positioning
- **Land Expansion**: Players can expand their cafe using VRGDA-based dynamic pricing
- **Permissions**: Owner-operator system for delegated land management
- **Procedural Generation**: Perlin noise-based terrain generation with configurable seeds

### Crafting System
- **Recipe-Based Crafting**: Combine input items to create new items and earn XP
- **Active Stoves**: Track cooking states with yield shares and collateral mechanics
- **Time-Based Mechanics**: Recipes feature unlock times and timeout mechanics
- **Transformation System**: Item-to-item interactions with dynamic outcomes
- **Stackable Items**: Support for combining items at specific positions

### Item System
- **ERC1155 Tokens**: Multi-token standard for all in-game items
- **Item Categories**: Tools, furniture, consumables, and decorative items
- **Item Metadata**: Non-removable, non-placeable, rotatable, and thematic properties
- **Tables and Chairs**: Special interaction mechanics for seating furniture
- **Inventory Management**: Per-land item storage with quantity tracking

### Quest System
- **Quest Groups**: Time-bound collections of quests with sequential or parallel completion
- **Task Types**: Multiple task varieties with progress tracking
- **Rewards**: Items, tokens, and other incentives for quest completion
- **Expiration**: Time-limited quest availability
- **Land Progress**: Individual progress tracking per land NFT

### Guild System
- **Guild Creation**: Player-organized groups with unique names
- **Membership**: Land-based membership with admin roles
- **Invitations**: Guild admins can invite lands to join
- **Guild Management**: Create, join, leave, and manage guild operations

### Marketplace
- **Peer-to-Peer Trading**: List items for sale at specified prices
- **Listing Management**: Create, cancel, and purchase listings
- **Price Discovery**: Player-determined pricing
- **Inventory Integration**: Automatic inventory transfers on purchase

### Economic Systems

#### VRGDA (Variable Rate Gradual Dutch Auction)
- Dynamic pricing mechanism for land expansion
- Time-based price adjustments
- Configurable target price and decay constants
- On-chain price discovery

#### Token Economics
- **Soft Token**: Primary in-game currency (ERC20)
- **Vesting**: Time-locked token distribution
- **Redistribution**: Economic balancing through redistribution contracts
- **Player Earnings**: Track total earned and spent per land

### Advanced Features

#### Axiom Integration
- Zero-knowledge proof oracle for off-chain data verification
- Fee history analysis for water collection mechanics
- TWAP (Time-Weighted Average Price) calculations
- Configurable query parameters and validation

#### Leveling System
- XP accumulation through crafting and quests
- Level-based rewards (tokens and items)
- Cumulative XP tracking
- Claimable level rewards per land

#### Water Controller
- Dynamic water collection times based on gas prices
- Axiom-powered on-chain gas price verification
- Adjustable yield times based on network conditions
- Slippage protection for block intervals

## Technical Architecture

### Framework
- **MUD v2**: Autonomous world framework with ECS (Entity Component System) architecture
- **Store**: On-chain database with typed tables and schemas
- **World**: Upgradeable system registry and access control

### Development Stack
- **Solidity**: 0.8.28 with via-ir optimization
- **Foundry**: Testing and deployment framework
- **Hardhat**: Additional tooling and deployment scripts
- **OpenZeppelin**: Battle-tested contract libraries

### Key Dependencies
- `@latticexyz/world`: MUD world framework
- `@latticexyz/store`: On-chain storage layer
- `@axiom-crypto/client`: Zero-knowledge oracle integration
- `@openzeppelin/contracts`: Standard contract implementations

## Project Structure

```
src/
├── systems/           # Game logic systems
│   ├── CraftingSystem.sol
│   ├── LandCreationSystem.sol
│   ├── QuestsSystem.sol
│   ├── GuildSystem.sol
│   ├── MarketplaceSystem.sol
│   └── ...
├── tokens/            # Token contracts
│   ├── LandNFTs.sol
│   ├── Items.sol
│   └── SoftToken.sol
├── libraries/         # Shared logic
│   ├── LibLandManagement.sol
│   ├── LibCraftingStorage.sol
│   └── ...
├── interfaces/        # Contract interfaces
├── util/              # Utility contracts
└── codegen/           # MUD-generated code

test/                  # Foundry tests
axiom/                 # Axiom circuit definitions
scripts/               # Deployment scripts
notebooks/             # Data analysis
```

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm
- Foundry

### Installation

```bash
pnpm install
```

### Build

```bash
pnpm build
```

This compiles the Solidity contracts and generates MUD codegen files.

### Testing

```bash
pnpm test
```

Run Foundry tests with TypeScript checks.

### Local Development

```bash
pnpm dev
```

Starts a local MUD development environment with auto-reloading.

### Deployment

```bash
# Deploy to local network
pnpm deploy:local

# Deploy to testnet
pnpm deploy:testnet
```

## Configuration

### MUD Configuration
World and table schemas are defined in `mud.config.ts`. This generates the Store tables and type-safe bindings.

### Foundry Configuration
Compiler settings and RPC endpoints are configured in `foundry.toml`.

### Environment Variables
Required environment variables:
- `PROVIDER_URI_GOERLI`: RPC endpoint for Goerli testnet

## Axiom Integration

The project includes Axiom circuits for verifiable off-chain computation:

```bash
# Compile Axiom circuit
pnpm circuit:compile

# Run circuit with inputs
pnpm circuit:run
```

Circuits are defined in `axiom/circuit.ts` and enable trustless oracle data for game mechanics like the water controller.

## Smart Contract Systems

### Core Systems
- **LandCreationSystem**: Mint and initialize new lands
- **LandItemsSystem**: Place, remove, and manage items on land
- **CraftingSystem**: Execute crafting recipes
- **QuestsSystem**: Manage quest lifecycle and completion
- **GuildSystem**: Create and manage player guilds
- **MarketplaceSystem**: List and trade items
- **LevelingSystem**: Handle XP and level rewards
- **VrgdaSystem**: Dynamic pricing for expansions
- **WaterControllerSystem**: Gas-price-based water collection

### Access Control
- **RootAccessOperator**: World-level permissions
- **LandAccessOperator**: Per-land permissions
- Owner-operator delegation pattern

## Security Considerations

- All sensitive operations use access control checks
- Time-based mechanics prevent manipulation
- VRGDA ensures economic stability
- Axiom proofs provide trustless oracle data
- Reentrancy guards on token transfers
- Integer overflow protection via Solidity 0.8+

## Testing

The project includes comprehensive test coverage:
- Unit tests for individual systems
- Integration tests for cross-system interactions
- VRGDA pricing validation
- Quest progression tests
- Guild management tests
- Marketplace trading scenarios

## License

MIT

## Additional Resources

- [MUD Documentation](https://mud.dev)
- [Axiom Documentation](https://docs.axiom.xyz)
- [Foundry Book](https://book.getfoundry.sh)

## Contributing

This is a private project. For questions or issues, please contact the development team.
