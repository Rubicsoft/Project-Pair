extends Node2D

@onready var area_in: Area2D = $AreaIn
@onready var area_out: Area2D = $AreaOut

@export var holepit_height :float = 380

var has_spawned :bool = false
var is_deleting :bool = false

#membuat warning saat duplicate tapi masih butuh takut tidak connect
#func _ready() -> void:
	#$AreaIn.body_entered.connect(_on_area_in_body_entered)
	#$AreaOut.body_entered.connect(_on_area_out_body_entered)

func spawn_next_holepit() -> void:
	var next_holepit :Object = duplicate()  
	next_holepit.position.y -= holepit_height
	
	get_parent().add_child(next_holepit)


#Daerah fungsi Signal untuk AREA2D
func _on_area_in_body_entered(body: Node2D) -> void:
	print("body masuk")
	if body.name != "Player" :
		return
	if has_spawned :
		return
		
	has_spawned = true
	call_deferred("spawn_next_holepit")   

func _on_area_out_area_entered(area: Area2D) -> void:
	print("lava masuk")
	if area.name != "Lava" :
		return
		
	await get_tree().create_timer(1).timeout
	queue_free()
