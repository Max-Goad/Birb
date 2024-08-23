class_name MovementReactor extends Node

#region Variables
@export var character: CharacterBody2D
@export var threshold: float = 500.0
var _previous: float = 0.0
#endregion

#region Signals
signal threshold_exceeded(amount, threshold)
#endregion

#region Engine Functions
func _ready() -> void:
	assert(character)

func _process(_delta: float) -> void:
	var current = character.velocity.length()
	#print("current = %s" % current)
	if _previous > 0.0:
		var diff = _previous - current
		if diff > threshold:
			print("MovementReactor: threshold exceeded %s -> %s (%s vs %s)" % [_previous, current, diff, threshold])
			threshold_exceeded.emit(diff, threshold)
	_previous = current
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion
