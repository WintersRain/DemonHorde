## Combat HUD — log panel, phase indicator, squad info on hover.
class_name CombatUI
extends Control

var _combat_manager: CombatManager

## UI elements (created in code to avoid scene complexity)
var _log_container: VBoxContainer
var _scroll_container: ScrollContainer
var _phase_label: Label
var _round_label: Label
var _help_label: Label
var _hover_panel: Panel
var _hover_label: RichTextLabel
var _loot_label: Label

const MAX_LOG_LINES: int = 80


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_ui()


func setup(combat_manager: CombatManager) -> void:
	_combat_manager = combat_manager
	_combat_manager.combat_log.connect(_on_combat_log)
	_combat_manager.phase_changed.connect(_on_phase_changed)


func _build_ui() -> void:
	# --- TOP BAR ---
	var top_bar := HBoxContainer.new()
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.offset_bottom = 36
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_bar)

	_round_label = Label.new()
	_round_label.text = "Round 1"
	_round_label.add_theme_font_size_override("font_size", 18)
	_round_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(_round_label)

	var sep1 := HSeparator.new()
	sep1.custom_minimum_size = Vector2(20, 0)
	sep1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(sep1)

	_phase_label = Label.new()
	_phase_label.text = "COMMAND"
	_phase_label.add_theme_font_size_override("font_size", 16)
	_phase_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.3))
	_phase_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(_phase_label)

	var sep2 := HSeparator.new()
	sep2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sep2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(sep2)

	_loot_label = Label.new()
	_loot_label.text = "Loot: 0"
	_loot_label.add_theme_font_size_override("font_size", 14)
	_loot_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	_loot_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(_loot_label)

	var sep3 := HSeparator.new()
	sep3.custom_minimum_size = Vector2(20, 0)
	sep3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(sep3)

	_help_label = Label.new()
	_help_label.text = "Click squad → [1]Move [2]Attack [3]Breach [4]Hold | [Space]Execute"
	_help_label.add_theme_font_size_override("font_size", 11)
	_help_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6))
	_help_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(_help_label)

	# --- LOG PANEL (bottom-right) ---
	var log_panel := Panel.new()
	log_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	log_panel.offset_left = -380
	log_panel.offset_top = -300
	log_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(log_panel)

	var log_margin := MarginContainer.new()
	log_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	log_margin.add_theme_constant_override("margin_left", 8)
	log_margin.add_theme_constant_override("margin_top", 8)
	log_margin.add_theme_constant_override("margin_right", 8)
	log_margin.add_theme_constant_override("margin_bottom", 8)
	log_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	log_panel.add_child(log_margin)

	_scroll_container = ScrollContainer.new()
	_scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	log_margin.add_child(_scroll_container)

	_log_container = VBoxContainer.new()
	_log_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_log_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_scroll_container.add_child(_log_container)

	# --- HOVER PANEL (top-left, below top bar) ---
	_hover_panel = Panel.new()
	_hover_panel.position = Vector2(8, 44)
	_hover_panel.size = Vector2(260, 200)
	_hover_panel.visible = false
	_hover_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hover_panel)

	var hover_margin := MarginContainer.new()
	hover_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	hover_margin.add_theme_constant_override("margin_left", 8)
	hover_margin.add_theme_constant_override("margin_top", 8)
	hover_margin.add_theme_constant_override("margin_right", 8)
	hover_margin.add_theme_constant_override("margin_bottom", 8)
	hover_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hover_panel.add_child(hover_margin)

	_hover_label = RichTextLabel.new()
	_hover_label.bbcode_enabled = true
	_hover_label.fit_content = true
	_hover_label.add_theme_font_size_override("normal_font_size", 12)
	_hover_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_margin.add_child(_hover_label)


func _process(_delta: float) -> void:
	if not _combat_manager:
		return

	# Update loot counter
	_loot_label.text = "Loot: %d" % _combat_manager._total_loot_collected

	# Update round
	_round_label.text = "Round %d" % _combat_manager.current_round

	# Hover info
	_update_hover()


func _update_hover() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	# Find nearest squad to mouse
	var arena_offset: Vector2 = _combat_manager.arena.global_position
	var arena_mouse := mouse_pos - arena_offset

	var nearest_squad: SquadCommand = null
	var nearest_dist: float = 60.0

	for squad in _combat_manager.player_squads + _combat_manager.enemy_squads:
		if not squad.is_alive():
			continue
		var dist := arena_mouse.distance_to(squad.get_squad_center())
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_squad = squad

	if nearest_squad == null:
		_hover_panel.visible = false
		return

	_hover_panel.visible = true
	var side := "[color=red]DEMON[/color]" if nearest_squad.is_player else "[color=cyan]HUMAN[/color]"
	var tier_name: String = GameEnums.UnitTier.keys()[nearest_squad.tier]
	var morale_state: String = GameEnums.MoraleState.keys()[nearest_squad.get_morale_state()]
	var intent_name: String = GameEnums.IntentType.keys()[nearest_squad.intent_type]

	var guard_text := ""
	if nearest_squad.guarding:
		guard_text = "\nGuarding: %s" % nearest_squad.guarding.squad_name
	if nearest_squad.guarded_by.size() > 0:
		var names: Array[String] = []
		for g in nearest_squad.guarded_by:
			names.append(g.squad_name)
		guard_text += "\nGuarded by: %s" % ", ".join(names)

	_hover_label.text = "[b]%s[/b] %s\n%s | Members: %d\nMorale: %d (%s)\nCohesion: %.0f%%\nIntent: %s%s" % [
		nearest_squad.squad_name, side,
		tier_name, nearest_squad.get_member_count(),
		int(nearest_squad.morale), morale_state,
		nearest_squad.cohesion * 100.0,
		intent_name, guard_text
	]


func _on_combat_log(message: String) -> void:
	var label := Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", 12)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if message.begins_with(">>>"):
		label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
	elif message.begins_with("==="):
		label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
		label.add_theme_font_size_override("font_size", 14)
	elif message.begins_with("---"):
		label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	elif message.begins_with("  "):
		label.add_theme_color_override("font_color", Color(0.7, 0.8, 1.0))
	else:
		label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))

	_log_container.add_child(label)

	while _log_container.get_child_count() > MAX_LOG_LINES:
		var old := _log_container.get_child(0)
		_log_container.remove_child(old)
		old.queue_free()

	# Auto-scroll
	await get_tree().process_frame
	if _scroll_container and _scroll_container.get_v_scroll_bar():
		_scroll_container.scroll_vertical = int(_scroll_container.get_v_scroll_bar().max_value)


func _on_phase_changed(phase: CombatManager.CombatPhase) -> void:
	match phase:
		CombatManager.CombatPhase.COMMAND:
			_phase_label.text = "COMMAND"
			_phase_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.3))
			_help_label.text = "Click squad → [1]Move [2]Attack [3]Breach [4]Hold | [Space]Execute"
		CombatManager.CombatPhase.EXECUTION:
			_phase_label.text = "EXECUTING"
			_phase_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.2))
			_help_label.text = "[Space]Pause/Resume"
		CombatManager.CombatPhase.RESOLUTION:
			_phase_label.text = "RESOLUTION"
			_phase_label.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
			_help_label.text = ""
		CombatManager.CombatPhase.COMBAT_OVER:
			_phase_label.text = "COMBAT OVER"
			_phase_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
			_help_label.text = ""
