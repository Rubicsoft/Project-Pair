extends Node2D
class_name LavaBurstManager

@export var hazard_scene: PackedScene
@export var player_path: NodePath

@export var play_area_width: float = 390.0
@export var min_spawn_interval: float = 2.0
@export var max_spawn_interval: float = 5.0

@export var vertical_spawn_offset_min: float = 300.0   # jarak minimal di atas player saat spawn
@export var vertical_spawn_offset_max: float = 600.0   # jarak maksimal di atas player saat spawn

var player: Node2D
var time_until_next_spawn: float = 0.0


func _ready() -> void:
	player = get_node(player_path)
	_reset_timer()


func _process(delta: float) -> void:
	if player == null:
		return

	time_until_next_spawn -= delta
	if time_until_next_spawn <= 0.0:
		_spawn_hazard()
		_reset_timer()


func _reset_timer() -> void:
	time_until_next_spawn = randf_range(min_spawn_interval, max_spawn_interval)


func _spawn_hazard() -> void:
	if hazard_scene == null:
		return

	var half_width := play_area_width / 2.0
	var wall_side := 1.0 if randf() < 0.5 else -1.0   # 1 = kanan, -1 = kiri
	var spawn_x := half_width * wall_side
	var spawn_y := player.global_position.y - randf_range(vertical_spawn_offset_min, vertical_spawn_offset_max)

	var hazard: Node2D = hazard_scene.instantiate()
	hazard.position = Vector2(spawn_x, spawn_y)
	hazard.scale.x = wall_side   # balik visual/collision otomatis kalau spawn di kiri

	add_child(hazard)
