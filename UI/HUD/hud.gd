extends CanvasLayer

var powerup_names: Array[String] = [
	"SHIELD",
	"EXTRA BOOST DURATION", 
	"LAVA SLOWMO"
]

func _ready() -> void:
	EventBus.connect("kill_player", func(_unused_var: bool) -> void:
		$HUD_Box/Panel/ScoreCount.text = "High Score: " + str(Global.score)
		$HUD_Box/Panel_2.visible = false
		$HUD_Box/Panel/AnimationPlayer.play("endgame")
	)
	EventBus.connect("powerup_index", show_powerup)
	$HUD_Box/Panel_2/PowerUp.visible = false

func _process(_delta: float) -> void:
	if Global.update_score:
		$HUD_Box/Panel/ScoreCount.text = "Score: " + str(Global.score)
	
	$HUD_Box/Panel_2/PowerUp.visible = not $HUD_Box/Panel_2/PowerUp/Timer.is_stopped()
	$HUD_Box/Panel_2/PowerUpDuration.value = Global.powerup_timer
	$HUD_Box/Panel_2/PowerUpDuration.visible = $HUD_Box/Panel_2/PowerUpDuration.value < 10.0


func show_powerup(index: int) -> void:
	$HUD_Box/Panel_2/PowerUp.text = "PowerUp: " + powerup_names.get(index)
	$HUD_Box/Panel_2/PowerUp/Timer.start()
