extends Area2D

@export_enum("Shield", "Long") var powerup_type: int

func _ready() -> void:
	connect("body_entered", func(_body: Node2D) -> void:
		EventBus.emit_signal("add_powerup")
		queue_free()
	)
