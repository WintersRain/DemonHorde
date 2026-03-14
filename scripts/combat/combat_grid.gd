## The tactical combat grid. Manages tile positions and squad placement.
class_name CombatGrid
extends Node2D

signal cell_clicked(grid_pos: Vector2i)
signal cell_hovered(grid_pos: Vector2i)

const CELL_SIZE := 64
const GRID_COLOR := Color(0.2, 0.2, 0.25, 0.5)
const GRID_LINE_COLOR := Color(0.4, 0.4, 0.5, 0.3)
const HIGHLIGHT_COLOR := Color(0.8, 0.8, 0.2, 0.3)
const MOVE_RANGE_COLOR := Color(0.2, 0.6, 0.9, 0.2)

var grid_width: int = 12
var grid_height: int = 8
var _hovered_cell := Vector2i(-1, -1)
var _highlighted_cells: Array[Vector2i] = []
var _move_range_cells: Array[Vector2i] = []

## Grid contents — maps Vector2i -> CombatSquad node
var _occupancy: Dictionary = {}


func _ready() -> void:
	pass


func _draw() -> void:
	# Draw grid background
	for x in grid_width:
		for y in grid_height:
			var rect := Rect2(Vector2(x, y) * CELL_SIZE, Vector2(CELL_SIZE, CELL_SIZE))
			draw_rect(rect, GRID_COLOR, true)
			draw_rect(rect, GRID_LINE_COLOR, false)

	# Draw move range
	for cell in _move_range_cells:
		var rect := Rect2(Vector2(cell) * CELL_SIZE, Vector2(CELL_SIZE, CELL_SIZE))
		draw_rect(rect, MOVE_RANGE_COLOR, true)

	# Draw highlighted cells
	for cell in _highlighted_cells:
		var rect := Rect2(Vector2(cell) * CELL_SIZE, Vector2(CELL_SIZE, CELL_SIZE))
		draw_rect(rect, HIGHLIGHT_COLOR, true)

	# Draw hover
	if _hovered_cell != Vector2i(-1, -1) and is_valid_cell(_hovered_cell):
		var rect := Rect2(Vector2(_hovered_cell) * CELL_SIZE, Vector2(CELL_SIZE, CELL_SIZE))
		draw_rect(rect, Color(1, 1, 1, 0.15), true)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var new_hover := world_to_grid(get_local_mouse_position())
		if new_hover != _hovered_cell:
			_hovered_cell = new_hover
			cell_hovered.emit(_hovered_cell)
			queue_redraw()

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var click_pos := world_to_grid(get_local_mouse_position())
			if is_valid_cell(click_pos):
				cell_clicked.emit(click_pos)


func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(world_pos.x / CELL_SIZE),
		int(world_pos.y / CELL_SIZE)
	)


func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos) * CELL_SIZE + Vector2(CELL_SIZE / 2.0, CELL_SIZE / 2.0)


func is_valid_cell(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < grid_width and pos.y >= 0 and pos.y < grid_height


func is_occupied(pos: Vector2i) -> bool:
	return _occupancy.has(pos)


func get_squad_at(pos: Vector2i):
	return _occupancy.get(pos)


func place_squad(squad, pos: Vector2i) -> void:
	_occupancy[pos] = squad
	squad.grid_pos = pos
	squad.position = grid_to_world(pos)


func move_squad(squad, from: Vector2i, to: Vector2i) -> void:
	_occupancy.erase(from)
	_occupancy[to] = squad
	squad.grid_pos = to
	squad.position = grid_to_world(to)


func remove_squad(pos: Vector2i) -> void:
	_occupancy.erase(pos)


func set_highlighted_cells(cells: Array[Vector2i]) -> void:
	_highlighted_cells = cells
	queue_redraw()


func set_move_range(cells: Array[Vector2i]) -> void:
	_move_range_cells = cells
	queue_redraw()


func clear_highlights() -> void:
	_highlighted_cells.clear()
	_move_range_cells.clear()
	queue_redraw()


func get_cells_in_range(origin: Vector2i, range_val: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(-range_val, range_val + 1):
		for y in range(-range_val, range_val + 1):
			var pos := origin + Vector2i(x, y)
			if pos == origin:
				continue
			if abs(x) + abs(y) <= range_val and is_valid_cell(pos):
				cells.append(pos)
	return cells


func get_move_cells(origin: Vector2i, speed: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in get_cells_in_range(origin, speed):
		if not is_occupied(cell):
			cells.append(cell)
	return cells


func get_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)


func get_pixel_size() -> Vector2:
	return Vector2(grid_width * CELL_SIZE, grid_height * CELL_SIZE)
