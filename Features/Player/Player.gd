extends CharacterBody2D
class_name Player

@export_group("Player Movement")
@export_range(0.0, 1000.0, 0.1) var movement_speed := 300.0
@export_range(0.0, 1000.0, 0.1) var jump_force := 400.0
@export_range(0.0, 1.0, 0.01) var gravity_strength := 1.0
@export_group("")
@export_range(0, 256, 1) var camera_edge := 50

@onready var cam_follow_pivot: Node2D = $CameraFreeTransform/CameraFollowPivot
@onready var camera: Camera2D = $CameraFreeTransform/CameraFollowPivot/Camera2D

var last_ypos := 0.0
var current_ypos := 0.0
var camera_follow := true

func _enter_tree() -> void:
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

func _ready() -> void:
	EventBus.connect("kill_player", kill_self)
	
	cam_follow_pivot.global_position = global_position
	camera.global_position = global_position
	
	last_ypos = global_position.y

func _process(delta: float) -> void:
	if camera_follow: cam_follow_pivot.global_position.y = global_position.y - camera_edge
	
	if Global.update_score:
		current_ypos = global_position.y
		Global.score = last_ypos - current_ypos

func _physics_process(delta: float) -> void:
	# Movement handling
	var direction := signf(Input.get_axis("move_left", "move_right"))
	if direction:
		velocity.x = direction * movement_speed
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
