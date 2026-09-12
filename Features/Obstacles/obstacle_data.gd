extends Resource
class_name ObstacleData

enum Type { STATIC, MOVING_PLATFORM, LAVA_BURST }

@export var scene: PackedScene
@export var width: float = 100.0
@export var height: float = 100.0
@export var center_offset: Vector2 = Vector2.ZERO
@export var weight: float = 1.0
@export var type: Type = Type.STATIC
