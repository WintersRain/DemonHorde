## Top-level combat orchestrator. Wires together grid, squads, turns, and AI.
class_name CombatManager
extends Node2D

signal combat_log(message: String)
signal combat_finished(player_won: bool)

@onready var grid: CombatGrid = $CombatGrid
@onready var turn_manager: TurnManager = $TurnManager
@onready var enemy_ai: EnemyAI = $EnemyAI
@onready var combat_ui: Control = $"../UI/CombatUI"

var _action_state: String = "select"  ## "select", "move", "attack", "guard"

var _player_squads: Array[CombatSquad] = []
var _enemy_squads: Array[CombatSquad] = []


func _ready() -> void:
	enemy_ai.setup(grid, turn_manager)

	grid.cell_clicked.connect(_on_cell_clicked)
	turn_manager.phase_changed.connect(_on_phase_changed)
	turn_manager.combat_ended.connect(_on_combat_ended)

	_spawn_demo_battle()


func _spawn_demo_battle() -> void:
	## Create a demo fight to test systems.

	# --- PLAYER SQUADS (Demons) ---
	var imp_squad := _create_squad(
		"Imp Swarm", "Imp", GameEnums.UnitTier.SWARMLING,
		30, 30, 8, 3, 1, 4, GameEnums.DamageType.CLEAVE,
		GameEnums.Personality.PYROMANIAC, true
	)
	grid.place_squad(imp_squad, Vector2i(1, 3))

	var hellhound_squad := _create_squad(
		"Hellhound Pack", "Hellhound", GameEnums.UnitTier.BRUTE,
		8, 8, 25, 10, 5, 3, GameEnums.DamageType.SINGLE_TARGET,
		GameEnums.Personality.BERSERKER, true
	)
	grid.place_squad(hellhound_squad, Vector2i(1, 5))

	var pit_fiend := _create_squad(
		"Pit Fiend", "Pit Fiend", GameEnums.UnitTier.BEHEMOTH,
		2, 2, 80, 35, 15, 2, GameEnums.DamageType.CLEAVE,
		GameEnums.Personality.LOYAL, true
	)
	grid.place_squad(pit_fiend, Vector2i(0, 4))

	_player_squads = [imp_squad, hellhound_squad, pit_fiend]

	# Set up guard: imps guard the pit fiend
	imp_squad.guarding = pit_fiend
	pit_fiend.guarded_by.append(imp_squad)

	# --- ENEMY SQUADS (Humans) ---
	var militia := _create_squad(
		"Town Militia", "Militia", GameEnums.UnitTier.SWARMLING,
		25, 25, 8, 4, 2, 3, GameEnums.DamageType.SINGLE_TARGET,
		GameEnums.Personality.COWARD, false
	)
	militia.set_squad_color(Color(0.2, 0.5, 0.8))
	grid.place_squad(militia, Vector2i(10, 2))

	var guards := _create_squad(
		"Town Guard", "Guard", GameEnums.UnitTier.BRUTE,
		6, 6, 30, 12, 8, 2, GameEnums.DamageType.SINGLE_TARGET,
		GameEnums.Personality.LOYAL, false
	)
	guards.set_squad_color(Color(0.3, 0.4, 0.7))
	grid.place_squad(guards, Vector2i(10, 5))

	var knight := _create_squad(
		"Knight Captain", "Knight", GameEnums.UnitTier.BEHEMOTH,
		1, 1, 120, 45, 20, 2, GameEnums.DamageType.PRECISION,
		GameEnums.Personality.LOYAL, false
	)
	knight.set_squad_color(Color(0.7, 0.7, 0.9))
	grid.place_squad(knight, Vector2i(9, 4))

	_enemy_squads = [militia, guards, knight]

	# Guards guard the knight
	guards.guarding = knight
	knight.guarded_by.append(guards)

	# Start combat
	turn_manager.start_combat(_player_squads, _enemy_squads)

	_log("=== RAID ON MILLBROOK VILLAGE ===")
	_log("Your horde emerges from a crack in the earth...")
	_log("Turn %d — Select a squad to command." % turn_manager.current_turn)


