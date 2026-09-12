extends Node2D
class_name ObstacleManager

@export var obstacle_pool: Array[ObstacleData] = []
@export var player_path: NodePath

@export var play_area_width: float = 390.0
@export var min_gap_width: float = 10.0
@export var obstacle_margin: float = 50.0
@export var segment_fill_chance: float = 1

@export var min_row_height: float = 1.0
@export var vertical_margin: float = 10.0
@export var extra_gap_min: float = 30.0
@export var extra_gap_max: float = 80.0

@export var spawn_ahead_distance: float = 1000.0
@export var despawn_behind_distance: float = 700.0

@export var debug_draw: bool = true   # aktifkan saat playtest, matikan lagi setelah selesai

var player: Node2D
var next_row_y: float
var active_obstacles: Array[Node2D] = []
var total_weight: float = 0.0
var row_max_height: float = 0.0
var debug_rows: Array = []


func _ready() -> void:
	player = get_node(player_path)
	next_row_y = player.global_position.y - spawn_ahead_distance

	for data in obstacle_pool:
		total_weight += data.weight


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	while next_row_y > player.global_position.y - spawn_ahead_distance:
		spawn_row()

	despawn_old_obstacles()


func spawn_row() -> void:
	row_max_height = min_row_height

	var half_width := play_area_width / 2.0
	var gap_half := randf_range(min_gap_width, min_gap_width * 1.4) / 2.0
	var gap_center := randf_range(-half_width + gap_half, half_width - gap_half)
	var gap_start := gap_center - gap_half
	var gap_end := gap_center + gap_half
	var row_y := next_row_y

	fill_segment(-half_width, gap_start)
	fill_segment(gap_end, half_width)

	if debug_draw:
		debug_rows.append({"y": row_y, "gap_start": gap_start, "gap_end": gap_end, "half_width": half_width})
		queue_redraw()

	var row_spacing := row_max_height + vertical_margin + randf_range(extra_gap_min, extra_gap_max)
	next_row_y -= row_spacing


func fill_segment(segment_start: float, segment_end: float) -> void:
	if obstacle_pool.is_empty() or randf() > segment_fill_chance:
		return

	var cursor := segment_start

	while true:
		var data := pick_weighted_obstacle()
		var obstacle_end := cursor + data.width

		if obstacle_end > segment_end:
			break

		spawn_obstacle(data, cursor + data.width / 2.0)
		cursor = obstacle_end + obstacle_margin


func spawn_obstacle(data: ObstacleData, x: float) -> void:
	var obstacle: Node2D = data.scene.instantiate()
	add_child(obstacle)
	obstacle.global_position = Vector2(x, next_row_y) - data.center_offset

	active_obstacles.append(obstacle)
	row_max_height = max(row_max_height, data.height)


func pick_weighted_obstacle() -> ObstacleData:
	var roll := randf() * total_weight
	var cumulative := 0.0

	for data in obstacle_pool:
		cumulative += data.weight
		if roll <= cumulative:
			return data

	return obstacle_pool.back()


func despawn_old_obstacles() -> void:
	for i in range(active_obstacles.size() - 1, -1, -1):
		var obstacle := active_obstacles[i]

		if not is_instance_valid(obstacle):
			active_obstacles.remove_at(i)
			continue

		if obstacle.global_position.y > player.global_position.y + despawn_behind_distance:
			obstacle.queue_free()
			active_obstacles.remove_at(i)

	if debug_draw:
		for i in range(debug_rows.size() - 1, -1, -1):
			if debug_rows[i]["y"] > player.global_position.y + despawn_behind_distance:
				debug_rows.remove_at(i)
		queue_redraw()


func _draw() -> void:
	if not debug_draw:
		return

	for row in debug_rows:
		var y: float = row["y"]
		var half_width: float = row["half_width"]
		var gap_start: float = row["gap_start"]
		var gap_end: float = row["gap_end"]

		# Area terisi (kuning)
		draw_line(Vector2(-half_width, y), Vector2(gap_start, y), Color.YELLOW, 3)
		draw_line(Vector2(gap_end, y), Vector2(half_width, y), Color.YELLOW, 3)

		# Batas celah wajib (merah)
		draw_line(Vector2(gap_start, y - 15), Vector2(gap_start, y + 15), Color.RED, 3)
		draw_line(Vector2(gap_end, y - 15), Vector2(gap_end, y + 15), Color.RED, 3)
