## Simple enemy AI. Picks closest target and attacks or moves toward it.
class_name EnemyAI
extends Node

var _grid: CombatGrid
var _turn_manager: TurnManager


func setup(grid: CombatGrid, turn_manager: TurnManager) -> void:
	_grid = grid
	_turn_manager = turn_manager


func execute_turn() -> Array[Dictionary]:
	## Process all enemy squad actions. Returns an array of action logs.
	var actions: Array[Dictionary] = []

	for squad in _turn_manager.enemy_squads:
		if not squad.is_alive() or squad.has_acted:
			continue

		var action := _decide_action(squad)
		actions.append(action)
		squad.has_acted = true

	return actions


func _decide_action(squad: CombatSquad) -> Dictionary:
	# Find closest living player squad
	var target: CombatSquad = null
	var closest_dist := 999

	for p_squad in _turn_manager.player_squads:
		if not p_squad.is_alive():
			continue
		var dist := _grid.get_distance(squad.grid_pos, p_squad.grid_pos)
		if dist < closest_dist:
			closest_dist = dist
			target = p_squad

	if target == null:
		return { "type": "idle", "squad": squad }

	# Can we attack?
	if closest_dist <= squad.attack_range:
		return _execute_attack(squad, target)

	# Move toward target
	return _execute_move_toward(squad, target)


func _execute_attack(attacker: CombatSquad, target: CombatSquad) -> Dictionary:
	# Check for guard interception
	var actual_target := target
	if target.guarded_by.size() > 0 and attacker.attack_range <= 1:
		# Melee attack intercepted by guard
		var guard: CombatSquad = target.guarded_by[0]
		if guard.is_alive():
			actual_target = guard

	var damage := attacker.calculate_damage_to(actual_target)
	var result := actual_target.take_damage(damage)

	return {
		"type": "attack",
		"squad": attacker,
		"target": actual_target,
		"intended_target": target,
		"intercepted": actual_target != target,
		"damage": result.damage_dealt,
		"killed": result.members_killed,
	}


func _execute_move_toward(squad: CombatSquad, target: CombatSquad) -> Dictionary:
	var move_cells := _grid.get_move_cells(squad.grid_pos, squad.member_speed)
	if move_cells.is_empty():
		return { "type": "idle", "squad": squad }

	# Pick cell closest to target
	var best_cell := move_cells[0]
	var best_dist := _grid.get_distance(move_cells[0], target.grid_pos)

	for cell in move_cells:
		var dist := _grid.get_distance(cell, target.grid_pos)
		if dist < best_dist:
			best_dist = dist
			best_cell = cell

	var old_pos := squad.grid_pos
	_grid.move_squad(squad, old_pos, best_cell)

	return {
		"type": "move",
		"squad": squad,
		"from": old_pos,
		"to": best_cell,
		"target": target,
	}
