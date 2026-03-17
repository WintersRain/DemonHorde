## Standalone boid steering processor. Computes velocities for an array of DemonEntity nodes.
## Does NOT move them — just sets their velocity vectors. The caller applies movement.
class_name BoidSystem
extends RefCounted

# --- Base Weights (Swarmling defaults from spec) ---
const W_SEPARATION: float = 1.5
const W_ALIGNMENT: float = 1.0
const W_COHESION: float = 1.2
const W_INTENT: float = 2.0
const W_AVOIDANCE: float = 3.0
# Personality weight is variable (0.0 - 3.0), set per trigger.

# --- Radii ---
const SEPARATION_RADIUS: float = 15.0
const AVOIDANCE_RADIUS: float = 20.0

# --- Personality trigger distances ---
const GREEDY_LOOT_DETECT: float = 100.0
const GREEDY_LOOT_LOST: float = 150.0
const COWARD_ENEMY_NEAR: float = 60.0
const COWARD_SAFE_DIST: float = 200.0
const BERSERKER_ENGAGE: float = 120.0
const BERSERKER_DISENGAGE: float = 200.0
const PYROMANIAC_DETECT: float = 80.0

# --- Tier weight modifiers (cohesion, separation, alignment) ---
static func _get_tier_weights(tier: GameEnums.UnitTier) -> Vector3:
	## Returns Vector3(cohesion, separation, alignment) modifier for the tier.
	match tier:
		GameEnums.UnitTier.SWARMLING:
			return Vector3(1.2, 1.5, 1.0)
		GameEnums.UnitTier.BRUTE:
			return Vector3(1.0, 2.0, 0.8)
		GameEnums.UnitTier.BEHEMOTH:
			return Vector3(0.5, 3.0, 0.3)
	return Vector3(1.2, 1.5, 1.0)


## Main entry point. Updates velocity on every living demon in the array.
## Parameters:
##   demons       - Array of DemonEntity nodes
##   squad_data   - Dictionary keyed by squad reference, value is Dictionary:
##                  { "center": Vector2, "avg_velocity": Vector2,
##                    "intent_target": Vector2, "hp_ratio": float }
##   enemies      - Array of DemonEntity (or any Node2D with position) representing foes
##   loot_items   - Array of Dictionaries with "position": Vector2, "picked_up": bool
##   obstacles    - Array of Dictionaries with "position": Vector2, "radius": float
##                  (buildings, walls, etc.)
func update_velocities(
	demons: Array,
	squad_data: Dictionary,
	enemies: Array,
	loot_items: Array,
	obstacles: Array,
) -> void:
	for demon: DemonEntity in demons:
		if not demon.is_alive():
			continue
		_update_single(demon, demons, squad_data, enemies, loot_items, obstacles)


func _update_single(
	demon: DemonEntity,
	all_demons: Array,
	squad_data: Dictionary,
	enemies: Array,
	loot_items: Array,
	obstacles: Array,
) -> void:
	# Get squad info
	var sdata: Dictionary = squad_data.get(demon.squad, {})
	var squad_center: Vector2 = sdata.get("center", demon.position)
	var squad_avg_vel: Vector2 = sdata.get("avg_velocity", Vector2.ZERO)
	var intent_target: Vector2 = sdata.get("intent_target", demon.position)
	var squad_hp_ratio: float = sdata.get("hp_ratio", 1.0)

	# Get tier weight modifiers
	var tw := _get_tier_weights(demon.tier)
	var w_coh := tw.x
	var w_sep := tw.y
	var w_ali := tw.z

	# --- Evaluate personality triggers and update state ---
	var pers_result := _compute_personality(
		demon, enemies, loot_items, squad_hp_ratio, obstacles
	)
	var personality_force: Vector2 = pers_result.force
	var w_pers: float = pers_result.weight
	var w_intent: float = pers_result.intent_weight
	w_coh = pers_result.cohesion_mod

	# --- Compute the 6 steering forces ---
	var separation := _compute_separation(demon, all_demons)
	var alignment := _compute_alignment(demon, all_demons, squad_avg_vel)
	var cohesion := _compute_cohesion(demon, squad_center)
	var intent := _compute_intent(demon, intent_target)
	var avoidance := _compute_avoidance(demon, obstacles)

	# --- Weighted sum ---
	var combined := (
		separation * w_sep * W_SEPARATION +
		alignment * w_ali * W_ALIGNMENT +
		cohesion * w_coh * W_COHESION +
		intent * w_intent +
		personality_force * w_pers +
		avoidance * W_AVOIDANCE
	)

	# Normalize and scale to speed
	if combined.length_squared() > 0.001:
		demon.velocity = combined.normalized() * demon.get_effective_speed()
	else:
		demon.velocity = Vector2.ZERO


# --- Personality Evaluation ---

