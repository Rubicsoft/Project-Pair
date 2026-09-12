extends Area2D

func _ready() -> void:
	connect("body_entered", func(body: Node2D): EventBus.emit_signal("kill_player"))
