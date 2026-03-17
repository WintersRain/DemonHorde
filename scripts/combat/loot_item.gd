## A physical loot item on the battlefield. Dropped by buildings/demons, collected on contact.
class_name LootItem
extends Node2D

signal collected(item: LootItem)

var loot_type: GameEnums.LootType = GameEnums.LootType.COIN
var value: int = 1
var picked_up: bool = false

## Visual constants per loot type
const LOOT_COLORS: Dictionary = {
	GameEnums.LootType.COIN: Color(1.0, 0.85, 0.2),    # Gold
	GameEnums.LootType.GEM: Color(0.6, 0.2, 0.9),      # Purple
	GameEnums.LootType.SUPPLY: Color(0.4, 0.7, 0.3),    # Green
	GameEnums.LootType.CAPTIVE: Color(0.9, 0.7, 0.6),   # Skin tone
}

const LOOT_LABELS: Dictionary = {
	GameEnums.LootType.COIN: "C",
	GameEnums.LootType.GEM: "G",
	GameEnums.LootType.SUPPLY: "S",
	GameEnums.LootType.CAPTIVE: "P",
}

const ITEM_RADIUS: float = 4.0


func _init(type: GameEnums.LootType = GameEnums.LootType.COIN, val: int = 1) -> void:
	loot_type = type
	value = val


func _draw() -> void:
	if picked_up:
		return
	var color: Color = LOOT_COLORS.get(loot_type, Color.WHITE)
	draw_circle(Vector2.ZERO, ITEM_RADIUS, color)
	draw_arc(Vector2.ZERO, ITEM_RADIUS, 0, TAU, 16, color.darkened(0.3), 1.0)


func collect() -> void:
	if picked_up:
		return
	picked_up = true
	collected.emit(self)
	queue_redraw()


static func scatter_items(items: Array[LootItem], center: Vector2, radius: float) -> void:
	## Distribute loot items in a circle around a center point.
	for item in items:
		var angle: float = randf() * TAU
		var dist: float = randf() * radius
		item.position = center + Vector2(cos(angle), sin(angle)) * dist


static func create_loot(type: GameEnums.LootType, val: int, pos: Vector2) -> LootItem:
	var item := LootItem.new(type, val)
	item.position = pos
	return item
