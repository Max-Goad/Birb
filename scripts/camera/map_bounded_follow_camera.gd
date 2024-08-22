class_name MapBoundedFollowCamera extends Camera2D

#region Variables
@export var map: Map
@export var follow: Node2D
@export var following: bool = true

var _last_rotation = 0
var rot_num = 0
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	self.ignore_rotation = false
	self.add_to_group(Data.GROUP_CAMERA)

func _process(_delta: float) -> void:
	if following:
		var scene_camera = get_viewport().get_camera_2d()
		if _rotation_changed():
			_update_rotation()
			_update_bound()
		scene_camera.position = follow.position
#endregion

#region Public Functions
func update_map(map: Map):
	self.map = map
	_update_bound()
#endregion

#region Private Functions
func _apply_limit_offsets():
	self.limit_left += int(self.offset.x)
	self.limit_top -=  int(self.offset.y)
	self.limit_right += int(self.offset.x)
	self.limit_bottom -= int(self.offset.y)

func _rotation_changed():
	return rotation != _last_rotation

func _update_bound():
	var limit: Rect2 = map.get_bounds()
	var viewport: Rect2 = get_viewport_rect()
	var x = int(limit.position.x)
	var y = int(limit.position.y)
	var w = int(limit.end.x)
	var h = int(limit.end.y)
	var ts = map.get_tile_size()
	var sx = int(map.scale.x)
	var sy = int(map.scale.y)
	var vw = int(viewport.size.x)
	var vh = int(viewport.size.y)

	self.limit_left = x
	self.limit_top = y
	self.limit_right = (w*ts.x*sx) # 2560
	self.limit_bottom = (h*ts.y*sy) # 1472
	match rot_num:
		0:
			# Do nothing, you're perfect the way you are bb <3
			pass
		1:
			self.limit_left += vh
			self.limit_top += 0
			self.limit_right += (vw - vh) + vh
			self.limit_bottom += -(vw - vh)
		2:
			self.limit_left += vw
			self.limit_top += vh
			self.limit_right += vw
			self.limit_bottom += vh
		3:
			self.limit_left += 0
			self.limit_top += vw
			self.limit_right += (vw - vh)
			self.limit_bottom +=  -(vw - vh) + vw
#	print("""\
#Limits:     %04d
#	   %04d      %04d
#			%04d
#	""" % [self.limit_top, self.limit_left, self.limit_right, self.limit_bottom])
	_apply_limit_offsets()

func _update_rotation():
	_last_rotation = rotation
	rot_num = (rot_num + 1) % 4
	#print("rot_num = %d" % rot_num)

#endregion
