extends Node2D
class_name LavaBurstHazard

@export var warning_duration: float = 1.5   # durasi warning tampil, independen dari panjang animasinya

@onready var warning_icon: AnimatedSprite2D = $Warning
@onready var lava_visual: AnimatedSprite2D = $LavaVisual
@onready var Colision: CollisionShape2D = $DamageHitbox/LavaArea


func _ready() -> void:
	lava_visual.visible = false
	warning_icon.visible = true
	Colision.disabled = true 

	warning_icon.play()
	await get_tree().create_timer(warning_duration).timeout
	_start_burst()


func _start_burst() -> void:
	Colision.disabled = false
	warning_icon.visible = false
	lava_visual.visible = true

	lava_visual.play()
	await lava_visual.animation_finished
	queue_free()
