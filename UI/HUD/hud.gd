extends CanvasLayer

func _process(_delta: float) -> void:
	$HUD_Box/ScoreCount.text = "Score: " + str(Global.score)
