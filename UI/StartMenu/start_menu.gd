extends CanvasLayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$PanelContainer/VBoxContainer/StartButton.grab_focus()
	
	$PanelContainer/Credits.visible = false
	$PanelContainer/VBoxContainer/CreditsButton.connect("pressed", func() -> void: 
		$PanelContainer/Credits.visible = true
		$PanelContainer/VBoxContainer/CreditsButton.visible = false
		$PanelContainer/VBoxContainer/StartButton.grab_focus()
	)
	$PanelContainer/VBoxContainer/QuitButton.connect("pressed", func() -> void: get_tree().quit())
	$PanelContainer/VBoxContainer/QuitButton.visible = not OS.has_feature("web")
	
	$PanelContainer/VBoxContainer/HighScore.text = "High Score: " + str(Global.high_score) + "\n"
	#$PanelContainer/VBoxContainer/HighScore.visible = Global.high_score > 0
