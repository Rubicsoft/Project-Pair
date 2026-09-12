extends Area2D

@export var base_speed: float = 10.0        # speed awal / speed minimum saat reset
@export var max_speed: float = 400.0        # batas atas speed saat akselerasi
@export var acceleration: float = 40.0      # px/detik^2, nambah speed saat ngejar bebas
@export var deceleration: float = 200.0     # px/detik^2, turun speed saat mentok/tertinggal
@export var screen_margin: float = 40.0
@export var bottom_marker_path: NodePath

var bottom_marker: Marker2D
var current_speed: float

func _ready() -> void:
	current_speed = base_speed
	bottom_marker = get_node(bottom_marker_path)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.emit_signal("kill_player")

func _physics_process(delta: float) -> void:
	if bottom_marker == null:
		return

	var max_y := bottom_marker.global_position.y + screen_margin
	var is_clamped := global_position.y >= max_y

	if is_clamped:
		# Lava Dekselerasi Ketinggalan
		current_speed = move_toward(current_speed, base_speed, deceleration * delta)
	else:
		# Lava akselerasi ngejar
		current_speed = move_toward(current_speed, max_speed, acceleration * delta)

	global_position.y -= current_speed * delta

	# Limit Jauh Lava dari player
	if global_position.y > max_y:
		global_position.y = max_y
