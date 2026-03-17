## Top-level combat orchestrator. Phase-based: Command → Execution → Resolution.
## Wires together arena, squads, demons, boid system, enemy AI, and UI.
class_name CombatManager
extends Node2D

signal combat_log(message: String)
signal combat_finished(player_won: bool)
signal phase_changed(phase: CombatPhase)

enum CombatPhase {
	COMMAND,     ## Player sets intent per squad (turn-based)
	EXECUTION,   ## All demons move and fight (real-time, ~8s)
	RESOLUTION,  ## Dead removed, morale checks, loot tallied
	COMBAT_OVER, ## Win or loss
}

## --- Children (set in _ready) ---
var arena: CombatArena
var boid_system: BoidSystem

## --- State ---
var current_phase: CombatPhase = CombatPhase.COMMAND
var current_round: int = 1
var execution_timer: float = 0.0
var execution_paused: bool = false
const EXECUTION_DURATION: float = 8.0

## --- Squads and Demons ---
var player_squads: Array[SquadCommand] = []
var enemy_squads: Array[SquadCommand] = []
var all_player_demons: Array[DemonEntity] = []
var all_enemy_demons: Array[DemonEntity] = []

## --- Selection state (command phase) ---
var selected_squad: SquadCommand = null
var intent_mode: String = "none"  ## "none", "move", "attack", "breach"

## --- Stats tracking for resolution ---
var _player_deaths_this_round: int = 0
var _enemy_deaths_this_round: int = 0
var _enemy_routed_this_round: bool = false
var _behemoth_killed_this_round: bool = false
var _total_loot_collected: int = 0


func _ready() -> void:
	# Create arena
	arena = CombatArena.new()
	add_child(arena)

	# Create boid system
	boid_system = BoidSystem.new()

	# Generate a hamlet for the demo
	SettlementGenerator.build_settlement(arena, GameEnums.SettlementSize.HAMLET)

	# Spawn demo battle
	_spawn_demo_battle()

	# Start in command phase
	_enter_command_phase()


func _process(delta: float) -> void:
	match current_phase:
		CombatPhase.EXECUTION:
			if not execution_paused:
				_process_execution(delta)
		CombatPhase.RESOLUTION:
			# Resolution is instant, processed in _enter_resolution
			pass


