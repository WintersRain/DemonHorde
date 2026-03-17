## Generates settlement layouts for the combat arena. Templates per settlement size.
class_name SettlementGenerator
extends RefCounted

## Placement data returned by generate()
class BuildingPlacement:
	var building_type: GameEnums.BuildingType
	var grid_pos: Vector2i  ## Position in 64px grid cells
	var world_pos: Vector2  ## Center position in world space

	func _init(type: GameEnums.BuildingType, gpos: Vector2i) -> void:
		building_type = type
		grid_pos = gpos
		world_pos = Vector2(gpos.x * 64.0 + 32.0, gpos.y * 64.0 + 32.0)

## Result of a generation pass
class SettlementLayout:
	var placements: Array[BuildingPlacement] = []
	var settlement_size: GameEnums.SettlementSize
	var grid_width: int
	var grid_height: int

const GRID_COLS: int = 18  ## 1200 / 64 ≈ 18
const GRID_ROWS: int = 12  ## 800 / 64 ≈ 12

## Weighted building distribution for fill slots
const FILL_WEIGHTS: Dictionary = {
	GameEnums.BuildingType.HOUSE: 5,
	GameEnums.BuildingType.MARKET: 2,
	GameEnums.BuildingType.GRANARY: 3,
}


func generate(size: GameEnums.SettlementSize) -> SettlementLayout:
	match size:
		GameEnums.SettlementSize.HAMLET:
			return _generate_hamlet()
		GameEnums.SettlementSize.VILLAGE:
			return _generate_village()
		_:
			# Town/City not yet implemented — fall back to village
			return _generate_village()


func _generate_hamlet() -> SettlementLayout:
	## Hamlet: 4-6 buildings, no walls, open field with scattered structures.
	var layout := SettlementLayout.new()
	layout.settlement_size = GameEnums.SettlementSize.HAMLET
	layout.grid_width = GRID_COLS
	layout.grid_height = GRID_ROWS

	var occupied: Dictionary = {}
	var building_count: int = randi_range(4, 6)

	# Place buildings in the right half of the map (defenders' side)
	# Player approaches from left
	var min_x: int = 9
	var max_x: int = 16
	var min_y: int = 2
	var max_y: int = 9

	# First building is always a key structure
	var key_type: GameEnums.BuildingType = _pick_weighted([
		[GameEnums.BuildingType.GRANARY, 3],
		[GameEnums.BuildingType.TEMPLE, 2],
		[GameEnums.BuildingType.BARRACKS, 1],
	])
	var key_pos := _find_open_pos(occupied, min_x, max_x, min_y, max_y)
	if key_pos != Vector2i(-1, -1):
		_place(layout, occupied, key_type, key_pos)

	# Fill remaining with weighted random houses/markets/granaries
	for i in building_count - 1:
		var pos := _find_open_pos(occupied, min_x, max_x, min_y, max_y)
		if pos == Vector2i(-1, -1):
			break
		var fill_type: GameEnums.BuildingType = _pick_fill_type()
		_place(layout, occupied, fill_type, pos)

	return layout


