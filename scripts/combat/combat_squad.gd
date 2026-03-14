## A squad on the combat grid. Visual representation + combat state.
class_name CombatSquad
extends Node2D

signal squad_died(squad: CombatSquad)
signal members_changed(squad: CombatSquad)

## Identity
@export var squad_name: String = "Squad"
@export var unit_name: String = "Imp"
@export var tier: GameEnums.UnitTier = GameEnums.UnitTier.SWARMLING
@export var is_player: bool = true

## Per-member stats
@export var member_hp: int = 10
@export var member_attack: int = 5
@export var member_defense: int = 2
@export var member_speed: int = 3

## Squad state
@export var unit_count: int = 20
@export var max_count: int = 20
@export var damage_type: GameEnums.DamageType = GameEnums.DamageType.SINGLE_TARGET
@export var attack_range: int = 1
@export var personality: GameEnums.Personality = GameEnums.Personality.LOYAL

## Grid position (set by CombatGrid)
var grid_pos := Vector2i.ZERO

## Guard system
var guarding: CombatSquad = null  ## Squad we're guarding
var guarded_by: Array[CombatSquad] = []  ## Squads guarding us

## Internal state
var has_acted: bool = false
var _current_hp: int = 0  ## HP of the "front" member (partial damage tracking)
var _squad_color: Color

## Visual nodes
var _sprite: Node2D
var _label: Label
var _hp_bar: ColorRect
var _hp_bar_bg: ColorRect


func _ready() -> void:
	_current_hp = member_hp
	_build_visuals()
	_update_visuals()


func _build_visuals() -> void:
	# Squad body — colored rectangle sized by tier
	_sprite = Node2D.new()
	add_child(_sprite)

	# Count label
	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", _get_font_size())
	_label.add_theme_color_override("font_color", Color.WHITE)
	_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	_label.add_theme_constant_override("shadow_offset_x", 1)
	_label.add_theme_constant_override("shadow_offset_y", 1)
	add_child(_label)

	# HP bar background
	_hp_bar_bg = ColorRect.new()
	_hp_bar_bg.color = Color(0.15, 0.15, 0.15, 0.8)
	add_child(_hp_bar_bg)

	# HP bar fill
	_hp_bar = ColorRect.new()
	_hp_bar.color = Color(0.2, 0.8, 0.2)
	add_child(_hp_bar)


func _get_font_size() -> int:
	match tier:
		GameEnums.UnitTier.SWARMLING: return 11
		GameEnums.UnitTier.BRUTE: return 13
		GameEnums.UnitTier.BEHEMOTH: return 16
	return 12


func _get_squad_size() -> float:
	match tier:
		GameEnums.UnitTier.SWARMLING: return 22.0
		GameEnums.UnitTier.BRUTE: return 30.0
		GameEnums.UnitTier.BEHEMOTH: return 40.0
	return 24.0


func set_squad_color(color: Color) -> void:
	_squad_color = color
	_update_visuals()


func _update_visuals() -> void:
	if not is_inside_tree():
		return

	var size := _get_squad_size()
	var half := size / 2.0

	# Redraw sprite
	_sprite.queue_redraw()
	if not _sprite.draw.is_connected(_draw_body):
		_sprite.draw.connect(_draw_body)

	# Position label centered
	_label.text = str(unit_count)
	_label.position = Vector2(-half, -half)
	_label.size = Vector2(size, size)

	# HP bar
	var bar_width := size + 4
	var bar_height := 4.0
	var bar_y := half + 3
	_hp_bar_bg.position = Vector2(-bar_width / 2, bar_y)
	_hp_bar_bg.size = Vector2(bar_width, bar_height)

	var hp_ratio := get_squad_hp_ratio()
	_hp_bar.position = Vector2(-bar_width / 2, bar_y)
	_hp_bar.size = Vector2(bar_width * hp_ratio, bar_height)
	_hp_bar.color = Color(0.2, 0.8, 0.2).lerp(Color(0.8, 0.2, 0.2), 1.0 - hp_ratio)


func _draw_body() -> void:
	var size := _get_squad_size()
	var half := size / 2.0
	var color := _squad_color
	if has_acted:
		color = color.darkened(0.4)

	# Draw body shape based on tier
	match tier:
		GameEnums.UnitTier.SWARMLING:
			# Small circle
			_sprite.draw_circle(Vector2.ZERO, half, color)
			_sprite.draw_arc(Vector2.ZERO, half, 0, TAU, 32, color.darkened(0.3), 2.0)
		GameEnums.UnitTier.BRUTE:
			# Rounded square
			var rect := Rect2(-half, -half, size, size)
			_sprite.draw_rect(rect, color, true)
			_sprite.draw_rect(rect, color.darkened(0.3), false, 2.0)
		GameEnums.UnitTier.BEHEMOTH:
			# Diamond / large shape
			var points := PackedVector2Array([
				Vector2(0, -half),
				Vector2(half, 0),
				Vector2(0, half),
				Vector2(-half, 0),
			])
			_sprite.draw_colored_polygon(points, color)
			_sprite.draw_polyline(points + PackedVector2Array([points[0]]), color.darkened(0.3), 2.0)

	# Guard indicator — small shield icon
	if guarding != null:
		_sprite.draw_circle(Vector2(half - 4, -half + 4), 4, Color(0.3, 0.7, 1.0, 0.8))


## --- COMBAT API ---

func get_total_hp() -> int:
	if unit_count <= 0:
		return 0
	return (unit_count - 1) * member_hp + _current_hp


func get_max_hp() -> int:
	return max_count * member_hp


func get_squad_hp_ratio() -> float:
	var max_hp := get_max_hp()
	if max_hp == 0:
		return 0.0
	return float(get_total_hp()) / float(max_hp)


func get_attack_power() -> int:
	return member_attack * unit_count


func get_strength_ratio() -> float:
	if max_count == 0:
		return 0.0
	return float(unit_count) / float(max_count)


func is_alive() -> bool:
	return unit_count > 0


func take_damage(amount: int) -> Dictionary:
	## Apply damage, kill members as their HP depletes.
	## Returns { "damage_dealt": int, "members_killed": int }
	var total_damage := maxi(amount - member_defense, 1)
	var damage_remaining := total_damage
	var killed := 0

	while damage_remaining > 0 and unit_count > 0:
		if damage_remaining >= _current_hp:
			damage_remaining -= _current_hp
			unit_count -= 1
			killed += 1
			_current_hp = member_hp
		else:
			_current_hp -= damage_remaining
			damage_remaining = 0

	if unit_count <= 0:
		unit_count = 0
		squad_died.emit(self)

	members_changed.emit(self)
	_update_visuals()

	return { "damage_dealt": total_damage, "members_killed": killed }


func calculate_damage_to(target: CombatSquad) -> int:
	## Calculate raw damage output against a target based on our damage type.
	var base := get_attack_power()

	match damage_type:
		GameEnums.DamageType.SINGLE_TARGET:
			return base
		GameEnums.DamageType.CLEAVE:
			# Spread damage is more effective vs large squads
			return base
		GameEnums.DamageType.ANTI_HORDE:
			# Bonus based on target squad size
			var horde_bonus := 1.0 + (float(target.unit_count) / 50.0)
			return int(base * horde_bonus)
		GameEnums.DamageType.PRECISION:
			# Bonus vs small squads
			var precision_bonus := 1.0 + (1.0 - target.get_strength_ratio())
			return int(base * precision_bonus)

	return base


func reset_turn() -> void:
	has_acted = false
	_update_visuals()
