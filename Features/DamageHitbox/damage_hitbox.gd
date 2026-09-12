extends Area2D

func _ready() -> void:
	connect("body_entered", func(_body: Node2D) -> void:
		EventBus.emit_signal("kill_player")
	)
