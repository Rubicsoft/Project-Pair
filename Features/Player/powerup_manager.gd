extends Node

@export var powerup_duration := 10.0
@export var shield_break_invulnerability_duration := 2.0

@onready var player: Player = $".."
@onready var sfx: AudioStreamPlayer2D = $SFX

enum PowerUpType {
	SHIELD, 
	BOOST_DURATION,
	LAVA_SLOWMO 
}
const POWERUP_COUNT = 3

var active_powerups: Dictionary = {}
var shield_was_broken := false
var last_status: Dictionary = {}


func _ready() -> void:
	EventBus.connect("add_powerup", activate_powerup)

func _process(delta: float) -> void:
	for powerup_type in active_powerups.keys():
		active_powerups[powerup_type] -= delta
		if active_powerups[powerup_type] <= 0.0:
			active_powerups.erase(powerup_type)

	if player:
		player.god_mode = active_powerups.has(PowerUpType.SHIELD) and not shield_was_broken
		player.extra_boost_duration = active_powerups.has(PowerUpType.BOOST_DURATION)
	Global.lava_slowmo = active_powerups.has(PowerUpType.LAVA_SLOWMO)
	Global.powerup_timer = _get_longest_remaining_time()
	_emit_status_if_changed()

func activate_powerup() -> void:
	sfx.play()
	var powerup_type := randi_range(0, POWERUP_COUNT - 1) as PowerUpType
	active_powerups[powerup_type] = powerup_duration
	if powerup_type == PowerUpType.SHIELD:
		shield_was_broken = false
	_emit_status_if_changed()
	print("ACTIVATE POWERUP: " + str(powerup_type))

func break_shield() -> void:
	if not active_powerups.has(PowerUpType.SHIELD) or shield_was_broken:
		return
	active_powerups.erase(PowerUpType.SHIELD)
	shield_was_broken = true
	player.god_mode = false
	player.shield_invulnerability_time = shield_break_invulnerability_duration
	_emit_status_if_changed()

func _get_longest_remaining_time() -> float:
	var longest_time := 0.0
	for remaining_time in active_powerups.values():
		longest_time = maxf(longest_time, remaining_time)
	return longest_time

func _emit_status_if_changed() -> void:
	var status := active_powerups.duplicate()
	for powerup_type in status.keys():
		status[powerup_type] = ceili(status[powerup_type])
	if status != last_status:
		last_status = status
		EventBus.emit_signal("powerup_status_changed", active_powerups.duplicate())
