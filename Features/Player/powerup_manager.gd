extends Node

@export var powerup_duration := 10.0

@onready var timer: Timer = $Timer
@onready var player: Player = $".."

enum PowerUpType {
	SHIELD, 
	LAVA_SLOWMO, 
	TIMER_EXTEND
}

var powerup_in_use := false


func _ready() -> void:
	EventBus.connect("add_powerup", activate_powerup)
	EventBus.connect("kill_player", deactivate_powerup)

func activate_powerup() -> void:
	print("ACTIVATE POWERUP")
	player.god_mode = true

func deactivate_powerup() -> void:
	player.god_mode = false
