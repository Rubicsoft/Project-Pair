extends Area2D

@export var base_speed: float = 10.0        # speed awal / speed minimum saat reset
@export var max_speed: float = 100.0        # batas atas speed saat akselerasi
@export var acceleration: float = 50.0      # px/detik^2, nambah speed saat ngejar bebas
@export var deceleration: float = 200.0     # px/detik^2, turun speed saat mentok/tertinggal
@export var screen_margin: float = 3.0
@export var bottom_marker_path: NodePath

@export var immediate_kill := true          # lava selalu insta-kill, tidak tertahan god_mode
@export var slowmo_speed_multiplier: float = 0.4   # seberapa lambat lava saat powerup LAVA_SLOWMO aktif
@onready var sfx: AudioStreamPlayer2D = $SFX

var bottom_marker: Marker2D
var current_speed: float


func _ready() -> void:
	current_speed = base_speed
	bottom_marker = get_node(bottom_marker_path)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.emit_signal("kill_player", immediate_kill)
		sfx.play()


func _physics_process(delta: float) -> void:
	if bottom_marker == null:
		return

	var max_y := bottom_marker.global_position.y + screen_margin
	var is_clamped := global_position.y >= max_y

	# Saat slowmo aktif, akselerasi/deselerasi DIBEKUKAN dulu -> current_speed tidak
	# terus menumpuk selama powerup aktif, jadi begitu powerup habis, lava tidak
	# "meledak" mendadak ke speed tinggi yang sempat terbangun diam-diam.
	if not Global.lava_slowmo:
		if is_clamped:
			current_speed = move_toward(current_speed, base_speed, deceleration * delta)
		else:
			current_speed = move_toward(current_speed, max_speed, acceleration * delta)

	var effective_speed := current_speed
	if Global.lava_slowmo:
		effective_speed *= slowmo_speed_multiplier

	global_position.y -= effective_speed * delta

	if global_position.y > max_y:
		global_position.y = max_y
