extends Node2D

@export var lava_speed: float = 80.0
@export var screen_margin: float = 40.0 
@export var bottom_marker_path: NodePath

var bottom_marker: Marker2D

func _ready() -> void:
	bottom_marker = get_node(bottom_marker_path)

func _physics_process(delta: float) -> void:
	if bottom_marker == null:
		return

	# Lava selalu naik (Y makin kecil = makin ke atas)
	global_position.y -= lava_speed * delta

	# Batas maksimal: lava tidak boleh lebih tinggi dari tepi bawah kamera + margin
	var max_y := bottom_marker.global_position.y + screen_margin
	if global_position.y > max_y:
		global_position.y = max_y
