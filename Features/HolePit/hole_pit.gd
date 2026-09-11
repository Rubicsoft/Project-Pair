extends Node2D

@onready var area_in: Area2D = $AreaIn
@onready var area_out: Area2D = $AreaOut

@export var holepit_height :float = 380

var has_spawned : bool = false

func _ready() -> void:
	$AreaIn.body_entered.connect(_on_area_in_body_entered)
	$AreaOut.body_entered.connect(_on_area_out_body_entered)


func spawn_next_holepit() -> void:
	var next_holepit :Object = duplicate()
	
	next_holepit.position.y -= holepit_height
	
	get_parent().add_child(next_holepit)


#Daerah fungsi Signal untuk AREA2D
func _on_area_in_body_entered(body: Node2D) -> void:
	print("test")
	if body.name != "Player" :
		return
	if has_spawned :
		return
		
	has_spawned = true
	spawn_next_holepit()

func _on_area_out_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	await get_tree().create_timer(1).timeout
	queue_free()
