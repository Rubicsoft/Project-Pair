extends CharacterBody2D
class_name Player

@export_group("Player Movement")
@export_range(0.0, 1000.0, 0.1) var movement_speed := 300.0
@export_range(1.0, 20.0, 0.1) var movement_smoothness := 8.0
@export_range(0.0, 1000.0, 0.1) var jump_force := 400.0
@export_range(0.0, 1.0, 0.01) var gravity_strength := 1.0
@export_group("")
@export_range(0, 256, 1) var camera_edge := 50

@onready var cam_follow_pivot: Node2D = $CameraFreeTransform/CameraFollowPivot
@onready var camera: Camera2D = $CameraFreeTransform/CameraFollowPivot/Camera2D

var camera_follow := true
var direction := 0.0
var smoothed_direction := 0.0

func _enter_tree() -> void:
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

func _ready() -> void:
	EventBus.connect("kill_player", kill_self)
	
	cam_follow_pivot.global_position = global_position
	camera.global_position = global_position

func _process(delta: float) -> void:
	if camera_follow: cam_follow_pivot.global_position.y = global_position.y - camera_edge

func _physics_process(delta: float) -> void:
	# Movement handling
	direction = signf(Input.get_axis("move_left", "move_right"))
	smoothed_direction = lerpf(smoothed_direction, direction, delta * movement_smoothness)
	
	if direction:
		velocity.x = smoothed_direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	# Gravity calculation
	if not is_on_floor():
		velocity += get_gravity() * gravity_strength * delta
	
	# Jump mechanic
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force

	move_and_slide()


func kill_self() -> void:
	print("PLAYER MATI")
