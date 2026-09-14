extends Area2D

@export var base_speed: float = 10.0        # speed awal / speed minimum saat reset
@export var max_speed: float = 100.0        # batas atas speed saat akselerasi
@export var acceleration: float = 30.0      # px/detik^2, nambah speed saat ngejar bebas
@export var deceleration: float = 200.0     # px/detik^2, turun speed saat mentok/tertinggal
@export var screen_margin: float = 5.0
@export var bottom_marker_path: NodePath

@export var immediate_kill := true          # lava selalu insta-kill, tidak tertahan god_mode
@export var slowmo_speed_multiplier: float = 0.4   # seberapa lambat lava saat powerup LAVA_SLOWMO aktif
@export var startup_duration: float = 8.0
@export var startup_speed: float = 2  # kecepatan lava selama fase awal (0 = diam dulu)

var _startup_timer: float = 0.0
var _startup_done: bool = false
var bottom_marker: Marker2D
var current_speed: float


func _ready() -> void:
	current_speed = base_speed
	bottom_marker = get_node(bottom_marker_path)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.emit_signal("kill_player", immediate_kill)


func _physics_process(delta: float) -> void:
	if not Global.game_start:
		return

	if bottom_marker == null:
		return

	var max_y := bottom_marker.global_position.y + screen_margin
	var is_clamped := global_position.y >= max_y

	# Fase startup: lava melambat dulu selama `startup_duration` detik
	# sebelum mulai logika akselerasi/deselerasi yang sebenarnya.
	if not _startup_done:
		_startup_timer += delta
		current_speed = move_toward(current_speed, startup_speed, acceleration * delta)
		if _startup_timer >= startup_duration:
			_startup_done = true
	elif not Global.lava_slowmo:
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
