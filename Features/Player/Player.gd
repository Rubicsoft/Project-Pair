extends CharacterBody2D
class_name Player

@export_group("Player Movement")
@export_range(0.0, 1000.0, 0.1) var movement_speed := 200.0
@export_range(0.0, 1.0, 0.01) var gravity_strength := 1.0
@export_range(0.0, 1000.0, 0.1) var upward_force := 400.0
@export_range(0.0, 10.0, 0.1) var upward_burst_duration := 0.5
@export_range(1.0, 20.0, 0.1) var movement_smooth_vector := 4.0
@export_group("Visual")
@export_range(0, 256, 1) var camera_edge := 50
@export_group("PowerUps")
@export var god_mode := false
@export var extra_boost_duration := false
@export var lava_slowmo := false

@onready var cam_follow_pivot: Node2D = $CameraFreeTransform/CameraFollowPivot
@onready var camera: Camera2D = $CameraFreeTransform/CameraFollowPivot/Camera2D
@onready var animplayer: AnimatedSprite2D = $AnimatedSprite2D

var last_ypos := 0.0
var current_ypos := 0.0
var camera_follow := true
var upward_cooldown := 0.0
var direction := 0.0
var movable := true
var last_direction := 0.0
var smoothed_direction := 0.0
var _upward_force := 0.0
var playing_animsheet := false


func _enter_tree() -> void: Global.player = self
func _exit_tree() -> void: Global.player = null

func _ready() -> void:
	EventBus.connect("kill_player", kill_self)
	
	cam_follow_pivot.global_position = global_position
	#camera.global_position = global_position
	
	last_ypos = global_position.y
	upward_cooldown = upward_burst_duration

func _process(_delta: float) -> void:
	if camera_follow: cam_follow_pivot.global_position.y = global_position.y - camera_edge
	
	animplayer.flip_h = last_direction > 0.0
	
	if Global.update_score:
		current_ypos = global_position.y
		Global.score = int(last_ypos - current_ypos)
		Global.score = maxi(Global.score, 0)
	
	# POWER UPS
	$PowerUps/Shield/Sprite2D.visible = god_mode
	
	# ANIMATION
	if not playing_animsheet:
		animplayer.play("idle")
	playing_animsheet = false
	
	if Input.is_action_pressed("ui_accept") and upward_cooldown > 0.0 and movable:
		animplayer.play("boost")
		playing_animsheet = true

func _physics_process(delta: float) -> void:
	# Movement handling
	direction = signf(Input.get_axis("move_left", "move_right"))
	smoothed_direction = lerpf(smoothed_direction, direction, delta * movement_smooth_vector)
	if direction and movable:
		last_direction = direction
		if is_on_floor():
			velocity.x = direction * movement_speed
		else:
			velocity.x = smoothed_direction * movement_speed
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, movement_speed)
		else:
			velocity.x = move_toward(velocity.x, 0, delta * movement_speed)
	
	# Gravity calculation
	if not is_on_floor():
		velocity += get_gravity() * gravity_strength * delta

	# Upward burst mechanic
	if is_on_ceiling() or is_on_floor():
		_upward_force = 0.0
	if Input.is_action_pressed("ui_accept") and movable:
		upward_cooldown -= delta
		if upward_cooldown > 0.0:
			_upward_force += upward_force * delta
			velocity.y = -(_upward_force)
	else:
		_upward_force = 0.0
		upward_cooldown = upward_burst_duration * 1.5 if extra_boost_duration else upward_burst_duration

	move_and_slide()


func kill_self(immideate_kill: bool) -> void:
	if god_mode and not immideate_kill: return
	
	movable = false
	velocity.x = move_toward(velocity.x, 0, movement_speed * get_physics_process_delta_time() * 4.0)
	camera_follow = false
	Global.update_score = false
	$CollisionShape2D.disabled = true
	animplayer.flip_v = true
	
	print("PLAYER MATI")
