extends Node

var player: Player

var score := 0
var update_score := true
var high_score := 0
var lava_slowmo := false
var powerup_timer := 0.0

func reset_global_vars() -> void:
	score = 0
	lava_slowmo = false
	powerup_timer = 0.0
