class_name TargetReticle extends Node2D

#region Variables
@export var target: Node2D
@export var color: Color :
	set(value):
		color = value
		_reticle.modulate = value
@export var target_strategy: Callable = func(): return target

@onready var _reticle: Polygon2D = $Polygon2D
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	# TODO: What's a better way to do this?
	z_index = 10

func _process(_delta: float) -> void:
	target = target_strategy.call()
	if target:
		show()
		self.global_position = target.global_position
		self.scale = target.scale
	else:
		hide()
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion

