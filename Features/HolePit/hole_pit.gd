extends Node2D

@onready var area_in: Area2D = $AreaIn
@onready var area_out: Area2D = $AreaOut

@export var holepit_height :float = 380

var has_spawned : bool = false

func _ready() -> void:
	$AreaIn.body_entered.connect(_on_area_in_body_entered)

func _process(delta: float) -> void:
	pass

func spawn_next_holepit():
	var next_holepit = duplicate()
	
	next_holepit.position.y -= holepit_height
	
	get_parent().add_child(next_holepit)

func _on_area_in_body_entered(body: Node2D) -> void:
	print("test")
	if body.name != "Player" :
		return
	if has_spawned :
		return
		
	has_spawned = true
	spawn_next_holepit()
