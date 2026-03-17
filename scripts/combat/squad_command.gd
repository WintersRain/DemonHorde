## Squad command structure for the boid-based combat system.
## Provides intent, cohesion, morale, and guard data. Does NOT control movement
## directly — the boid system and combat manager read this data.
class_name SquadCommand
extends Node2D

signal morale_changed(squad: SquadCommand, old_state: GameEnums.MoraleState, new_state: GameEnums.MoraleState)
signal squad_routed(squad: SquadCommand)
signal squad_rallied(squad: SquadCommand)
signal guard_zone_collapsed(guard_squad: SquadCommand, guarded_squad: SquadCommand)

# --- Identity ---
@export var squad_name: String = "Squad"
@export var tier: GameEnums.UnitTier = GameEnums.UnitTier.SWARMLING
@export var is_player: bool = true

# --- Members ---
## Array of demon entity node references (Node2D with position).
## External systems manage adding/removing members.
var members: Array[Node2D] = []

# --- Intent (set during command phase) ---
var intent_target_position: Vector2 = Vector2.ZERO
var intent_target_node: Node2D = null  ## If targeting a specific entity
var intent_type: GameEnums.IntentType = GameEnums.IntentType.HOLD
var behavior: GameEnums.SquadBehavior = GameEnums.SquadBehavior.DEFAULT

# --- Guard relationships ---
var guarding: SquadCommand = null       ## The squad we are guarding (we are the shield)
var guarded_by: Array[SquadCommand] = []  ## Squads that are guarding us (we are protected)

# --- Morale ---
var morale: float = 60.0  ## Demons start at 60 per spec
var _prev_morale_state: GameEnums.MoraleState = GameEnums.MoraleState.NORMAL

# --- Cohesion (computed, read-only externally) ---
var cohesion: float = 1.0

# --- Guard zone (computed) ---
var guard_zone_center: Vector2 = Vector2.ZERO
var guard_zone_radius: float = 0.0
var guard_zone_active: bool = false


# =============================================================================
# Max spread per tier (used for cohesion calculation)
# =============================================================================

const MAX_SPREAD: Dictionary = {
	GameEnums.UnitTier.SWARMLING: 150.0,
	GameEnums.UnitTier.BRUTE: 100.0,
	GameEnums.UnitTier.BEHEMOTH: 80.0,
}

# Guard zone radius per tier
const GUARD_ZONE_RADIUS: Dictionary = {
	GameEnums.UnitTier.SWARMLING: 60.0,
	GameEnums.UnitTier.BRUTE: 80.0,
	GameEnums.UnitTier.BEHEMOTH: 100.0,
}

# Morale thresholds
const MORALE_NORMAL: float = 70.0
const MORALE_SHAKEN: float = 40.0
const MORALE_WAVERING: float = 20.0
# Below MORALE_WAVERING = ROUTING

# Rally threshold: routing squad can recover if morale goes above this
const MORALE_RALLY: float = 30.0


# =============================================================================
# Lifecycle
# =============================================================================

func _ready() -> void:
	_prev_morale_state = get_morale_state()


# =============================================================================
# Squad center & cohesion
# =============================================================================

func get_living_members() -> Array[Node2D]:
	var living: Array[Node2D] = []
	for m in members:
		if is_instance_valid(m) and m.is_inside_tree():
			living.append(m)
	return living


func get_squad_center() -> Vector2:
	var living := get_living_members()
	if living.is_empty():
		return global_position
	var sum := Vector2.ZERO
	for m in living:
		sum += m.global_position
	return sum / float(living.size())


func compute_cohesion() -> void:
	## Recalculate cohesion from current member positions.
	var living := get_living_members()
	if living.size() <= 1:
		cohesion = 1.0
		_update_guard_zone()
		return

	var center := get_squad_center()
	var max_spread: float = MAX_SPREAD.get(tier, 150.0)

	var total_distance: float = 0.0
	for m in living:
		total_distance += m.global_position.distance_to(center)
	var avg_distance: float = total_distance / float(living.size())

	cohesion = clampf(1.0 - (avg_distance / max_spread), 0.0, 1.0)
	_update_guard_zone()


