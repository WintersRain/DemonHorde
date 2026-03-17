## A destructible building in the combat arena. Has HP, loot contents, fire system.
class_name Building
extends Node2D

signal destroyed(building: Building)
signal caught_fire(building: Building)

var building_type: GameEnums.BuildingType = GameEnums.BuildingType.HOUSE
var hp: int = 100
var max_hp: int = 100
var loot_contents: Array[LootItem] = []
var is_destroyed: bool = false

## Fire system
var on_fire: bool = false
var fire_damage_per_second: float = 10.0
var fire_spread_radius: float = 80.0
var _fire_timer: float = 0.0
var _fire_tick_interval: float = 1.0

## Visual size (buildings sit on 64px grid cells)
const BUILDING_SIZE: float = 56.0
const HALF_SIZE: float = 28.0

## Type-specific HP values
const TYPE_HP: Dictionary = {
	GameEnums.BuildingType.HOUSE: 100,
	GameEnums.BuildingType.MARKET: 120,
	GameEnums.BuildingType.BARRACKS: 200,
	GameEnums.BuildingType.GRANARY: 150,
	GameEnums.BuildingType.TEMPLE: 180,
	GameEnums.BuildingType.WALL_SEGMENT: 250,
	GameEnums.BuildingType.GATE: 300,
}

## Colors per building type
const TYPE_COLORS: Dictionary = {
	GameEnums.BuildingType.HOUSE: Color(0.6, 0.45, 0.3),      # Brown
	GameEnums.BuildingType.MARKET: Color(0.8, 0.7, 0.2),      # Yellow
	GameEnums.BuildingType.BARRACKS: Color(0.5, 0.5, 0.6),    # Steel gray
	GameEnums.BuildingType.GRANARY: Color(0.7, 0.6, 0.3),     # Wheat
	GameEnums.BuildingType.TEMPLE: Color(0.8, 0.8, 0.9),      # White-blue
	GameEnums.BuildingType.WALL_SEGMENT: Color(0.45, 0.4, 0.35), # Stone
	GameEnums.BuildingType.GATE: Color(0.55, 0.4, 0.25),      # Dark wood
}

## Letter identifiers for visual
const TYPE_LETTERS: Dictionary = {
	GameEnums.BuildingType.HOUSE: "H",
	GameEnums.BuildingType.MARKET: "M",
	GameEnums.BuildingType.BARRACKS: "B",
	GameEnums.BuildingType.GRANARY: "G",
	GameEnums.BuildingType.TEMPLE: "T",
	GameEnums.BuildingType.WALL_SEGMENT: "W",
	GameEnums.BuildingType.GATE: "=",
}

const RUBBLE_COLOR: Color = Color(0.3, 0.28, 0.25)


func _init(type: GameEnums.BuildingType = GameEnums.BuildingType.HOUSE) -> void:
	building_type = type
	max_hp = TYPE_HP.get(type, 100)
	hp = max_hp


func _ready() -> void:
	_generate_loot_contents()


func _process(delta: float) -> void:
	if on_fire and not is_destroyed:
		_fire_timer += delta
		if _fire_timer >= _fire_tick_interval:
			_fire_timer -= _fire_tick_interval
			take_damage(int(fire_damage_per_second))
			queue_redraw()


func _draw() -> void:
	if is_destroyed:
		_draw_rubble()
		return

	var color: Color = TYPE_COLORS.get(building_type, Color.GRAY)

	# Darken based on damage
	var hp_ratio: float = float(hp) / float(max_hp)
	if hp_ratio < 1.0:
		color = color.lerp(Color(0.3, 0.2, 0.15), 1.0 - hp_ratio)

	# Draw building body
	if building_type == GameEnums.BuildingType.WALL_SEGMENT:
		# Walls are thinner rectangles
		var rect := Rect2(-HALF_SIZE, -8, BUILDING_SIZE, 16)
		draw_rect(rect, color, true)
		draw_rect(rect, color.darkened(0.3), false, 1.5)
	elif building_type == GameEnums.BuildingType.GATE:
		# Gate has an opening in the middle
		var left := Rect2(-HALF_SIZE, -8, 18, 16)
		var right := Rect2(HALF_SIZE - 18, -8, 18, 16)
		draw_rect(left, color, true)
		draw_rect(right, color, true)
		draw_rect(left, color.darkened(0.3), false, 1.5)
		draw_rect(right, color.darkened(0.3), false, 1.5)
		# Gate bars
		draw_line(Vector2(-10, -8), Vector2(-10, 8), color.darkened(0.2), 2.0)
		draw_line(Vector2(10, -8), Vector2(10, 8), color.darkened(0.2), 2.0)
	else:
		# Standard building rectangle
		var rect := Rect2(-HALF_SIZE, -HALF_SIZE, BUILDING_SIZE, BUILDING_SIZE)
		draw_rect(rect, color, true)
		draw_rect(rect, color.darkened(0.3), false, 1.5)

		# Draw letter identifier
		var letter: String = TYPE_LETTERS.get(building_type, "?")
		draw_string(
			ThemeDB.fallback_font, Vector2(-6, 6),
			letter, HORIZONTAL_ALIGNMENT_CENTER, -1, 16,
			Color.WHITE
		)

	# Fire overlay
	if on_fire:
		_draw_fire()

	# HP bar
	if hp < max_hp:
		_draw_hp_bar()


