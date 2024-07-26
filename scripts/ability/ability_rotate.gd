class_name Rotate extends Ability

#region Variables
#endregion

#region Signals
#endregion

#region Engine Functions
func _init() -> void:
	super._init()
	self.info = Data.components_by_name["回"]
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var camera: Camera2D = Data.get_camera()
	camera.rotate(PI/2)
	finished.emit()
#endregion

#region Private Functions
#endregion