func _generate_village() -> SettlementLayout:
	## Village: 8-15 buildings, palisade wall with 1-2 gates, central square.
	var layout := SettlementLayout.new()
	layout.settlement_size = GameEnums.SettlementSize.VILLAGE
	layout.grid_width = GRID_COLS
	layout.grid_height = GRID_ROWS

	var occupied: Dictionary = {}

	# Village occupies right-center portion of arena
	var wall_left: int = 8
	var wall_right: int = 16
	var wall_top: int = 2
	var wall_bottom: int = 10

	# --- WALLS ---
	# Top wall
	for x in range(wall_left, wall_right + 1):
		_place(layout, occupied, GameEnums.BuildingType.WALL_SEGMENT, Vector2i(x, wall_top))
	# Bottom wall
	for x in range(wall_left, wall_right + 1):
		_place(layout, occupied, GameEnums.BuildingType.WALL_SEGMENT, Vector2i(x, wall_bottom))
	# Left wall (with gate)
	var gate_y: int = randi_range(wall_top + 2, wall_bottom - 2)
	for y in range(wall_top + 1, wall_bottom):
		if y == gate_y:
			_place(layout, occupied, GameEnums.BuildingType.GATE, Vector2i(wall_left, y))
		else:
			_place(layout, occupied, GameEnums.BuildingType.WALL_SEGMENT, Vector2i(wall_left, y))
	# Right wall
	for y in range(wall_top + 1, wall_bottom):
		_place(layout, occupied, GameEnums.BuildingType.WALL_SEGMENT, Vector2i(wall_right, y))

	# Optional second gate on a different wall
	if randi_range(0, 1) == 1:
		var second_gate_x: int = randi_range(wall_left + 2, wall_right - 2)
		# Replace a bottom wall segment with a gate
		for p in layout.placements:
			if p.grid_pos == Vector2i(second_gate_x, wall_bottom) and \
			   p.building_type == GameEnums.BuildingType.WALL_SEGMENT:
				p.building_type = GameEnums.BuildingType.GATE
				break

	# --- KEY BUILDINGS (inside walls) ---
	var inner_min_x: int = wall_left + 1
	var inner_max_x: int = wall_right - 1
	var inner_min_y: int = wall_top + 1
	var inner_max_y: int = wall_bottom - 1

	# Center of village — place barracks or temple
	var center := Vector2i((inner_min_x + inner_max_x) / 2, (inner_min_y + inner_max_y) / 2)
	if not occupied.has(center):
		_place(layout, occupied, GameEnums.BuildingType.BARRACKS, center)

	# Temple near center
	var temple_pos := _find_open_pos_near(occupied, center, inner_min_x, inner_max_x, inner_min_y, inner_max_y)
	if temple_pos != Vector2i(-1, -1):
		_place(layout, occupied, GameEnums.BuildingType.TEMPLE, temple_pos)

	# --- FILL BUILDINGS ---
	var target_count: int = randi_range(8, 15)
	var interior_count: int = 0
	for p in layout.placements:
		if p.building_type != GameEnums.BuildingType.WALL_SEGMENT and \
		   p.building_type != GameEnums.BuildingType.GATE:
			interior_count += 1

	var remaining: int = target_count - interior_count
	for i in remaining:
		var pos := _find_open_pos(occupied, inner_min_x, inner_max_x, inner_min_y, inner_max_y)
		if pos == Vector2i(-1, -1):
			break
		var fill_type: GameEnums.BuildingType = _pick_fill_type()
		_place(layout, occupied, fill_type, pos)

	return layout


## --- HELPER FUNCTIONS ---

func _place(layout: SettlementLayout, occupied: Dictionary,
		type: GameEnums.BuildingType, pos: Vector2i) -> void:
	var placement := BuildingPlacement.new(type, pos)
	layout.placements.append(placement)
	occupied[pos] = true


func _find_open_pos(occupied: Dictionary, min_x: int, max_x: int,
		min_y: int, max_y: int) -> Vector2i:
	## Find a random unoccupied grid position within bounds. Tries 30 times.
	for _attempt in 30:
		var pos := Vector2i(randi_range(min_x, max_x), randi_range(min_y, max_y))
		if not occupied.has(pos):
			return pos
	return Vector2i(-1, -1)


func _find_open_pos_near(occupied: Dictionary, center: Vector2i,
		min_x: int, max_x: int, min_y: int, max_y: int) -> Vector2i:
	## Find an open position adjacent to center.
	var offsets: Array[Vector2i] = [
		Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1),
	]
	offsets.shuffle()
	for offset in offsets:
		var pos: Vector2i = center + offset
		if pos.x >= min_x and pos.x <= max_x and pos.y >= min_y and pos.y <= max_y:
			if not occupied.has(pos):
				return pos
	return _find_open_pos(occupied, min_x, max_x, min_y, max_y)


func _pick_fill_type() -> GameEnums.BuildingType:
	return _pick_weighted([
		[GameEnums.BuildingType.HOUSE, FILL_WEIGHTS[GameEnums.BuildingType.HOUSE]],
		[GameEnums.BuildingType.MARKET, FILL_WEIGHTS[GameEnums.BuildingType.MARKET]],
		[GameEnums.BuildingType.GRANARY, FILL_WEIGHTS[GameEnums.BuildingType.GRANARY]],
	])


func _pick_weighted(options: Array) -> GameEnums.BuildingType:
	## options = [[BuildingType, weight], ...]. Returns weighted random pick.
	var total: int = 0
	for opt in options:
		total += opt[1]
	var roll: int = randi_range(1, total)
	var cumulative: int = 0
	for opt in options:
		cumulative += opt[1]
		if roll <= cumulative:
			return opt[0]
	return options[0][0]


## --- CONVENIENCE: Build into arena ---

static func build_settlement(arena: CombatArena, size: GameEnums.SettlementSize) -> void:
	## Generate a settlement layout and instantiate buildings into the arena.
	var generator := SettlementGenerator.new()
	var layout: SettlementLayout = generator.generate(size)

	for placement in layout.placements:
		var building := Building.new(placement.building_type)
		building.position = placement.world_pos
		arena.add_building(building)
