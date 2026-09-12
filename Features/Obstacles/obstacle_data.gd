extends Resource
class_name ObstacleData

enum Type { STATIC, MOVING_PLATFORM, LAVA_BURST }

@export var scene: PackedScene
@export var width: float = 100.0       # lebar horizontal obstacle (ukur dari editor)
@export var weight: float = 1.0        # bobot peluang muncul
@export var type: Type = Type.STATIC
