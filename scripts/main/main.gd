## Main scene — bootstraps the game. Currently loads straight into combat.
extends Node2D


func _ready() -> void:
	# Wire up the combat UI to the combat manager
	var combat_manager: CombatManager = $Combat/CombatManager
	var combat_ui: CombatUI = $Combat/UI/CombatUI
	combat_ui.setup(combat_manager)

	# Dark background
	RenderingServer.set_default_clear_color(Color(0.08, 0.08, 0.1))
