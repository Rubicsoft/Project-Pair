extends CanvasLayer

func _ready() -> void:
	EventBus.connect("kill_player", func(_unused_var: bool) -> void:
		$HUD_Box/Panel/ScoreCount.text = "High Score: " + str(Global.score)
		$HUD_Box/Panel/AnimationPlayer.play("endgame")
	)

func _process(_delta: float) -> void:
	if Global.update_score:
		$HUD_Box/Panel/ScoreCount.text = "Score: " + str(Global.score)
