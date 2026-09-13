extends CanvasLayer

func _ready() -> void:
	Global.game_start = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$PanelContainer/VBoxContainer/StartButton.grab_focus()
	
	$PanelContainer/Credits.visible = false
	$PanelContainer/Credits_2.visible = false
	$PanelContainer/VBoxContainer/CreditsButton.connect("pressed", func() -> void: 
		$PanelContainer/Credits.visible = true
		$PanelContainer/Credits_2.visible = true
		$PanelContainer/VBoxContainer/CreditsButton.visible = false
		$PanelContainer/VBoxContainer/StartButton.grab_focus()
	)
	$PanelContainer/VBoxContainer/QuitButton.connect("pressed", func() -> void: get_tree().quit())
	$PanelContainer/VBoxContainer/QuitButton.visible = not OS.has_feature("web")
	
	$PanelContainer/VBoxContainer/StartButton.connect("pressed", func() -> void:
		Global.game_start = true
		visible = false
	)
	
	$PanelContainer/VBoxContainer/HighScore.text = "High Score: " + str(Global.high_score) + "\n"
	$PanelContainer/VBoxContainer/HighScore.visible = Global.high_score > 0
	
	$FadeIn.visible = true
	create_tween().tween_property($FadeIn, "self_modulate", Color.TRANSPARENT, 0.5)
