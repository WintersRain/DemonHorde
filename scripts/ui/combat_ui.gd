## Combat HUD — log panel, squad info, turn indicator.
class_name CombatUI
extends Control

@onready var log_container: VBoxContainer = $LogPanel/MarginContainer/ScrollContainer/LogContainer
@onready var scroll_container: ScrollContainer = $LogPanel/MarginContainer/ScrollContainer
@onready var turn_label: Label = $TopBar/TurnLabel
@onready var phase_label: Label = $TopBar/PhaseLabel
@onready var hover_panel: Panel = $HoverPanel
@onready var hover_label: RichTextLabel = $HoverPanel/MarginContainer/HoverLabel

var _combat_manager: CombatManager
var _max_log_lines := 100


func setup(combat_manager: CombatManager) -> void:
	_combat_manager = combat_manager
	_combat_manager.combat_log.connect(_on_combat_log)
	_combat_manager.turn_manager.turn_started.connect(_on_turn_started)
	_combat_manager.turn_manager.phase_changed.connect(_on_phase_changed)
	_combat_manager.grid.cell_hovered.connect(_on_cell_hovered)


func _on_combat_log(message: String) -> void:
	var label := Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", 13)

	if message.begins_with(">>>"):
		label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
	elif message.begins_with("==="):
		label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
		label.add_theme_font_size_override("font_size", 15)
	elif message.begins_with("---"):
		label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	elif message.begins_with("  "):
		label.add_theme_color_override("font_color", Color(0.7, 0.8, 1.0))
	else:
		label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))

	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	log_container.add_child(label)

	# Trim old lines
	while log_container.get_child_count() > _max_log_lines:
		var old := log_container.get_child(0)
		log_container.remove_child(old)
		old.queue_free()

	# Auto-scroll to bottom
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


func _on_turn_started(turn: int) -> void:
	turn_label.text = "Turn %d" % turn


func _on_phase_changed(phase: TurnManager.Phase) -> void:
	match phase:
		TurnManager.Phase.PLAYER_SELECT:
			phase_label.text = "Select Squad"
		TurnManager.Phase.PLAYER_ACTION:
			phase_label.text = "Move / Attack"
		TurnManager.Phase.ENEMY_TURN:
			phase_label.text = "Enemy Turn"
		TurnManager.Phase.ROUND_END:
			phase_label.text = "Round End"


func _on_cell_hovered(cell: Vector2i) -> void:
	if not _combat_manager or not _combat_manager.grid.is_valid_cell(cell):
		hover_panel.visible = false
		return

	var squad = _combat_manager.grid.get_squad_at(cell)
	if squad == null or not (squad is CombatSquad):
		hover_panel.visible = false
		return

	hover_panel.visible = true

	var tier_name := "Swarmling"
	match squad.tier:
		GameEnums.UnitTier.BRUTE: tier_name = "Brute"
		GameEnums.UnitTier.BEHEMOTH: tier_name = "Behemoth"

	var dmg_name := "Standard"
	match squad.damage_type:
		GameEnums.DamageType.CLEAVE: dmg_name = "Cleave (AoE)"
		GameEnums.DamageType.ANTI_HORDE: dmg_name = "Anti-Horde"
		GameEnums.DamageType.PRECISION: dmg_name = "Precision"

	var personality_name: String = GameEnums.Personality.keys()[squad.personality]

	var side := "[color=red]DEMON[/color]" if squad.is_player else "[color=cyan]HUMAN[/color]"

	var guard_text := ""
	if squad.guarding:
		guard_text = "\nGuarding: %s" % squad.guarding.squad_name
	if squad.guarded_by.size() > 0:
		var names: Array[String] = []
		for g in squad.guarded_by:
			names.append(g.squad_name)
		guard_text += "\nGuarded by: %s" % ", ".join(names)

	hover_label.text = "[b]%s[/b] %s\n%s | %s\nMembers: %d/%d\nHP: %d/%d\nATK: %d | DEF: %d | SPD: %d\nDamage: %s\nPersonality: %s%s" % [
		squad.squad_name, side, tier_name, squad.unit_name,
		squad.unit_count, squad.max_count,
		squad.get_total_hp(), squad.get_max_hp(),
		squad.member_attack, squad.member_defense, squad.member_speed,
		dmg_name, personality_name.capitalize(), guard_text
	]
