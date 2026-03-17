## The continuous 2D combat battlefield. Manages buildings, loot, walls, and spatial queries.
class_name CombatArena
extends Node2D

signal building_destroyed(building: Building)
signal loot_collected(item: LootItem)

const ARENA_WIDTH: float = 1200.0
const ARENA_HEIGHT: float = 800.0
const CELL_SIZE: float = 64.0
const BG_COLOR: Color = Color(0.25, 0.35, 0.2)  # Dark grass
const GRID_LINE_COLOR: Color = Color(0.3, 0.4, 0.25, 0.15)

var buildings: Array[Building] = []
var loot_items: Array[LootItem] = []

## Fire spread timer
var _fire_spread_timer: float = 0.0
const FIRE_SPREAD_INTERVAL: float = 3.0
const FIRE_SPREAD_CHANCE: float = 0.3


func _process(delta: float) -> void:
	_update_fire_spread(delta)


func _draw() -> void:
	# Arena background
	draw_rect(Rect2(Vector2.ZERO, Vector2(ARENA_WIDTH, ARENA_HEIGHT)), BG_COLOR, true)

	# Faint grid lines for orientation
	var cols: int = int(ARENA_WIDTH / CELL_SIZE)
	var rows: int = int(ARENA_HEIGHT / CELL_SIZE)
	for x in cols + 1:
		draw_line(
			Vector2(x * CELL_SIZE, 0), Vector2(x * CELL_SIZE, ARENA_HEIGHT),
			GRID_LINE_COLOR, 1.0
		)
	for y in rows + 1:
		draw_line(
			Vector2(0, y * CELL_SIZE), Vector2(ARENA_WIDTH, y * CELL_SIZE),
			GRID_LINE_COLOR, 1.0
		)

	# Arena border
	draw_rect(
		Rect2(Vector2.ZERO, Vector2(ARENA_WIDTH, ARENA_HEIGHT)),
		Color(0.5, 0.5, 0.5, 0.5), false, 2.0
	)


func add_building(building: Building) -> void:
	buildings.append(building)
	building.destroyed.connect(_on_building_destroyed)
	building.caught_fire.connect(_on_building_caught_fire)
	add_child(building)


func add_loot(item: LootItem) -> void:
	loot_items.append(item)
	item.collected.connect(_on_loot_collected)
	add_child(item)


func remove_loot(item: LootItem) -> void:
	loot_items.erase(item)
	if item.is_inside_tree():
		remove_child(item)


## --- SPATIAL QUERIES ---

func get_buildings_in_radius(center: Vector2, radius: float) -> Array[Building]:
	var result: Array[Building] = []
	var radius_sq: float = radius * radius
	for b in buildings:
		if not b.is_destroyed and center.distance_squared_to(b.position) <= radius_sq:
			result.append(b)
	return result


func get_loot_in_radius(center: Vector2, radius: float) -> Array[LootItem]:
	var result: Array[LootItem] = []
	var radius_sq: float = radius * radius
	for item in loot_items:
		if not item.picked_up and center.distance_squared_to(item.position) <= radius_sq:
			result.append(item)
	return result


func is_position_blocked(pos: Vector2) -> bool:
	## Returns true if the position is inside a standing building or wall.
	for b in buildings:
		if b.is_destroyed:
			continue
		if b.get_collision_rect().has_point(pos):
			return true
	# Arena bounds
	if pos.x < 0 or pos.x > ARENA_WIDTH or pos.y < 0 or pos.y > ARENA_HEIGHT:
		return true
	return false


func get_avoidance_force(pos: Vector2, avoidance_radius: float = 20.0) -> Vector2:
	## Returns a steering force pushing away from nearby walls and buildings.
	var force := Vector2.ZERO
	for b in buildings:
		if b.is_destroyed:
			continue
		var rect: Rect2 = b.get_collision_rect()
		if rect.size == Vector2.ZERO:
			continue
		# Find closest point on rect to pos
		var closest := Vector2(
			clampf(pos.x, rect.position.x, rect.end.x),
			clampf(pos.y, rect.position.y, rect.end.y)
		)
		var diff: Vector2 = pos - closest
		var dist: float = diff.length()
		if dist < avoidance_radius and dist > 0.01:
			force += diff.normalized() * (avoidance_radius - dist) / avoidance_radius

	# Arena boundary avoidance
	if pos.x < avoidance_radius:
		force += Vector2(1, 0) * (avoidance_radius - pos.x) / avoidance_radius
	if pos.x > ARENA_WIDTH - avoidance_radius:
		force += Vector2(-1, 0) * (avoidance_radius - (ARENA_WIDTH - pos.x)) / avoidance_radius
	if pos.y < avoidance_radius:
		force += Vector2(0, 1) * (avoidance_radius - pos.y) / avoidance_radius
	if pos.y > ARENA_HEIGHT - avoidance_radius:
		force += Vector2(0, -1) * (avoidance_radius - (ARENA_HEIGHT - pos.y)) / avoidance_radius

	return force


func get_nearest_building(pos: Vector2, type_filter: GameEnums.BuildingType = -1) -> Building:
	## Returns the nearest non-destroyed building, optionally filtered by type.
	var nearest: Building = null
	var nearest_dist_sq: float = INF
	for b in buildings:
		if b.is_destroyed:
			continue
		if type_filter >= 0 and b.building_type != type_filter:
			continue
		var dist_sq: float = pos.distance_squared_to(b.position)
		if dist_sq < nearest_dist_sq:
			nearest_dist_sq = dist_sq
			nearest = b
	return nearest


func get_nearest_loot(pos: Vector2) -> LootItem:
	## Returns the nearest uncollected loot item.
	var nearest: LootItem = null
	var nearest_dist_sq: float = INF
	for item in loot_items:
		if item.picked_up:
			continue
		var dist_sq: float = pos.distance_squared_to(item.position)
		if dist_sq < nearest_dist_sq:
			nearest_dist_sq = dist_sq
			nearest = item
	return nearest


func get_arena_size() -> Vector2:
	return Vector2(ARENA_WIDTH, ARENA_HEIGHT)


## --- FIRE SYSTEM ---

func _update_fire_spread(delta: float) -> void:
	_fire_spread_timer += delta
	if _fire_spread_timer < FIRE_SPREAD_INTERVAL:
		return
	_fire_spread_timer -= FIRE_SPREAD_INTERVAL

	# Check each burning building for fire spread
	for b in buildings:
		if not b.on_fire or b.is_destroyed:
			continue
		var targets: Array = b.get_fire_spread_targets(buildings)
		for target in targets:
			if randf() < FIRE_SPREAD_CHANCE:
				target.set_on_fire()


## --- SIGNAL HANDLERS ---

func _on_building_destroyed(building: Building) -> void:
	# Move loot contents into the arena as physical items
	for item in building.loot_contents:
		add_loot(item)
	building_destroyed.emit(building)


func _on_building_caught_fire(_building: Building) -> void:
	queue_redraw()


func _on_loot_collected(item: LootItem) -> void:
	loot_collected.emit(item)


## --- SETUP ---

func clear_arena() -> void:
	for b in buildings:
		b.queue_free()
	buildings.clear()
	for item in loot_items:
		item.queue_free()
	loot_items.clear()
	queue_redraw()
