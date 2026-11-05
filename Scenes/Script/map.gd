class_name Minimap
extends Panel

## The node the map is centered on. Drag your Player here in the Inspector.
@export var player: Node2D

## How much the world is shrunk. 0.1 means 10 world pixels become 1 map pixel.
@export_range(0.01, 1.0, 0.01) var map_scale := 0.1

## For side-scrollers, map Y much less than X so the minimap stays readable.
@export_range(0.0, 1.0, 0.01) var vertical_scale := 0.25

## Radius of each dot, in pixels.
@export var dot_size := 3.0

## If true, treat this as a side-scroller minimap.
@export var side_scroller_mode := true

@export_group("Colors")
@export var background_color := Color(0, 0, 0, 0.6)
@export var border_color := Color(1, 1, 1, 0.8)
@export var player_color := Color.WHITE
@export var monster_color := Color.RED
@export var coin_color := Color.GOLD

func _ready() -> void:
	clip_contents = true

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var map_rect := Rect2(Vector2.ZERO, size)
	draw_rect(map_rect, background_color)

	if player != null:
		_draw_group("Coin", coin_color)
		_draw_group("Enemy", monster_color)

		# Player stays in the center of the minimap.
		draw_circle(size / 2, dot_size + 1.0, player_color)

	# Border on top so it sits above everything.
	draw_rect(map_rect, border_color, false, 2.0)

func _draw_group(group_name: String, color: Color) -> void:
	var map_rect := Rect2(Vector2.ZERO, size)

	for node in get_tree().get_nodes_in_group(group_name):
		if not node is Node2D:
			continue

		var map_pos := _world_to_map(node.global_position)
		if map_rect.has_point(map_pos):
			draw_circle(map_pos, dot_size, color)

func _world_to_map(world_pos: Vector2) -> Vector2:
	var rel := world_pos - player.global_position

	var x := rel.x * map_scale + size.x * 0.5
	var y_scale := map_scale

	if side_scroller_mode:
		y_scale = map_scale * vertical_scale

	var y := rel.y * y_scale + size.y * 0.5

	return Vector2(x, y)
