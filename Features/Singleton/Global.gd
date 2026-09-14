extends Node

var player: Player

const HIGH_SCORE_PATH := "user://high_score.cfg"

var game_start := true
var score := 0
var update_score := true
var high_score := 0
var lava_slowmo := false
var powerup_timer := 0.0

func _ready() -> void:
	load_high_score()

func load_high_score() -> void:
	var config := ConfigFile.new()
	if config.load(HIGH_SCORE_PATH) == OK:
		high_score = int(config.get_value("score", "high_score", 0))

func save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value("score", "high_score", high_score)
	config.save(HIGH_SCORE_PATH)

func reset_global_vars() -> void:
	game_start = false
	score = 0
	lava_slowmo = false
	powerup_timer = 0.0
	update_score = true
	
