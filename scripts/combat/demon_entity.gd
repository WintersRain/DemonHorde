## An individual demon on the battlefield. Moves via boid steering, fights, loots, dies.
class_name DemonEntity
extends Node2D

signal died(demon: DemonEntity)

# --- Identity ---
var demon_name: String = "Imp"
var tier: GameEnums.UnitTier = GameEnums.UnitTier.SWARMLING
var personality: GameEnums.Personality = GameEnums.Personality.LOYAL
var squad: Node = null  ## Reference to parent squad (set externally)

# --- Stats (set at spawn based on tier) ---
var max_hp: int = 8
var hp: int = 8
var attack_power: int = 4
var defense: int = 1
var speed: float = 100.0  ## px/s
var attack_range: float = 20.0  ## px
var loot_capacity: int = 1

# --- State ---
var state: GameEnums.DemonState = GameEnums.DemonState.FOLLOWING
var velocity: Vector2 = Vector2.ZERO
var attack_cooldown: float = 0.0
var attack_cooldown_max: float = 0.8
var inventory: Array = []  ## Array of loot item references (Dictionaries or objects)

# --- Visual ---
var _body_color: Color = Color(0.9, 0.3, 0.2)
var _visual_radius: float = 7.0
var _hp_bar_width: float = 12.0
var _hp_bar_height: float = 2.0


# --- Tier Stat Tables ---
# Returns { hp_range, attack_range, defense_range, speed_range, atk_range_px,
#            cooldown, loot_cap, visual_radius }
static func get_tier_stats(t: GameEnums.UnitTier) -> Dictionary:
	match t:
		GameEnums.UnitTier.SWARMLING:
			return {
				"hp_min": 5, "hp_max": 10,
				"atk_min": 3, "atk_max": 5,
				"def_min": 1, "def_max": 2,
				"speed_min": 80.0, "speed_max": 120.0,
				"attack_range": 20.0,
				"cooldown": 0.8,
				"loot_capacity": 1,
				"radius_min": 6.0, "radius_max": 8.0,
			}
		GameEnums.UnitTier.BRUTE:
			return {
				"hp_min": 20, "hp_max": 40,
				"atk_min": 8, "atk_max": 15,
				"def_min": 4, "def_max": 8,
				"speed_min": 50.0, "speed_max": 80.0,
				"attack_range": 30.0,
				"cooldown": 1.2,
				"loot_capacity": 3,
				"radius_min": 12.0, "radius_max": 16.0,
			}
		GameEnums.UnitTier.BEHEMOTH:
			return {
				"hp_min": 80, "hp_max": 150,
				"atk_min": 25, "atk_max": 50,
				"def_min": 10, "def_max": 20,
				"speed_min": 30.0, "speed_max": 50.0,
				"attack_range": 50.0,
				"cooldown": 2.0,
				"loot_capacity": 5,
				"radius_min": 24.0, "radius_max": 32.0,
			}
	# Fallback (should never hit)
	return {}


## Initialize stats from tier, rolling random values within tier ranges.
func init_from_tier(t: GameEnums.UnitTier, pers: GameEnums.Personality) -> void:
	tier = t
	personality = pers
	var stats := get_tier_stats(t)

	max_hp = randi_range(stats.hp_min, stats.hp_max)
	hp = max_hp
	attack_power = randi_range(stats.atk_min, stats.atk_max)
	defense = randi_range(stats.def_min, stats.def_max)
	speed = randf_range(stats.speed_min, stats.speed_max)
	attack_range = stats.attack_range
	attack_cooldown_max = stats.cooldown
	loot_capacity = stats.loot_capacity
	_visual_radius = randf_range(stats.radius_min, stats.radius_max)
	_hp_bar_width = _visual_radius * 2.0 + 2.0


func _ready() -> void:
	# Nothing to child-node here; we draw directly.
	pass


func _draw() -> void:
	if state == GameEnums.DemonState.DEAD:
		return

	# Body: colored circle
	var color := _body_color
	match state:
		GameEnums.DemonState.LOOTING:
			color = color.lerp(Color.GOLD, 0.4)
		GameEnums.DemonState.FLEEING:
			color = color.lerp(Color.CYAN, 0.35)
		GameEnums.DemonState.BERSERK:
			color = color.lerp(Color.RED, 0.5)

	draw_circle(Vector2.ZERO, _visual_radius, color)
	draw_arc(Vector2.ZERO, _visual_radius, 0, TAU, 24, color.darkened(0.35), 1.5)

	# HP bar (below body)
	if hp < max_hp:
		var bar_y := _visual_radius + 2.0
		var hp_ratio := float(hp) / float(max_hp)
		var bar_color := Color(0.2, 0.85, 0.2).lerp(Color(0.9, 0.15, 0.15), 1.0 - hp_ratio)

		# Background
		draw_rect(
			Rect2(-_hp_bar_width / 2.0, bar_y, _hp_bar_width, _hp_bar_height),
			Color(0.1, 0.1, 0.1, 0.7), true
		)
		# Fill
		draw_rect(
			Rect2(-_hp_bar_width / 2.0, bar_y, _hp_bar_width * hp_ratio, _hp_bar_height),
			bar_color, true
		)


func set_body_color(color: Color) -> void:
	_body_color = color
	queue_redraw()


# --- Combat API ---

func is_alive() -> bool:
	return state != GameEnums.DemonState.DEAD and hp > 0


func get_hp_ratio() -> float:
	if max_hp <= 0:
		return 0.0
	return float(hp) / float(max_hp)


func take_damage(amount: int) -> int:
	## Apply damage (reduced by defense, minimum 1). Returns actual damage dealt.
	if not is_alive():
		return 0
	var actual := maxi(amount - defense, 1)
	hp -= actual
	if hp <= 0:
		hp = 0
		_die()
	queue_redraw()
	return actual


func can_attack() -> bool:
	return is_alive() and attack_cooldown <= 0.0


func reset_attack_cooldown() -> void:
	attack_cooldown = attack_cooldown_max


func tick_cooldown(delta: float) -> void:
	if attack_cooldown > 0.0:
		attack_cooldown -= delta
		if attack_cooldown < 0.0:
			attack_cooldown = 0.0


func get_effective_speed() -> float:
	## Returns speed with personality modifiers applied.
	var s := speed
	if state == GameEnums.DemonState.FLEEING and personality == GameEnums.Personality.COWARD:
		s *= 1.4  # +40% speed while fleeing
	return s


func get_effective_attack() -> int:
	## Returns attack power with personality modifiers applied.
	var atk := attack_power
	if state == GameEnums.DemonState.BERSERK and personality == GameEnums.Personality.BERSERKER:
		atk = int(atk * 1.3)  # +30% damage while berserk
	return atk


func is_inventory_full() -> bool:
	return inventory.size() >= loot_capacity


func collect_loot(item: Dictionary) -> bool:
	## Try to pick up a loot item. Returns true on success.
	if is_inventory_full():
		return false
	inventory.append(item)
	return true


func drop_inventory() -> Array:
	## Drop all carried loot. Returns the array of items.
	var dropped := inventory.duplicate()
	inventory.clear()
	return dropped


func _die() -> void:
	state = GameEnums.DemonState.DEAD
	died.emit(self)
	queue_redraw()
