extends Node2D
class_name ObstacleManager

@export var obstacle_scenes: Array[PackedScene] = []
@export var player_path: NodePath

# Posisi X yang bisa ditempati obstacle (kolom/lane)
@export var lane_x_positions: Array[float] = [-200.0, -100.0, 0.0, 100.0, 200.0]
# Jumlah lane kosong wajib di antara 2 obstacle sebaris (menjamin ada celah lewat)
@export var min_lane_gap: int = 0

@export var row_spacing_min: float = 180.0
@export var row_spacing_max: float = 280.0
# Peluang jumlah obstacle per baris, key = jumlah, value = peluang (total harus 1.0)
@export var obstacles_per_row_chance: Dictionary = {1: 0.7, 2: 0.3}

@export var spawn_ahead_distance: float = 1000.0
@export var despawn_behind_distance: float = 700.0
@export var avoid_repeat: bool = true

var player: Node2D
var next_row_y: float
var last_scene_index: int = -1
var active_obstacles: Array[Node2D] = []


func _ready() -> void:
	player = get_node(player_path)
	next_row_y = player.global_position.y - spawn_ahead_distance


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	while next_row_y > player.global_position.y - spawn_ahead_distance:
		spawn_row()

	despawn_old_obstacles()


func spawn_row() -> void:
	var obstacle_count := pick_obstacle_count()
	var lane_indices := pick_lane_indices(obstacle_count)

	for lane_index in lane_indices:
		var scene := pick_scene()
		if scene == null:
			continue

		var obstacle: Node2D = scene.instantiate()
		add_child(obstacle)
		obstacle.global_position = Vector2(lane_x_positions[lane_index], next_row_y)
		active_obstacles.append(obstacle)

	next_row_y -= randf_range(row_spacing_min, row_spacing_max)


func pick_obstacle_count() -> int:
	var roll := randf()
	var cumulative := 0.0

	for count: int in obstacles_per_row_chance:
		cumulative += obstacles_per_row_chance[count]
		if roll <= cumulative:
			return count

	return 1


func pick_lane_indices(count: int) -> Array[int]:
	var available: Array[int] = []
	for i in lane_x_positions.size():
		available.append(i)

	var chosen: Array[int] = []

	while chosen.size() < count and not available.is_empty():
		var lane: int = available[randi() % available.size()]
		chosen.append(lane)
		available = available.filter(func(l: int) -> bool: return absi(l - lane) > min_lane_gap)

	return chosen


func pick_scene() -> PackedScene:
	if obstacle_scenes.is_empty():
		return null

	var index := randi() % obstacle_scenes.size()

	if avoid_repeat and obstacle_scenes.size() > 1:
		while index == last_scene_index:
			index = randi() % obstacle_scenes.size()

	last_scene_index = index
	return obstacle_scenes[index]


func despawn_old_obstacles() -> void:
	for i in range(active_obstacles.size() - 1, -1, -1):
		var obstacle := active_obstacles[i]

		if not is_instance_valid(obstacle):
			active_obstacles.remove_at(i)
			continue

		if obstacle.global_position.y > player.global_position.y + despawn_behind_distance:
			obstacle.queue_free()
			active_obstacles.remove_at(i)