## Evaluates personality triggers and returns force, weight, intent override, cohesion override.
func _compute_personality(
	demon: DemonEntity,
	enemies: Array,
	loot_items: Array,
	squad_hp_ratio: float,
	obstacles: Array = [],
) -> Dictionary:
	var force := Vector2.ZERO
	var weight: float = 0.0
	var intent_w: float = W_INTENT
	var coh_mod: float = _get_tier_weights(demon.tier).x  # base tier cohesion

	match demon.personality:
		GameEnums.Personality.GREEDY:
			var result := _personality_greedy(demon, loot_items)
			force = result.force
			weight = result.weight
			coh_mod = result.cohesion_mod

		GameEnums.Personality.COWARD:
			var result := _personality_coward(demon, enemies, squad_hp_ratio)
			force = result.force
			weight = result.weight

		GameEnums.Personality.BERSERKER:
			var result := _personality_berserker(demon, enemies)
			force = result.force
			weight = result.weight
			intent_w = result.intent_weight
			coh_mod = result.cohesion_mod

		GameEnums.Personality.PYROMANIAC:
			var result := _personality_pyromaniac(demon, obstacles)
			force = result.force
			weight = result.weight
			# Pyromaniacs don't change state

		GameEnums.Personality.LOYAL:
			# No personality force. Cohesion boosted.
			coh_mod = 2.0

	return {
		"force": force,
		"weight": weight,
		"intent_weight": intent_w,
		"cohesion_mod": coh_mod,
	}