func _unhandled_input(event: InputEvent) -> void:
	if current_phase == CombatPhase.COMBAT_OVER:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_handle_left_click(get_local_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_handle_right_click()

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				if current_phase == CombatPhase.COMMAND:
					_enter_execution_phase()
				elif current_phase == CombatPhase.EXECUTION:
					execution_paused = not execution_paused
					if execution_paused:
						_log("--- PAUSED ---")
					else:
						_log("--- RESUMED ---")
			KEY_1:
				if current_phase == CombatPhase.COMMAND and selected_squad:
					intent_mode = "move"
					_log("Set intent: MOVE. Click a position.")
			KEY_2:
				if current_phase == CombatPhase.COMMAND and selected_squad:
					intent_mode = "attack"
					_log("Set intent: ATTACK. Click an enemy or position.")
			KEY_3:
				if current_phase == CombatPhase.COMMAND and selected_squad:
					intent_mode = "breach"
					_log("Set intent: BREACH. Click a building.")
			KEY_4:
				if current_phase == CombatPhase.COMMAND and selected_squad:
					selected_squad.set_intent(GameEnums.IntentType.HOLD, selected_squad.get_squad_center())
					_log("%s set to HOLD position." % selected_squad.squad_name)
					_deselect_squad()


# =============================================================================
# COMMAND PHASE
# =============================================================================

func _enter_command_phase() -> void:
	current_phase = CombatPhase.COMMAND
	phase_changed.emit(current_phase)
	_log("")
	_log("=== Round %d — COMMAND PHASE ===" % current_round)
	_log("Click a squad to select. [1]Move [2]Attack [3]Breach [4]Hold [Space]Execute")


func _handle_left_click(click_pos: Vector2) -> void:
	if current_phase != CombatPhase.COMMAND:
		return

	# Adjust for arena offset
	var arena_pos := click_pos - arena.position

	if selected_squad == null:
		# Try to select a player squad
		_try_select_squad(arena_pos)
	else:
		# Apply intent based on mode
		_apply_intent(arena_pos)


func _handle_right_click() -> void:
	if current_phase == CombatPhase.COMMAND:
		_deselect_squad()


func _try_select_squad(pos: Vector2) -> void:
	# Find closest player squad to click
	var best_squad: SquadCommand = null
	var best_dist: float = 80.0  # Max click distance

	for squad in player_squads:
		if not squad.is_alive():
			continue
		var dist := pos.distance_to(squad.get_squad_center())
		if dist < best_dist:
			best_dist = dist
			best_squad = squad

	if best_squad:
		selected_squad = best_squad
		intent_mode = "move"
		_log("Selected: %s (%d members, morale: %d). [1]Move [2]Attack [3]Breach [4]Hold" % [
			best_squad.squad_name, best_squad.get_member_count(), int(best_squad.morale)
		])


func _apply_intent(pos: Vector2) -> void:
	if selected_squad == null:
		return

	match intent_mode:
		"move":
			selected_squad.set_intent(GameEnums.IntentType.MOVE, pos)
			_log("%s → Move to (%.0f, %.0f)" % [selected_squad.squad_name, pos.x, pos.y])
			_deselect_squad()

		"attack":
			# Check if clicking near an enemy squad
			var target_squad := _find_enemy_squad_near(pos, 80.0)
			if target_squad:
				var target_center := target_squad.get_squad_center()
				selected_squad.set_intent(GameEnums.IntentType.ATTACK, target_center, target_squad)
				_log("%s → Attack %s" % [selected_squad.squad_name, target_squad.squad_name])
			else:
				selected_squad.set_intent(GameEnums.IntentType.ATTACK, pos)
				_log("%s → Attack-move to (%.0f, %.0f)" % [selected_squad.squad_name, pos.x, pos.y])
			_deselect_squad()

		"breach":
			var building := arena.get_nearest_building(pos)
			if building and pos.distance_to(building.position) < 80.0:
				selected_squad.set_intent(GameEnums.IntentType.BREACH, building.position, building)
				_log("%s → Breach building at (%.0f, %.0f)" % [selected_squad.squad_name, building.position.x, building.position.y])
			else:
				_log("No building near click. Try again.")
				return
			_deselect_squad()


func _deselect_squad() -> void:
	selected_squad = null
	intent_mode = "none"


func _find_enemy_squad_near(pos: Vector2, max_dist: float) -> SquadCommand:
	var best: SquadCommand = null
	var best_dist: float = max_dist
	for squad in enemy_squads:
		if not squad.is_alive():
			continue
		var dist := pos.distance_to(squad.get_squad_center())
		if dist < best_dist:
			best_dist = dist
			best = squad
	return best


# =============================================================================
# EXECUTION PHASE
# =============================================================================

func _enter_execution_phase() -> void:
	current_phase = CombatPhase.EXECUTION
	execution_timer = 0.0
	execution_paused = false
	_player_deaths_this_round = 0
	_enemy_deaths_this_round = 0
	_enemy_routed_this_round = false
	_behemoth_killed_this_round = false

	phase_changed.emit(current_phase)
	_log("")
	_log("=== EXECUTION PHASE === (Space to pause)")

	# Set default intent for enemy squads (simple AI)
	_compute_enemy_intents()


func _process_execution(delta: float) -> void:
	execution_timer += delta

	# --- Update boid velocities ---
	_update_boids()

	# --- Move all demons ---
	_move_demons(delta)

	# --- Process combat (attacks) ---
	_process_attacks(delta)

	# --- Loot collection ---
	_process_loot_collection()

	# --- Update cohesion ---
	for squad in player_squads + enemy_squads:
		squad.compute_cohesion()

	# --- Check execution end ---
	if execution_timer >= EXECUTION_DURATION:
		_enter_resolution_phase()

	# --- Force redraw ---
	queue_redraw()


func _update_boids() -> void:
	# Build squad data dictionary
	var squad_data := {}
	for squad in player_squads + enemy_squads:
		if not squad.is_alive():
			continue
		var living := squad.get_living_members()
		var avg_vel := Vector2.ZERO
		for m in living:
			if m is DemonEntity:
				avg_vel += m.velocity
		if living.size() > 0:
			avg_vel /= float(living.size())

		# Compute squad HP ratio
		var total_hp: float = 0.0
		var total_max: float = 0.0
		for m in living:
			if m is DemonEntity:
				total_hp += m.hp
				total_max += m.max_hp
		var hp_ratio: float = total_hp / maxf(total_max, 1.0)

		squad_data[squad] = {
			"center": squad.get_squad_center(),
			"avg_velocity": avg_vel,
			"intent_target": squad.get_intent_position(),
			"hp_ratio": hp_ratio,
		}

	# Build obstacle data from buildings
	var obstacles: Array = []
	for b in arena.buildings:
		if b.is_destroyed:
			continue
		var rect := b.get_collision_rect()
		obstacles.append({
			"position": b.position,
			"radius": maxf(rect.size.x, rect.size.y) / 2.0,
			"flammable": not b.on_fire and not b.is_destroyed,
		})

	# Build loot data
	var loot_data: Array = []
	for item in arena.loot_items:
		if not item.picked_up:
			loot_data.append({ "position": item.position, "picked_up": false })

	# Process player demons (enemies are the "enemies" list)
	boid_system.update_velocities(
		all_player_demons, squad_data, all_enemy_demons, loot_data, obstacles
	)
	# Process enemy demons (player demons are the "enemies" list)
	boid_system.update_velocities(
		all_enemy_demons, squad_data, all_player_demons, loot_data, obstacles
	)


func _move_demons(delta: float) -> void:
	for demon in all_player_demons + all_enemy_demons:
		if not demon.is_alive():
			continue
		if demon.velocity.length_squared() < 0.01:
			continue

		var new_pos := demon.position + demon.velocity * delta

		# Clamp to arena bounds
		new_pos.x = clampf(new_pos.x, 5.0, CombatArena.ARENA_WIDTH - 5.0)
		new_pos.y = clampf(new_pos.y, 5.0, CombatArena.ARENA_HEIGHT - 5.0)

		# Simple building collision — push out if inside
		if not arena.is_position_blocked(new_pos):
			demon.position = new_pos
		else:
			# Try sliding along axes
			var slide_x := Vector2(new_pos.x, demon.position.y)
			var slide_y := Vector2(demon.position.x, new_pos.y)
			if not arena.is_position_blocked(slide_x):
				demon.position = slide_x
			elif not arena.is_position_blocked(slide_y):
				demon.position = slide_y
			# Else: stuck, don't move

		demon.queue_redraw()


func _process_attacks(delta: float) -> void:
	# Tick cooldowns
	for demon in all_player_demons + all_enemy_demons:
		if demon.is_alive():
			demon.tick_cooldown(delta)

	# Player demons attack enemies
	_resolve_attacks(all_player_demons, all_enemy_demons, true)
	# Enemy demons attack player demons
	_resolve_attacks(all_enemy_demons, all_player_demons, false)


func _resolve_attacks(attackers: Array, defenders: Array, attacker_is_player: bool) -> void:
	for attacker in attackers:
		if not attacker.is_alive() or not attacker.can_attack():
			continue
		if attacker is not DemonEntity:
			continue

		# Find nearest defender in range
		var target: DemonEntity = null
		var target_dist: float = attacker.attack_range
		for defender in defenders:
			if not defender.is_alive():
				continue
			if defender is not DemonEntity:
				continue
			var dist := attacker.position.distance_to(defender.position)
			if dist <= target_dist:
				target_dist = dist
				target = defender

		if target == null:
			continue

		# Hesitation check (morale)
		if attacker.squad and attacker.squad is SquadCommand:
			var squad_cmd: SquadCommand = attacker.squad
			if randf() < squad_cmd.get_hesitation_chance():
				continue

		# Check guard interception
		var actual_target := target
		if target.squad and target.squad is SquadCommand:
			var target_squad: SquadCommand = target.squad
			var guards := target_squad.get_engaging_guards(attacker.position)
			if guards.size() > 0:
				# Redirect to nearest guard squad member
				var guard_squad := guards[0]
				var nearest_guard: DemonEntity = null
				var nearest_gdist: float = INF
				for gm in guard_squad.get_living_members():
					if gm is DemonEntity and gm.is_alive():
						var gdist := attacker.position.distance_to(gm.position)
						if gdist < nearest_gdist:
							nearest_gdist = gdist
							nearest_guard = gm
				if nearest_guard and nearest_gdist <= attacker.attack_range * 2.0:
					actual_target = nearest_guard

		# Apply damage
		var damage := attacker.get_effective_attack()

		# Morale attack modifier
		if attacker.squad and attacker.squad is SquadCommand:
			damage = int(damage * (attacker.squad as SquadCommand).get_attack_modifier())

		var dealt := actual_target.take_damage(damage)

		attacker.reset_attack_cooldown()

		# Pyromaniac fire setting
		if attacker.personality == GameEnums.Personality.PYROMANIAC:
			var nearby_building := arena.get_nearest_building(attacker.position)
			if nearby_building and attacker.position.distance_to(nearby_building.position) < 60.0:
				nearby_building.set_on_fire()

		# Behemoth attacks buildings
		if attacker.tier == GameEnums.UnitTier.BEHEMOTH:
			if attacker.squad and attacker.squad is SquadCommand:
				var sq: SquadCommand = attacker.squad
				if sq.intent_type == GameEnums.IntentType.BREACH:
					var building := arena.get_nearest_building(attacker.position)
					if building and attacker.position.distance_to(building.position) < attacker.attack_range + 30.0:
						building.take_damage(damage)


func _process_loot_collection() -> void:
	for demon in all_player_demons:
		if not demon.is_alive() or demon.is_inventory_full():
			continue

		# Check for loot items near this demon
		var nearby_loot := arena.get_loot_in_radius(demon.position, 15.0)
		for item in nearby_loot:
			if item.picked_up:
				continue
			# Greedy demons always pick up, others only if very close
			var should_collect := false
			if demon.personality == GameEnums.Personality.GREEDY:
				should_collect = true
			elif demon.position.distance_to(item.position) < 10.0:
				should_collect = true

			if should_collect and not demon.is_inventory_full():
				var loot_data := { "type": item.loot_type, "value": item.value }
				if demon.collect_loot(loot_data):
					item.collect()
					_total_loot_collected += item.value


func _compute_enemy_intents() -> void:
	## Simple enemy AI: each squad targets the nearest player squad.
	for squad in enemy_squads:
		if not squad.is_alive():
			continue

		var nearest_player: SquadCommand = null
		var nearest_dist: float = INF
		var squad_center := squad.get_squad_center()

		for p_squad in player_squads:
			if not p_squad.is_alive():
				continue
			var dist := squad_center.distance_to(p_squad.get_squad_center())
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_player = p_squad

		if nearest_player:
			squad.set_intent(GameEnums.IntentType.ATTACK, nearest_player.get_squad_center(), nearest_player)
		else:
			squad.set_intent(GameEnums.IntentType.HOLD, squad_center)


# =============================================================================
# RESOLUTION PHASE
# =============================================================================

func _enter_resolution_phase() -> void:
	current_phase = CombatPhase.RESOLUTION
	phase_changed.emit(current_phase)
	_log("")
	_log("=== RESOLUTION PHASE ===")

	# Count deaths this round
	_log("Player losses: %d demons. Enemy losses: %d." % [_player_deaths_this_round, _enemy_deaths_this_round])
	_log("Loot collected: %d total value." % _total_loot_collected)

	# Morale resolution
	var has_player_behemoth := false
	for sq in player_squads:
		if sq.tier == GameEnums.UnitTier.BEHEMOTH and sq.is_alive():
			has_player_behemoth = true
			break

	# Check for fires near squads
	var burning_buildings := arena.buildings.filter(func(b): return b.on_fire and not b.is_destroyed)

	for squad in player_squads:
		if not squad.is_alive():
			continue
		var fire_nearby := false
		var center := squad.get_squad_center()
		for b in burning_buildings:
			if center.distance_to(b.position) < 120.0:
				fire_nearby = true
				break
		squad.apply_resolution_morale(
			0, _enemy_routed_this_round, has_player_behemoth,
			_behemoth_killed_this_round, false, fire_nearby
		)
		_log("  %s morale: %d (%s)" % [squad.squad_name, int(squad.morale),
			GameEnums.MoraleState.keys()[squad.get_morale_state()]])

	for squad in enemy_squads:
		if not squad.is_alive():
			continue
		var fire_nearby := false
		var center := squad.get_squad_center()
		for b in burning_buildings:
			if center.distance_to(b.position) < 120.0:
				fire_nearby = true
				break
		squad.apply_resolution_morale(
			0, false, false, false, false, fire_nearby
		)

	# Check win/loss
	var player_alive := player_squads.any(func(s): return s.is_alive())
	var enemy_alive := enemy_squads.any(func(s): return s.is_alive())

	if not enemy_alive:
		_on_combat_over(true)
		return
	if not player_alive:
		_on_combat_over(false)
		return

	# Next round
	current_round += 1
	_enter_command_phase()


func _on_combat_over(player_won: bool) -> void:
	current_phase = CombatPhase.COMBAT_OVER
	phase_changed.emit(current_phase)

	if player_won:
		_log("")
		_log("=== VICTORY! The settlement falls! ===")
		_log("Surviving demons carry %d loot value back to the depths." % _total_loot_collected)
	else:
		_log("")
		_log("=== DEFEAT! Your horde is scattered! ===")
		_log("The defenders hold. You slink back to formlessness...")

	combat_finished.emit(player_won)


# =============================================================================
# DEMON LIFECYCLE
# =============================================================================

func _on_demon_died(demon: DemonEntity) -> void:
	# Drop inventory as loot
	var dropped := demon.drop_inventory()
	for loot_data in dropped:
		var item := LootItem.create_loot(
			loot_data.get("type", GameEnums.LootType.COIN),
			loot_data.get("value", 1),
			demon.position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		)
		arena.add_loot(item)

	# Track deaths
	if demon.squad and demon.squad is SquadCommand:
		var squad: SquadCommand = demon.squad
		squad.remove_member(demon)

		if squad.is_player:
			_player_deaths_this_round += 1
			if demon.tier == GameEnums.UnitTier.BEHEMOTH:
				_behemoth_killed_this_round = true
		else:
			_enemy_deaths_this_round += 1

		# Check if squad is wiped
		if not squad.is_alive():
			if not squad.is_player:
				_enemy_routed_this_round = true
				_log(">>> %s destroyed! <<<" % squad.squad_name)
			else:
				_log(">>> %s wiped out! <<<" % squad.squad_name)


# =============================================================================
# DEMO BATTLE SETUP
# =============================================================================

func _spawn_demo_battle() -> void:
	_log("=== RAID ON HAMLET ===")
	_log("Your horde emerges from a crack in the earth...")

	# --- PLAYER SQUADS ---
	var imp_squad := _create_squad("Imp Swarm", GameEnums.UnitTier.SWARMLING, 20,
		GameEnums.Personality.GREEDY, true, Color(0.9, 0.3, 0.2))
	_spawn_squad_members(imp_squad, Vector2(80, 300))

	var hound_squad := _create_squad("Hellhound Pack", GameEnums.UnitTier.BRUTE, 5,
		GameEnums.Personality.BERSERKER, true, Color(0.8, 0.5, 0.1))
	_spawn_squad_members(hound_squad, Vector2(80, 500))

	var pit_fiend := _create_squad("Pit Fiend", GameEnums.UnitTier.BEHEMOTH, 1,
		GameEnums.Personality.LOYAL, true, Color(0.7, 0.1, 0.2))
	_spawn_squad_members(pit_fiend, Vector2(60, 400))

	player_squads = [imp_squad, hound_squad, pit_fiend]

	# Set up guard: imps guard the pit fiend
	pit_fiend.assign_guard(imp_squad)

	# Set default intents
	for squad in player_squads:
		squad.set_intent(GameEnums.IntentType.HOLD, squad.get_squad_center())

	# --- ENEMY SQUADS ---
	var militia := _create_squad("Town Militia", GameEnums.UnitTier.SWARMLING, 15,
		GameEnums.Personality.COWARD, false, Color(0.2, 0.5, 0.8))
	_spawn_squad_members(militia, Vector2(800, 350))

	var guards := _create_squad("Town Guard", GameEnums.UnitTier.BRUTE, 4,
		GameEnums.Personality.LOYAL, false, Color(0.3, 0.4, 0.7))
	_spawn_squad_members(guards, Vector2(850, 450))

	enemy_squads = [militia, guards]

	# Guards guard militia (they protect the weak)
	militia.assign_guard(guards)

	# Enemy intents will be set in execution phase
	for squad in enemy_squads:
		squad.set_intent(GameEnums.IntentType.HOLD, squad.get_squad_center())


func _create_squad(sname: String, stier: GameEnums.UnitTier, count: int,
		default_personality: GameEnums.Personality, is_player: bool,
		color: Color) -> SquadCommand:
	var squad := SquadCommand.new()
	squad.squad_name = sname
	squad.tier = stier
	squad.is_player = is_player
	arena.add_child(squad)
	return squad


func _spawn_squad_members(squad: SquadCommand, center: Vector2) -> void:
	var count := 0
	# Determine count based on tier
	match squad.tier:
		GameEnums.UnitTier.SWARMLING:
			count = 20 if squad.is_player else 15
		GameEnums.UnitTier.BRUTE:
			count = 5 if squad.is_player else 4
		GameEnums.UnitTier.BEHEMOTH:
			count = 1

	var color: Color
	if squad.is_player:
		match squad.tier:
			GameEnums.UnitTier.SWARMLING: color = Color(0.9, 0.3, 0.2)
			GameEnums.UnitTier.BRUTE: color = Color(0.8, 0.5, 0.1)
			GameEnums.UnitTier.BEHEMOTH: color = Color(0.7, 0.1, 0.2)
	else:
		match squad.tier:
			GameEnums.UnitTier.SWARMLING: color = Color(0.2, 0.5, 0.8)
			GameEnums.UnitTier.BRUTE: color = Color(0.3, 0.4, 0.7)
			GameEnums.UnitTier.BEHEMOTH: color = Color(0.7, 0.7, 0.9)

	# Determine personality
	var personality: GameEnums.Personality
	if squad.squad_name == "Imp Swarm":
		personality = GameEnums.Personality.GREEDY
	elif squad.squad_name == "Hellhound Pack":
		personality = GameEnums.Personality.BERSERKER
	elif squad.squad_name == "Pit Fiend":
		personality = GameEnums.Personality.LOYAL
	elif squad.squad_name == "Town Militia":
		personality = GameEnums.Personality.COWARD
	else:
		personality = GameEnums.Personality.LOYAL

	for i in count:
		var demon := DemonEntity.new()
		demon.init_from_tier(squad.tier, personality)
		demon.set_body_color(color)
		demon.squad = squad

		# Spread around center
		var offset := Vector2(
			randf_range(-30, 30),
			randf_range(-30, 30)
		)
		demon.position = center + offset

		demon.died.connect(_on_demon_died)
		arena.add_child(demon)
		squad.add_member(demon)

		if squad.is_player:
			all_player_demons.append(demon)
		else:
			all_enemy_demons.append(demon)


func _log(msg: String) -> void:
	combat_log.emit(msg)


func _draw() -> void:
	# Draw guard zones during command phase
	if current_phase == CombatPhase.COMMAND or current_phase == CombatPhase.EXECUTION:
		for squad in player_squads:
			if squad.guard_zone_active:
				draw_circle(
					squad.guard_zone_center,
					squad.guard_zone_radius,
					Color(0.3, 0.6, 1.0, 0.1)
				)
				draw_arc(
					squad.guard_zone_center,
					squad.guard_zone_radius,
					0, TAU, 48,
					Color(0.3, 0.6, 1.0, 0.3), 1.5
				)

	# Draw selected squad highlight
	if selected_squad and selected_squad.is_alive():
		var center := selected_squad.get_squad_center()
		draw_arc(center, 40.0, 0, TAU, 32, Color(1, 1, 0, 0.5), 2.0)

	# Draw intent arrows during command phase
	if current_phase == CombatPhase.COMMAND:
		for squad in player_squads:
			if not squad.is_alive():
				continue
			if squad.intent_type == GameEnums.IntentType.HOLD:
				continue
			var from := squad.get_squad_center()
			var to := squad.get_intent_position()
			if from.distance_to(to) > 10.0:
				var dir := (to - from).normalized()
				var color := Color(0.8, 0.8, 0.2, 0.5)
				match squad.intent_type:
					GameEnums.IntentType.ATTACK: color = Color(1.0, 0.3, 0.2, 0.5)
					GameEnums.IntentType.BREACH: color = Color(0.9, 0.6, 0.1, 0.5)
				draw_line(from, to, color, 2.0)
				# Arrowhead
				var perp := Vector2(-dir.y, dir.x)
				draw_line(to, to - dir * 12 + perp * 6, color, 2.0)
				draw_line(to, to - dir * 12 - perp * 6, color, 2.0)