func get_max_spread() -> float:
	return MAX_SPREAD.get(tier, 150.0)


# =============================================================================
# Guard zone
# =============================================================================

func _update_guard_zone() -> void:
	## Recalculate guard zone position and state.
	if guarding == null or not is_instance_valid(guarding):
		guard_zone_active = false
		guard_zone_radius = 0.0
		return

	# Guard zone collapses if cohesion < 0.5
	var was_active := guard_zone_active
	guard_zone_active = cohesion >= 0.5

	if guard_zone_active:
		var our_center := get_squad_center()
		var their_center := guarding.get_squad_center()
		guard_zone_center = (our_center + their_center) / 2.0
		guard_zone_radius = GUARD_ZONE_RADIUS.get(tier, 60.0)
	else:
		guard_zone_radius = 0.0
		if was_active:
			guard_zone_collapsed.emit(self, guarding)


func is_position_in_guard_zone(pos: Vector2) -> bool:
	## Check if a world position falls inside this squad's active guard zone.
	if not guard_zone_active:
		return false
	return pos.distance_to(guard_zone_center) <= guard_zone_radius


# =============================================================================
# Guard queries (static-style, called on guarded squad or externally)
# =============================================================================

func get_engaging_guards(pos: Vector2) -> Array[SquadCommand]:
	## Return all guard squads whose zone covers the given position.
	## Call this on the guarded squad to find which guards would engage.
	var engaging: Array[SquadCommand] = []
	for guard in guarded_by:
		if is_instance_valid(guard) and guard.is_position_in_guard_zone(pos):
			engaging.append(guard)
	return engaging


func has_active_guard() -> bool:
	## Returns true if at least one guard squad has an active zone.
	for guard in guarded_by:
		if is_instance_valid(guard) and guard.guard_zone_active:
			return true
	return false


# =============================================================================
# Guard effectiveness (based on cohesion thresholds from spec)
# =============================================================================

func get_guard_effectiveness() -> float:
	## Returns the guard effectiveness multiplier for this squad as a guard.
	## 1.0 at cohesion >= 0.8, 0.5 at 0.5-0.8, 0.0 below 0.5.
	if cohesion >= 0.8:
		return 1.0
	elif cohesion >= 0.5:
		return 0.5
	else:
		return 0.0


func get_guard_defense_bonus() -> float:
	## +20% defense while in guard zone, scaled by effectiveness.
	return 0.2 * get_guard_effectiveness()


func get_guard_slow_factor() -> float:
	## Enemies in guard zone get -30% speed, scaled by effectiveness.
	return 0.3 * get_guard_effectiveness()


# =============================================================================
# Intent
# =============================================================================

func set_intent(type: GameEnums.IntentType, target_pos: Vector2, target_node: Node2D = null) -> void:
	intent_type = type
	intent_target_position = target_pos
	intent_target_node = target_node


func get_intent_position() -> Vector2:
	## Returns the effective intent position, following the target node if set.
	if intent_target_node != null and is_instance_valid(intent_target_node):
		return intent_target_node.global_position
	return intent_target_position


# =============================================================================
# Morale
# =============================================================================

func get_morale_state() -> GameEnums.MoraleState:
	if morale >= MORALE_NORMAL:
		return GameEnums.MoraleState.NORMAL
	elif morale >= MORALE_SHAKEN:
		return GameEnums.MoraleState.SHAKEN
	elif morale >= MORALE_WAVERING:
		return GameEnums.MoraleState.WAVERING
	else:
		return GameEnums.MoraleState.ROUTING


