extends Area2D

@export var immideate_kill := false

func _ready() -> void:
	connect("body_entered", func(body: Node2D): EventBus.emit_signal("kill_player", immideate_kill))
