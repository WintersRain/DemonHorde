## A saved demon blueprint. Preserves the "recipe" so players can rebuild
## demons that die in combat. The knowledge is permanent, the demons are not.
class_name TemplateData
extends Resource

@export var template_name: String = ""
@export var base_unit_type: String = ""  ## Unit type name
@export var evolution_path: Array[String] = []  ## Evolution steps taken
@export var mutations: Array[String] = []  ## Applied mutations
@export var preferred_personality: GameEnums.Personality = GameEnums.Personality.LOYAL
@export var notes: String = ""  ## Player notes

## Cost to rebuild is calculated from the unit type + evolution costs,
## not stored here. Templates are free to save, costly to rebuild.

func get_display_name() -> String:
	if template_name != "":
		return template_name
	return base_unit_type + " Template"
