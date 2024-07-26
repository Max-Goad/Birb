class_name MapBoundedFollowCamera extends Camera2D

#region Variables
@export var bound: TileMap
@export var follow: Node2D
@export var following: bool = true

var _last_rotation = 0
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	var limit: Rect2 = bound.get_used_rect()
	self.limit_left = int(limit.position.x * bound.cell_quadrant_size * bound.scale.x)
	self.limit_top = int(limit.position.y * bound.cell_quadrant_size * bound.scale.y)
	self.limit_right = int(limit.end.x * bound.cell_quadrant_size * bound.scale.x)
	self.limit_bottom = int(limit.end.y * bound.cell_quadrant_size * bound.scale.y)
	_apply_limit_offsets()
	self.ignore_rotation = false
	self.add_to_group(Data.GROUP_CAMERA)

func _process(_delta: float) -> void:
	if following:
		var scene_camera = get_viewport().get_camera_2d()
		if _rotation_changed(scene_camera):
			_update_rotation(scene_camera)
			#scene_camera.rotation = rotation
		scene_camera.position = follow.position
#endregion

#region Public Functions
#endregion

#region Private Functions
func _apply_limit_offsets():
	self.limit_left += int(self.offset.x)
	self.limit_top -=  int(self.offset.y)
	self.limit_right += int(self.offset.x)
	self.limit_bottom -= int(self.offset.y)

func _remove_limit_offsets():
	self.limit_left -= int(self.offset.x)
	self.limit_top +=  int(self.offset.y)
	self.limit_right -= int(self.offset.x)
	self.limit_bottom += int(self.offset.y)

func _rotation_changed(camera):
	return rotation != _last_rotation

func _update_rotation(camera):
	_remove_limit_offsets()
	var old_limit_left = self.limit_left
	var old_limit_top = self.limit_top
	var old_limit_right = self.limit_right
	var old_limit_bottom = self.limit_bottom
	self.limit_left = old_limit_bottom
	self.limit_top = old_limit_left
	self.limit_right = old_limit_top
	self.limit_bottom = old_limit_right
	self.offset = self.offset.rotated(rotation)
	_apply_limit_offsets()
	# camera.rotation = rotation
	_last_rotation = rotation


#endregion

