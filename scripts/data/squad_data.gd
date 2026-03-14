## Represents a squad of demons — the core tactical unit.
class_name SquadData
extends Resource

@export var squad_name: String = ""
@export var unit_type: UnitData
@export var unit_count: int = 1
@export var personality: GameEnums.Personality = GameEnums.Personality.LOYAL

## Guard relationship
@export var guarding: SquadData = null  ## The squad this one is guarding

## Computed properties
func get_total_hp() -> int:
	if not unit_type:
		return 0
	return unit_type.hp * unit_count

func get_attack_power() -> int:
	if not unit_type:
		return 0
	return unit_type.attack * unit_count

func get_strength_ratio() -> float:
	if not unit_type:
		return 0.0
	return float(unit_count) / float(unit_type.max_squad_size)

func is_guarding() -> bool:
	return guarding != null