func _personality_greedy(demon: DemonEntity, loot_items: Array) -> Dictionary:
	var base_coh := _get_tier_weights(demon.tier).x
	if demon.is_inventory_full():
		# Full inventory, stop looting
		if demon.state == GameEnums.DemonState.LOOTING:
			demon.state = GameEnums.DemonState.FOLLOWING
		return { "force": Vector2.ZERO, "weight": 0.0, "cohesion_mod": base_coh }

	# Find nearest unpicked loot
	var nearest_loot: Dictionary = {}
	var nearest_dist: float = INF
	for item in loot_items:
		if item.get("picked_up", false):
			continue
		var dist: float = demon.position.distance_to(item.position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_loot = item

	if nearest_loot.is_empty():
		if demon.state == GameEnums.DemonState.LOOTING:
			demon.state = GameEnums.DemonState.FOLLOWING
		return { "force": Vector2.ZERO, "weight": 0.0, "cohesion_mod": base_coh }

	if nearest_dist <= GREEDY_LOOT_DETECT:
		# Trigger: loot nearby
		if demon.state == GameEnums.DemonState.FOLLOWING:
			demon.state = GameEnums.DemonState.LOOTING
		var dir := (nearest_loot.position - demon.position).normalized()
		return { "force": dir, "weight": 2.5, "cohesion_mod": 0.3 }

	# Already looting but loot drifted beyond lost range
	if demon.state == GameEnums.DemonState.LOOTING:
		if nearest_dist > GREEDY_LOOT_LOST:
			demon.state = GameEnums.DemonState.FOLLOWING
			return { "force": Vector2.ZERO, "weight": 0.0, "cohesion_mod": base_coh }
		# Still pursuing
		var dir := (nearest_loot.position - demon.position).normalized()
		return { "force": dir, "weight": 2.5, "cohesion_mod": 0.3 }

	return { "force": Vector2.ZERO, "weight": 0.0, "cohesion_mod": base_coh }


func _personality_coward(
	demon: DemonEntity, enemies: Array, squad_hp_ratio: float
) -> Dictionary:
	var nearest_enemy: DemonEntity = null
	var nearest_dist: float = INF
	for enemy in enemies:
		if not enemy.is_alive():
			continue
		var dist: float = demon.position.distance_to(enemy.position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_enemy = enemy

	if nearest_enemy == null:
		if demon.state == GameEnums.DemonState.FLEEING:
			demon.state = GameEnums.DemonState.FOLLOWING
		return { "force": Vector2.ZERO, "weight": 0.0 }

	# Trigger: squad HP below 50% OR (enemy near AND personal HP low)
	var should_flee := false
	if squad_hp_ratio < 0.5:
		should_flee = true
	elif nearest_dist <= COWARD_ENEMY_NEAR and demon.get_hp_ratio() < 0.5:
		should_flee = true

	if should_flee:
		if demon.state == GameEnums.DemonState.FOLLOWING:
			demon.state = GameEnums.DemonState.FLEEING
		var away_dir := (demon.position - nearest_enemy.position).normalized()
		return { "force": away_dir, "weight": 3.0 }

	# Exit condition: no enemies within safe distance
	if demon.state == GameEnums.DemonState.FLEEING:
		if nearest_dist > COWARD_SAFE_DIST:
			demon.state = GameEnums.DemonState.FOLLOWING
			return { "force": Vector2.ZERO, "weight": 0.0 }
		# Still fleeing
		var away_dir := (demon.position - nearest_enemy.position).normalized()
		return { "force": away_dir, "weight": 3.0 }

	return { "force": Vector2.ZERO, "weight": 0.0 }


func _personality_berserker(demon: DemonEntity, enemies: Array) -> Dictionary:
	var base_tw := _get_tier_weights(demon.tier)
	var base_coh: float = base_tw.x

	var nearest_enemy: DemonEntity = null
	var nearest_dist: float = INF
	for enemy in enemies:
		if not enemy.is_alive():
			continue
		var dist: float = demon.position.distance_to(enemy.position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_enemy = enemy

	if nearest_enemy == null:
		if demon.state == GameEnums.DemonState.BERSERK:
			demon.state = GameEnums.DemonState.FOLLOWING
		return {
			"force": Vector2.ZERO, "weight": 0.0,
			"intent_weight": W_INTENT, "cohesion_mod": base_coh,
		}

	# Trigger: any enemy within engage range
	if nearest_dist <= BERSERKER_ENGAGE:
		if demon.state == GameEnums.DemonState.FOLLOWING:
			demon.state = GameEnums.DemonState.BERSERK
		var toward := (nearest_enemy.position - demon.position).normalized()
		return {
			"force": toward, "weight": 3.0,
			"intent_weight": 0.5, "cohesion_mod": 0.2,
		}

	# Exit condition
	if demon.state == GameEnums.DemonState.BERSERK:
		if nearest_dist > BERSERKER_DISENGAGE:
			demon.state = GameEnums.DemonState.FOLLOWING
			return {
				"force": Vector2.ZERO, "weight": 0.0,
				"intent_weight": W_INTENT, "cohesion_mod": base_coh,
			}
		# Still berserk, chasing
		var toward := (nearest_enemy.position - demon.position).normalized()
		return {
			"force": toward, "weight": 3.0,
			"intent_weight": 0.5, "cohesion_mod": 0.2,
		}

	return {
		"force": Vector2.ZERO, "weight": 0.0,
		"intent_weight": W_INTENT, "cohesion_mod": base_coh,
	}


func _personality_pyromaniac(demon: DemonEntity, obstacles: Array) -> Dictionary:
	## Pyromaniacs steer toward the nearest flammable object but don't change state.
	## We treat obstacles (buildings) as potential flammable targets.
	var nearest_pos: Vector2 = Vector2.ZERO
	var nearest_dist: float = INF
	var found := false

	for obs in obstacles:
		var obs_pos: Vector2 = obs.get("position", Vector2.ZERO)
		var flammable: bool = obs.get("flammable", true)
		if not flammable:
			continue
		var dist: float = demon.position.distance_to(obs_pos)
		if dist < PYROMANIAC_DETECT and dist < nearest_dist:
			nearest_dist = dist
			nearest_pos = obs_pos
			found = true

	if found:
		var toward := (nearest_pos - demon.position).normalized()
		return { "force": toward, "weight": 1.5 }

	return { "force": Vector2.ZERO, "weight": 0.0 }


# --- Core Steering Forces ---

func _compute_separation(demon: DemonEntity, all_demons: Array) -> Vector2:
	var steer := Vector2.ZERO
	var count := 0
	for other: DemonEntity in all_demons:
		if other == demon or not other.is_alive():
			continue
		var diff := demon.position - other.position
		var dist := diff.length()
		if dist > 0.0 and dist < SEPARATION_RADIUS:
			steer += diff.normalized() / dist  # Closer = stronger push
			count += 1
	if count > 0:
		steer /= float(count)
	return steer.normalized() if steer.length_squared() > 0.001 else Vector2.ZERO


func _compute_alignment(
	demon: DemonEntity, all_demons: Array, squad_avg_velocity: Vector2
) -> Vector2:
	## Align with squad-mates' heading. Uses precomputed squad average velocity.
	if squad_avg_velocity.length_squared() < 0.001:
		return Vector2.ZERO
	return squad_avg_velocity.normalized()


func _compute_cohesion(demon: DemonEntity, squad_center: Vector2) -> Vector2:
	var diff := squad_center - demon.position
	if diff.length_squared() < 1.0:
		return Vector2.ZERO
	return diff.normalized()


func _compute_intent(demon: DemonEntity, intent_target: Vector2) -> Vector2:
	var diff := intent_target - demon.position
	if diff.length_squared() < 4.0:  # Within 2px, close enough
		return Vector2.ZERO
	return diff.normalized()


func _compute_avoidance(demon: DemonEntity, obstacles: Array) -> Vector2:
	var steer := Vector2.ZERO
	var count := 0
	for obs in obstacles:
		var obs_pos: Vector2 = obs.get("position", Vector2.ZERO)
		var obs_radius: float = obs.get("radius", 32.0)
		var diff := demon.position - obs_pos
		var dist := diff.length()
		var avoid_dist := obs_radius + AVOIDANCE_RADIUS
		if dist > 0.0 and dist < avoid_dist:
			steer += diff.normalized() * (avoid_dist / dist)
			count += 1
	if count > 0:
		steer /= float(count)
	return steer.normalized() if steer.length_squared() > 0.001 else Vector2.ZERO
