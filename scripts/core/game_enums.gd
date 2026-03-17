## Global enums used across the project.
class_name GameEnums

## Unit tier classifications
enum UnitTier {
	SWARMLING,  ## T1 - Expendable mass (10-50 per squad)
	BRUTE,      ## T2 - Reliable mid-tier (3-12 per squad)
	BEHEMOTH,   ## T3 - Rare powerhouses (1-3 per squad)
}

## Demon personality traits that affect combat behavior
enum Personality {
	PYROMANIAC,  ## Bonus fire damage, may ignite friendlies
	COWARD,      ## Flees at 50% squad HP, bonus retreat speed
	GREEDY,      ## Prioritizes loot, bonus resource yield
	BERSERKER,   ## Ignores guard orders, bonus melee damage
	LOYAL,       ## Always follows orders (rarest)
}

## Damage types for the combat system
enum DamageType {
	SINGLE_TARGET,  ## Full damage to one squad
	CLEAVE,         ## Damage split across squad members
	ANTI_HORDE,     ## Bonus damage based on target squad size
	PRECISION,      ## Bonus damage vs smaller squads
}

## Individual demon behavioral state
enum DemonState {
	FOLLOWING,  ## Moving with squad toward intent target
	LOOTING,    ## Detoured to collect loot (Greedy trigger)
	FLEEING,    ## Running from combat (Coward trigger)
	BERSERK,    ## Charging enemies independently (Berserker trigger)
	DEAD,       ## Removed from play
}

## Squad intent types (what the squad is ordered to do)
enum IntentType {
	MOVE,     ## Move toward a position
	ATTACK,   ## Engage a specific enemy
	BREACH,   ## Destroy a building/wall
	HOLD,     ## Stay in current position
	RETREAT,  ## Fall back toward map edge
}

## Squad behavior override set by player
enum SquadBehavior {
	DEFAULT,     ## Personality-driven
	AGGRESSIVE,  ## Loosen cohesion, prioritize damage
	CAUTIOUS,    ## Tighten cohesion, prioritize survival
}

## Morale state thresholds
enum MoraleState {
	NORMAL,    ## 70-100: Full effectiveness
	SHAKEN,    ## 40-70: -10% attack, hesitation chance
	WAVERING,  ## 20-40: -25% attack, cowards flee
	ROUTING,   ## 0-20: Squad breaks, all flee
}

## Building types for settlements
enum BuildingType {
	HOUSE,        ## Filler, cover, 1-3 loot
	MARKET,       ## Loot magnet (Greedy trap), 5-8 loot
	BARRACKS,     ## Spawns defenders, no loot
	GRANARY,      ## Supply loot, 3-5
	TEMPLE,       ## Morale aura for defenders, no loot
	WALL_SEGMENT, ## Blocks movement
	GATE,         ## Choke point, can be opened or destroyed
}

## Loot item types
enum LootType {
	COIN,
	GEM,
	SUPPLY,
	CAPTIVE,
}

## Settlement sizes for generation
enum SettlementSize {
	HAMLET,   ## 4-6 buildings, no walls
	VILLAGE,  ## 8-15 buildings, palisade + 1-2 gates
	TOWN,     ## 20-30 buildings, stone walls, 2-3 gates
	CITY,     ## 40+ buildings, layered walls, inner keep
}

## Post-raid decisions
enum RaidOutcome {
	LEAVE,     ## Take loot and go, settlement recovers
	OCCUPY,    ## Station a squad, passive resources
	SALT,      ## Permanent destruction, refugees consolidate
}

## Kingdom awareness levels
enum AwarenessLevel {
	UNAWARE,
	RUMORS,
	ALERT,
	WAR_FOOTING,
	DESPERATE,
}

## Player manifestation stages
enum ManifestationStage {
	DORMANT,    ## 0% - No presence
	STIRRING,   ## 25% - Passive buffs
	RUMBLING,   ## 50% - Terrain corruption, new breeding
	RISING,     ## 75% - Battlefield abilities
	MANIFESTED, ## 100% - Physical form on the field
}
