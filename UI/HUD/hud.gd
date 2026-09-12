extends CanvasLayer

var powerup_names: Array[String] = [
	"SHIELD",
	"EXTRA BOOST DURATION", 
	"LAVA SLOWMO"
]

var endgame_disappear: Array[NodePath] = [
	"$HUD_Box/Panel/PowerUp"
]

func _ready() -> void:
	EventBus.connect("kill_player", func(_unused_var: bool) -> void:
		$HUD_Box/Panel/ScoreCount.text = "High Score: " + str(Global.score)
		#for node in endgame_disappear: 
			#get_node(node).visible = false
		$HUD_Box/Panel/AnimationPlayer.play("endgame")
	)
	EventBus.connect("powerup_index", show_powerup)
	
	$HUD_Box/Panel/PowerUp.visible = false

func _process(_delta: float) -> void:
	if Global.update_score:
		$HUD_Box/Panel/ScoreCount.text = "Score: " + str(Global.score)
	
	$HUD_Box/Panel/PowerUp.visible = not $HUD_Box/Panel/PowerUp/Timer.is_stopped()


func show_powerup(index: int) -> void:
	$HUD_Box/Panel/PowerUp.text = "PowerUp: " + powerup_names.get(index)
	$HUD_Box/Panel/PowerUp/Timer.start()
