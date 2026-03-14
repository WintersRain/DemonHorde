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
