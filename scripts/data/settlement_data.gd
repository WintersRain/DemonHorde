## Data for a world map settlement — a raid target.
class_name SettlementData
extends Resource

@export var settlement_name: String = ""
@export var description: String = ""

## Settlement tier
enum SettlementSize { HAMLET, VILLAGE, TOWN, CITY, FORTRESS, CAPITAL }
@export var size: SettlementSize = SettlementSize.HAMLET

## Stats
@export_group("Population")
@export var population: int = 100
@export var max_population: int = 200
@export var population_growth_rate: float = 0.05  ## Per turn

@export_group("Military")
@export var militia_count: int = 10
@export var militia_quality: int = 1  ## 1-10 scale
@export var guard_count: int = 0
@export var has_hero: bool = false

@export_group("Fortification")
@export var wall_level: int = 0  ## 0 = none, 1-5 = increasing
@export var fortification_hp: int = 0

@export_group("State")
@export var morale: float = 100.0  ## 0-100
@export var times_raided: int = 0
@export var is_occupied: bool = false
@export var is_salted: bool = false
@export var turns_since_last_raid: int = 0

## Recovery rates
func recover_turn() -> void:
	if is_salted or is_occupied:
		return
	turns_since_last_raid += 1
	# Population regrows slowly
	population = mini(population + int(max_population * population_growth_rate), max_population)
	# Militia re-musters at moderate speed
	var militia_cap := population / 10
	militia_count = mini(militia_count + 2, militia_cap)
	# Morale recovers
	morale = minf(morale + 5.0, 100.0)
	# Fortifications rebuild slowly but stronger
	if wall_level > 0 and fortification_hp < wall_level * 100:
		fortification_hp += 10

## Veteran bonus from surviving raids
func get_veteran_bonus() -> float:
	return 1.0 + (times_raided * 0.1)  ## +10% per previous raid
