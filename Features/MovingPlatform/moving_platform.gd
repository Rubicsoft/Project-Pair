extends Node2D
class_name MovingPlatform

@export var min_offset_distance: float = 50.0
@export var max_offset_distance: float = 150.0
@export var move_horizontal: bool = true   # true = kiri-kanan, false = atas-bawah
@export_range(0.0, 15.0, 0.1) var duration: float = 3.0
@export_range(0.0, 5.0, 0.1) var delay_time: float = 0.0

var start_pos: Vector2
var target_pos: Vector2
var tween: Tween


func _ready() -> void:
	start_pos = $MovingPlatformBody.global_position

	var distance := randf_range(min_offset_distance, max_offset_distance)
	var direction := 1.0 if randf() < 0.5 else -1.0
	var movement_offset := Vector2(distance * direction, 0.0) if move_horizontal else Vector2(0.0, distance * direction)

	target_pos = start_pos + movement_offset

	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()

	tween.tween_interval(delay_time)
	tween.tween_property($MovingPlatformBody, "global_position", target_pos, calculate_duration())

	tween.tween_interval(delay_time)
	tween.tween_property($MovingPlatformBody, "global_position", start_pos, calculate_duration())


func calculate_duration() -> float:
	return duration / 2.0 - delay_time
