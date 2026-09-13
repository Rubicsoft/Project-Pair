extends Node

@export var powerup_duration := 10.0

@onready var timer: Timer = $Timer
@onready var player: Player = $".."
@onready var sfx: AudioStreamPlayer2D = $SFX

enum PowerUpType {
	SHIELD, 
	BOOST_DURATION,
	LAVA_SLOWMO 
}
const POWERUP_COUNT = 3

var powerup_in_use := false
var power_up: PowerUpType


func _ready() -> void:
	EventBus.connect("add_powerup", activate_powerup)
	EventBus.connect("kill_player", func(_unused_var: bool) -> void: deactivate_powerup())
	timer.connect("timeout", deactivate_powerup)

func _process(_delta: float) -> void:
	if powerup_in_use and player:
		match power_up:
			PowerUpType.SHIELD: player.god_mode = true
			PowerUpType.BOOST_DURATION: player.extra_boost_duration = true
			PowerUpType.LAVA_SLOWMO: Global.lava_slowmo = true
	Global.powerup_timer = timer.time_left

func activate_powerup() -> void:
	sfx.play()
	powerup_in_use = true
	power_up = randi_range(0, POWERUP_COUNT - 1) as PowerUpType
	EventBus.emit_signal("powerup_index", power_up)
	timer.start(powerup_duration)
	print("ACTIVATE POWERUP: " + str(power_up))

func deactivate_powerup() -> void:
	timer.stop()
	powerup_in_use = false
	
	player.extra_boost_duration = false
	Global.lava_slowmo = false
	print("POWERUP DEACTIVATED")
	
	await get_tree().create_timer(0.1).timeout
	player.god_mode = false