func apply_morale_change(amount: float) -> void:
	## Apply a morale modifier (positive or negative). Clamps to 0-100.
	var old_state := get_morale_state()
	morale = clampf(morale + amount, 0.0, 100.0)
	var new_state := get_morale_state()

	if old_state != new_state:
		morale_changed.emit(self, old_state, new_state)

		if new_state == GameEnums.MoraleState.ROUTING:
			squad_routed.emit(self)

		# Rally: was routing, recovered above threshold
		if old_state == GameEnums.MoraleState.ROUTING and morale >= MORALE_RALLY:
			squad_rallied.emit(self)


func apply_resolution_morale(deaths_this_round: int, enemy_routed: bool,
		behemoth_present: bool, behemoth_killed: bool,
		surrounded: bool, fire_nearby: bool) -> void:
	## Apply standard per-resolution-phase morale modifiers from the spec.
	var change: float = 0.0

	# Deaths: -3 per death
	change -= deaths_this_round * 3.0

	# Enemy squad routed: +10
	if enemy_routed:
		change += 10.0

	# Low cohesion: -5 per round
	if cohesion < 0.5:
		change -= 5.0

	# Behemoth presence: +5 to all friendly
	if behemoth_present:
		change += 5.0

	# Behemoth killed: -10 to all friendly
	if behemoth_killed:
		change -= 10.0

	# Surrounded: -10
	if surrounded:
		change -= 10.0

	# Fire nearby: +5 for demon pyromaniacs, -5 for humans
	if fire_nearby:
		if is_player:
			change += 5.0  # Demons love fire
		else:
			change -= 5.0

	apply_morale_change(change)


func get_attack_modifier() -> float:
	## Returns the attack multiplier based on morale state.
	match get_morale_state():
		GameEnums.MoraleState.SHAKEN:
			return 0.9  # -10%
		GameEnums.MoraleState.WAVERING:
			return 0.75  # -25%
		GameEnums.MoraleState.ROUTING:
			return 0.5  # Effectively fighting while running
	return 1.0


func get_hesitation_chance() -> float:
	## Chance per demon to skip their attack this round (Shaken effect).
	match get_morale_state():
		GameEnums.MoraleState.SHAKEN:
			return 0.1  # 10%
		GameEnums.MoraleState.WAVERING:
			return 0.25
		GameEnums.MoraleState.ROUTING:
			return 0.5
	return 0.0


# =============================================================================
# Guard relationship management
# =============================================================================

func assign_guard(guard_squad: SquadCommand) -> void:
	## Make guard_squad guard this squad.
	if guard_squad == self:
		return
	# Clear guard's previous assignment
	if guard_squad.guarding != null and guard_squad.guarding != self:
		guard_squad.guarding.guarded_by.erase(guard_squad)
	guard_squad.guarding = self
	if not guarded_by.has(guard_squad):
		guarded_by.append(guard_squad)
	guard_squad._update_guard_zone()


func remove_guard(guard_squad: SquadCommand) -> void:
	## Remove a guard assignment.
	guard_squad.guarding = null
	guarded_by.erase(guard_squad)
	guard_squad._update_guard_zone()


func clear_all_guards() -> void:
	## Remove all guard assignments on this squad.
	for guard in guarded_by.duplicate():
		remove_guard(guard)


# =============================================================================
# Member management
# =============================================================================

func add_member(demon: Node2D) -> void:
	if not members.has(demon):
		members.append(demon)


func remove_member(demon: Node2D) -> void:
	members.erase(demon)


func get_member_count() -> int:
	return get_living_members().size()


func is_alive() -> bool:
	return get_member_count() > 0


# =============================================================================
# Cohesion effects summary (for external systems to query)
# =============================================================================

func is_scattered() -> bool:
	## Cohesion 0.2-0.5: no guard benefits, fast morale loss.
	return cohesion >= 0.2 and cohesion < 0.5


func is_broken() -> bool:
	## Cohesion < 0.2: members act independently, morale rout check.
	return cohesion < 0.2
