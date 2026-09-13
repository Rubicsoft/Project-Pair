extends AudioStreamPlayer

@export var buttons: Array[Button]

func _ready() -> void:
	for button in buttons:
		button.connect("pressed", play)
		button.connect("focus_entered", play)
		button.connect("hover_entered", play)
