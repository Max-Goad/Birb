class_name MapBoundedFollowCamera extends Camera2D

### Variables
@export var bound: TileMap
@export var follow: Node2D
@export var following: bool = true

### Signals

### Engine Functions
func _ready() -> void:
	var limit: Rect2 = bound.get_used_rect()
	self.limit_left = int(limit.position.x * bound.cell_quadrant_size * bound.scale.x)
	self.limit_top = int(limit.position.y * bound.cell_quadrant_size * bound.scale.y)
	self.limit_right = int(limit.end.x * bound.cell_quadrant_size * bound.scale.x)
	self.limit_bottom = int(limit.end.y * bound.cell_quadrant_size * bound.scale.y)

func _process(_delta: float) -> void:
	if following:
		get_viewport().get_camera_2d().position = follow.position

### Public Functions

### Private Functions

