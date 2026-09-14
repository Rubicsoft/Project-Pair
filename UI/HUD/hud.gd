extends CanvasLayer

var powerup_names: Array[String] = [
	"SHIELD",
	"EXTRA BOOST DURATION", 
	"LAVA SLOWMO"
]
var restartable := false
var powerup_rows: Dictionary = {}

func _ready() -> void:
	EventBus.connect("player_died", func() -> void:
		$HUD_Box/Panel/ScoreCount.text = "Score: " + str(Global.score) + "\nHigh Score: " + str(Global.high_score)
		$HUD_Box/Panel_2.visible = false
		restartable = true
		$HUD_Box/Panel/AnimationPlayer.play("endgame")
	)
	EventBus.connect("powerup_index", show_powerup)
	EventBus.connect("powerup_status_changed", update_powerups)
	$HUD_Box/Panel_2/PowerUp.visible = false
	$HUD_Box/Panel_2/PowerUpDuration.visible = false
	_create_powerup_list()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart") and restartable:
		get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	if Global.update_score:
		$HUD_Box/Panel/ScoreCount.text = "Score: " + str(Global.score)
	
	$HUD_Box/Panel/RestartLabel.visible = restartable


func show_powerup(index: int) -> void:
	return


func _create_powerup_list() -> void:
	var list := VBoxContainer.new()
	list.name = "PowerUpList"
	list.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	list.position = Vector2(16.0, -112.0)
	list.size = Vector2(210.0, 100.0)
	list.add_theme_constant_override("separation", 3)
	$HUD_Box/Panel_2.add_child(list)


func update_powerups(status: Dictionary) -> void:
	var list: VBoxContainer = $HUD_Box/Panel_2/PowerUpList
	for powerup_type in powerup_rows.keys():
		if not status.has(powerup_type):
			powerup_rows[powerup_type].queue_free()
			powerup_rows.erase(powerup_type)

	for powerup_type in status.keys():
		var row: HBoxContainer
		if not powerup_rows.has(powerup_type):
			row = HBoxContainer.new()
			var label := Label.new()
			label.custom_minimum_size.x = 145.0
			label.add_theme_font_size_override("font_size", 14)
			row.add_child(label)
			var bar := ProgressBar.new()
			bar.custom_minimum_size = Vector2(55.0, 15.0)
			bar.max_value = 10.0
			bar.show_percentage = false
			row.add_child(bar)
			list.add_child(row)
			powerup_rows[powerup_type] = row
		else:
			row = powerup_rows[powerup_type]

		row.get_child(0).text = powerup_names[powerup_type]
		row.get_child(1).value = status[powerup_type]
