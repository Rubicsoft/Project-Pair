extends CanvasLayer

func _enter_tree() -> void: visible = not OS.has_feature("web")