func _create_squad(
	sname: String, uname: String, stier: GameEnums.UnitTier,
	count: int, max_c: int, hp: int, atk: int, def: int, spd: int,
	dtype: GameEnums.DamageType, pers: GameEnums.Personality,
	is_player: bool
) -> CombatSquad:
	var squad := CombatSquad.new()
	squad.squad_name = sname
	squad.unit_name = uname
	squad.tier = stier
	squad.unit_count = count
	squad.max_count = max_c
	squad.member_hp = hp
	squad.member_attack = atk
	squad.member_defense = def
	squad.member_speed = spd
	squad.damage_type = dtype
	squad.personality = pers
	squad.is_player = is_player

	if is_player:
		match stier:
			GameEnums.UnitTier.SWARMLING:
				squad.set_squad_color(Color(0.9, 0.3, 0.2))
			GameEnums.UnitTier.BRUTE:
				squad.set_squad_color(Color(0.8, 0.5, 0.1))
			GameEnums.UnitTier.BEHEMOTH:
				squad.set_squad_color(Color(0.7, 0.1, 0.2))

	squad.squad_died.connect(_on_squad_died)
	grid.add_child(squad)
	return squad


func _on_cell_clicked(cell: Vector2i) -> void:
	match _action_state:
		"select":
			_handle_select(cell)
		"move":
			_handle_move(cell)
		"attack":
			_handle_attack(cell)


func _handle_select(cell: Vector2i) -> void:
	var squad = grid.get_squad_at(cell)
	if squad == null:
		return

	if squad is CombatSquad:
		if squad.is_player and not squad.has_acted and squad.is_alive():
			turn_manager.select_squad(squad)
			_show_squad_options(squad)


func _show_squad_options(squad: CombatSquad) -> void:
	# Highlight move range
	var move_cells := grid.get_move_cells(squad.grid_pos, squad.member_speed)
	grid.set_move_range(move_cells)

	# Highlight attack targets
	var attack_cells: Array[Vector2i] = []
	for cell in grid.get_cells_in_range(squad.grid_pos, squad.attack_range):
		if grid.is_occupied(cell):
			var target = grid.get_squad_at(cell)
			if target is CombatSquad and not target.is_player:
				attack_cells.append(cell)
	grid.set_highlighted_cells(attack_cells)

	_action_state = "move"
	_log("%s selected. Click blue to move, yellow to attack, or click another squad." % squad.squad_name)


func _handle_move(cell: Vector2i) -> void:
	var squad := turn_manager.get_selected_squad()
	if squad == null:
		return

	# Check if clicking an attack target
	if grid.is_occupied(cell):
		var target = grid.get_squad_at(cell)
		if target is CombatSquad:
			if not target.is_player:
				_execute_player_attack(squad, target)
				return
			elif target.is_player and not target.has_acted and target.is_alive():
				# Clicking a different player squad — switch selection
				grid.clear_highlights()
				turn_manager.select_squad(target)
				_show_squad_options(target)
				return
		return

	# Check if valid move cell
	var move_cells := grid.get_move_cells(squad.grid_pos, squad.member_speed)
	if cell in move_cells:
		_grid_move_squad(squad, cell)

		# After moving, check if we can attack anyone
		var attack_cells: Array[Vector2i] = []
		for acell in grid.get_cells_in_range(squad.grid_pos, squad.attack_range):
			if grid.is_occupied(acell):
				var target = grid.get_squad_at(acell)
				if target is CombatSquad and not target.is_player:
					attack_cells.append(acell)

		if attack_cells.is_empty():
			# No targets, turn ends for this squad
			_log("%s moved. No targets in range." % squad.squad_name)
			grid.clear_highlights()
			turn_manager.confirm_squad_action()
			_action_state = "select"
		else:
			# Can still attack
			grid.set_move_range([])
			grid.set_highlighted_cells(attack_cells)
			_action_state = "attack"
			_log("%s moved. Click a target to attack, or press End Turn." % squad.squad_name)


