extends Node2D

## Platform target position
@export var target_position: Node2D
@export_range(0.0, 15.0, 0.1) var duration: float = 2.0
@export_range(0.0, 5.0, 0.1) var delay_time: float = 0.0

var start_pos: Vector2
var tween: Tween

func _ready() -> void:
	start_pos = global_position
	if not target_position: return
	
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	
	tween.tween_interval(delay_time)
	
	tween.tween_interval(delay_time)
	tween.tween_property($MovingPlatformBody, "global_position", target_position.global_position, calculate_duration())
	
	tween.tween_interval(delay_time)
	tween.tween_property($MovingPlatformBody, "global_position", global_position, calculate_duration())


func calculate_duration() -> float:
	return duration / 2.0 - delay_time