func _draw_rubble() -> void:
	# Scattered rubble pieces
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(position)
	for i in 5:
		var offset := Vector2(
			rng.randf_range(-HALF_SIZE, HALF_SIZE),
			rng.randf_range(-HALF_SIZE, HALF_SIZE)
		)
		var size := rng.randf_range(4, 10)
		draw_rect(Rect2(offset, Vector2(size, size)), RUBBLE_COLOR, true)


func _draw_fire() -> void:
	# Simple fire visual — flickering orange/red shapes
	var time: float = fmod(Time.get_ticks_msec() / 200.0, TAU)
	for i in 3:
		var offset := Vector2(
			sin(time + i * 2.0) * 8.0,
			-10.0 - cos(time + i * 1.5) * 6.0
		)
		var fire_color := Color(1.0, 0.5 + sin(time + i) * 0.3, 0.1, 0.7)
		draw_circle(offset, 5.0 + sin(time * 2 + i) * 2.0, fire_color)


func _draw_hp_bar() -> void:
	var bar_width: float = BUILDING_SIZE
	var bar_height: float = 4.0
	var bar_y: float = HALF_SIZE + 4
	var hp_ratio: float = float(hp) / float(max_hp)

	draw_rect(Rect2(-HALF_SIZE, bar_y, bar_width, bar_height), Color(0.15, 0.15, 0.15, 0.8), true)
	var fill_color := Color(0.2, 0.8, 0.2).lerp(Color(0.8, 0.2, 0.2), 1.0 - hp_ratio)
	draw_rect(Rect2(-HALF_SIZE, bar_y, bar_width * hp_ratio, bar_height), fill_color, true)


func take_damage(amount: int) -> void:
	if is_destroyed:
		return
	hp = maxi(hp - amount, 0)
	queue_redraw()
	if hp <= 0:
		_on_destroyed()


func set_on_fire() -> void:
	if on_fire or is_destroyed:
		return
	on_fire = true
	_fire_timer = 0.0
	caught_fire.emit(self)
	queue_redraw()


func get_fire_spread_targets(all_buildings: Array) -> Array:
	## Returns buildings within fire_spread_radius that are not yet on fire.
	var targets: Array = []
	for b in all_buildings:
		if b == self or b.on_fire or b.is_destroyed:
			continue
		if b is Building and position.distance_to(b.position) <= fire_spread_radius:
			targets.append(b)
	return targets


func _on_destroyed() -> void:
	is_destroyed = true
	on_fire = false
	# Scatter loot contents around the building
	LootItem.scatter_items(loot_contents, position, 30.0)
	destroyed.emit(self)
	queue_redraw()


func _generate_loot_contents() -> void:
	## Populate loot_contents based on building type.
	match building_type:
		GameEnums.BuildingType.HOUSE:
			var count: int = randi_range(1, 3)
			for i in count:
				loot_contents.append(LootItem.new(GameEnums.LootType.COIN, randi_range(1, 3)))
		GameEnums.BuildingType.MARKET:
			var count: int = randi_range(5, 8)
			for i in count:
				var type: GameEnums.LootType
				var roll: float = randf()
				if roll < 0.5:
					type = GameEnums.LootType.COIN
				elif roll < 0.8:
					type = GameEnums.LootType.GEM
				else:
					type = GameEnums.LootType.SUPPLY
				loot_contents.append(LootItem.new(type, randi_range(2, 6)))
		GameEnums.BuildingType.BARRACKS:
			pass  # No loot
		GameEnums.BuildingType.GRANARY:
			var count: int = randi_range(3, 5)
			for i in count:
				loot_contents.append(LootItem.new(GameEnums.LootType.SUPPLY, randi_range(2, 5)))
		GameEnums.BuildingType.TEMPLE:
			pass  # No loot
		GameEnums.BuildingType.WALL_SEGMENT, GameEnums.BuildingType.GATE:
			pass  # No loot


func get_collision_rect() -> Rect2:
	## Returns the world-space bounding rect for collision queries.
	if building_type == GameEnums.BuildingType.WALL_SEGMENT:
		return Rect2(position + Vector2(-HALF_SIZE, -8), Vector2(BUILDING_SIZE, 16))
	elif building_type == GameEnums.BuildingType.GATE:
		if is_destroyed:
			return Rect2()  # Gate destroyed = passage open
		return Rect2(position + Vector2(-HALF_SIZE, -8), Vector2(BUILDING_SIZE, 16))
	return Rect2(position + Vector2(-HALF_SIZE, -HALF_SIZE), Vector2(BUILDING_SIZE, BUILDING_SIZE))
