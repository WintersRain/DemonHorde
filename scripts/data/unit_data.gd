## Resource definition for a unit type. Data-driven — stats live here, not in code.
class_name UnitData
extends Resource

@export var unit_name: String = ""
@export var tier: GameEnums.UnitTier = GameEnums.UnitTier.SWARMLING
@export var description: String = ""

## Squad size limits
@export var min_squad_size: int = 1
@export var max_squad_size: int = 50

## Base stats (per individual unit in the squad)
@export_group("Stats")
@export var hp: int = 10
@export var attack: int = 5
@export var defense: int = 2
@export var speed: int = 5
@export var morale: int = 50

## Combat properties
@export_group("Combat")
@export var damage_type: GameEnums.DamageType = GameEnums.DamageType.SINGLE_TARGET
@export var attack_range: int = 1  ## Grid tiles
@export var abilities: Array[String] = []

## Breeding costs
@export_group("Breeding")
@export var captive_cost: int = 1
@export var soul_cost: int = 0
@export var corruption_required: float = 0.0

## Personality weights — higher = more likely to roll this trait
@export_group("Personality")
@export var personality_weights: Dictionary = {
	"PYROMANIAC": 20,
	"COWARD": 20,
	"GREEDY": 20,
	"BERSERKER": 20,
	"LOYAL": 5,
}

## Evolution
@export_group("Evolution")
@export var evolves_from: String = ""  ## Unit name this evolves from
@export var evolution_options: Array[String] = []  ## Unit names this can evolve into
@export var evolution_soul_cost: int = 0
