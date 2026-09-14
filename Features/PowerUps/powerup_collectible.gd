extends Area2D

func _ready() -> void:
	connect("body_entered", func(body: Node2D) -> void:
		if not body is Player:
			return
		EventBus.emit_signal("add_powerup")
		queue_free()
	)