func _handle_attack(cell: Vector2i) -> void:
	var squad := turn_manager.get_selected_squad()
	if squad == null:
		return

	if not grid.is_occupied(cell):
		return

	var target = grid.get_squad_at(cell)
	if target is CombatSquad and not target.is_player:
		_execute_player_attack(squad, target)


func _execute_player_attack(attacker: CombatSquad, target: CombatSquad) -> void:
	# Check for guard interception
	var actual_target := target
	if target.guarded_by.size() > 0 and attacker.attack_range <= 1:
		for guard in target.guarded_by:
			if guard.is_alive():
				actual_target = guard
				break

	var damage := attacker.calculate_damage_to(actual_target)
	var result := actual_target.take_damage(damage)

	if actual_target != target:
		_log("%s attacks %s -> INTERCEPTED by %s! %d damage, %d killed." % [
			attacker.squad_name, target.squad_name, actual_target.squad_name,
			result.damage_dealt, result.members_killed
		])
	else:
		_log("%s attacks %s for %d damage! %d killed. (%d remaining)" % [
			attacker.squad_name, target.squad_name,
			result.damage_dealt, result.members_killed, actual_target.unit_count
		])

	grid.clear_highlights()
	turn_manager.confirm_squad_action()
	_action_state = "select"


func _grid_move_squad(squad: CombatSquad, to: Vector2i) -> void:
	grid.move_squad(squad, squad.grid_pos, to)


func _on_phase_changed(phase: TurnManager.Phase) -> void:
	match phase:
		TurnManager.Phase.PLAYER_SELECT:
			_action_state = "select"
		TurnManager.Phase.ENEMY_TURN:
			_process_enemy_turn()


func _process_enemy_turn() -> void:
	_log("--- Enemy Turn ---")
	var actions := enemy_ai.execute_turn()

	for action in actions:
		match action.type:
			"attack":
				var intercepted_text := ""
				if action.intercepted:
					intercepted_text = " (intercepted from %s)" % action.intended_target.squad_name
				_log("  %s attacks %s%s for %d damage! %d killed." % [
					action.squad.squad_name, action.target.squad_name,
					intercepted_text, action.damage, action.killed
				])
			"move":
				_log("  %s advances toward %s." % [
					action.squad.squad_name, action.target.squad_name
				])
			"idle":
				_log("  %s holds position." % action.squad.squad_name)

	turn_manager.finish_enemy_phase()

	if turn_manager.current_phase == Phase.PLAYER_SELECT:
		_log("Turn %d — Select a squad to command." % turn_manager.current_turn)


func _on_squad_died(squad: CombatSquad) -> void:
	_log(">>> %s has been destroyed! <<<" % squad.squad_name)
	grid.remove_squad(squad.grid_pos)

	# Clean up guard relationships
	if squad.guarding:
		squad.guarding.guarded_by.erase(squad)
	for guarded in squad.guarded_by:
		guarded.guarding = null


func _on_combat_ended(player_won: bool) -> void:
	if player_won:
		_log("")
		_log("=== VICTORY! The village falls! ===")
		_log("Your demons screech in triumph as the settlement burns.")
	else:
		_log("")
		_log("=== DEFEAT! Your horde is scattered! ===")
		_log("The defenders hold firm. You slink back to the depths...")

	combat_finished.emit(player_won)


func _log(msg: String) -> void:
	combat_log.emit(msg)


func _unhandled_input(event: InputEvent) -> void:
	# Right-click to deselect
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			grid.clear_highlights()
			turn_manager.deselect_squad()
			_action_state = "select"

	# Space to end turn early
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			if turn_manager.current_phase == TurnManager.Phase.PLAYER_SELECT or \
			   turn_manager.current_phase == TurnManager.Phase.PLAYER_ACTION:
				_log("Player ends turn early.")
				grid.clear_highlights()
				turn_manager.end_player_turn()
				_action_state = "select"
