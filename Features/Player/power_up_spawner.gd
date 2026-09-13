extends Node2D
class_name PowerupSpawner

@export var powerup_scenes: Array[PackedScene] = []
@export var player_path: NodePath
@export var obstacle_manager_path: NodePath

@export var play_area_width: float = 390.0
@export var spawn_ahead_offset: float = 500.0
@export var overlap_padding: float = 30.0        # jarak aman tambahan dari tepi obstacle
@export var powerup_footprint: Vector2 = Vector2(60.0, 60.0)   # perkiraan ukuran collision powerup

@export var min_spawn_interval: float = 4.0
@export var max_spawn_interval: float = 8.0
@export var max_placement_attempts: int = 8

var player: Node2D
var obstacle_manager: ObstacleManager
var time_until_next_spawn: float = 0.0


func _ready() -> void:
	player = get_node(player_path)
	obstacle_manager = get_node(obstacle_manager_path)
	_reset_timer()


func _process(delta: float) -> void:
	if player == null:
		return

	time_until_next_spawn -= delta
	if time_until_next_spawn <= 0.0:
		_try_spawn_powerup()
		_reset_timer()


func _reset_timer() -> void:
	time_until_next_spawn = randf_range(min_spawn_interval, max_spawn_interval)


func _try_spawn_powerup() -> void:
	if powerup_scenes.is_empty():
		return

	var half_width := play_area_width / 2.0
	var spawn_y := player.global_position.y - spawn_ahead_offset

	for attempt in max_placement_attempts:
		var spawn_pos := Vector2(randf_range(-half_width, half_width), spawn_y)

		if not _overlaps_obstacle(spawn_pos):
			_spawn_powerup(spawn_pos)
			return
	# Kalau semua percobaan ketutup obstacle terus, lewati spawn kali ini -> dicoba lagi interval berikutnya


func _overlaps_obstacle(pos: Vector2) -> bool:
	if obstacle_manager == null:
		return false

	var powerup_rect := Rect2(pos - powerup_footprint / 2.0, powerup_footprint)

	for rect in obstacle_manager.get_active_rects():
		if rect.grow(overlap_padding).intersects(powerup_rect):
			return true

	return false


func _spawn_powerup(pos: Vector2) -> void:
	var scene: PackedScene = powerup_scenes[randi() % powerup_scenes.size()]
	var powerup: Node2D = scene.instantiate()
	powerup.position = pos
	add_child(powerup)
