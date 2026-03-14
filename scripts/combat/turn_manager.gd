## Manages turn order and phase flow for combat.
class_name TurnManager
extends Node

signal turn_started(turn_number: int)
signal phase_changed(phase: Phase)
signal squad_turn_started(squad: CombatSquad)
signal round_ended(turn_number: int)
signal combat_ended(player_won: bool)

enum Phase {
	PLAYER_SELECT,   ## Player picks a squad to act with
	PLAYER_ACTION,   ## Player picks move/attack for selected squad
	ENEMY_TURN,      ## AI takes all enemy actions
	ROUND_END,       ## Cleanup, check win/loss
}

var current_turn: int = 0
var current_phase: Phase = Phase.PLAYER_SELECT
var player_squads: Array[CombatSquad] = []
var enemy_squads: Array[CombatSquad] = []

var _selected_squad: CombatSquad = null


func start_combat(p_squads: Array[CombatSquad], e_squads: Array[CombatSquad]) -> void:
	player_squads = p_squads
	enemy_squads = e_squads
	current_turn = 1
	_start_player_phase()


func _start_player_phase() -> void:
	turn_started.emit(current_turn)
	# Reset all player squad actions
	for squad in player_squads:
		if squad.is_alive():
			squad.reset_turn()
	current_phase = Phase.PLAYER_SELECT
	phase_changed.emit(current_phase)


func select_squad(squad: CombatSquad) -> bool:
	if current_phase != Phase.PLAYER_SELECT and current_phase != Phase.PLAYER_ACTION:
		return false
	if not squad.is_player or squad.has_acted or not squad.is_alive():
		return false

	_selected_squad = squad
	current_phase = Phase.PLAYER_ACTION
	phase_changed.emit(current_phase)
	squad_turn_started.emit(squad)
	return true


func get_selected_squad() -> CombatSquad:
	return _selected_squad


func deselect_squad() -> void:
	_selected_squad = null
	current_phase = Phase.PLAYER_SELECT
	phase_changed.emit(current_phase)


func confirm_squad_action() -> void:
	## Called after a squad has moved/attacked. Marks it as acted.
	if _selected_squad:
		_selected_squad.has_acted = true
		_selected_squad = null

	# Check if all player squads have acted
	var all_acted := true
	for squad in player_squads:
		if squad.is_alive() and not squad.has_acted:
			all_acted = false
			break

	if all_acted:
		_start_enemy_phase()
	else:
		current_phase = Phase.PLAYER_SELECT
		phase_changed.emit(current_phase)


func end_player_turn() -> void:
	## Player manually ends turn (even if squads haven't all acted).
	_start_enemy_phase()


func _start_enemy_phase() -> void:
	current_phase = Phase.ENEMY_TURN
	phase_changed.emit(current_phase)
	# Reset enemy squads
	for squad in enemy_squads:
		if squad.is_alive():
			squad.reset_turn()


func finish_enemy_phase() -> void:
	## Called by combat manager after all enemy actions resolve.
	_check_combat_end()
	if _is_combat_over():
		return
	current_turn += 1
	current_phase = Phase.ROUND_END
	round_ended.emit(current_turn)
	_start_player_phase()


func _check_combat_end() -> void:
	var player_alive := false
	for squad in player_squads:
		if squad.is_alive():
			player_alive = true
			break

	var enemy_alive := false
	for squad in enemy_squads:
		if squad.is_alive():
			enemy_alive = true
			break

	if not enemy_alive:
		combat_ended.emit(true)
	elif not player_alive:
		combat_ended.emit(false)


func _is_combat_over() -> bool:
	var player_alive := player_squads.any(func(s): return s.is_alive())
	var enemy_alive := enemy_squads.any(func(s): return s.is_alive())
	return not player_alive or not enemy_alive
