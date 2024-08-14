class_name Map extends TileMap

#region Variables
@export var default_transition: MapTransition
# id : MapTransition
var transitions: Dictionary
#endregion

#region Signals
signal transition_triggered(map_id, transition_id)
#endregion

#region Engine Functions
func _ready() -> void:
	assert(default_transition)
	_generate_transitions()

#endregion

#region Public Functions
func get_transition(id: int) -> MapTransition:
	return transitions.get(id, default_transition)

func enter():
	# TODO: Each map has something different to do
	#		How do we handle that?
	#		Do we go to the children and do enter() on them too?
	#		Don't forget to use the current game state!
	pass
#endregion

#region Private Functions
func _generate_transitions():
	for child in get_children():
		if child is MapTransition:
			assert(child.id not in transitions, "map transition id overlap")
			transitions[child.id] = child
			child.triggered.connect(_on_transition_triggered)

func _on_transition_triggered(map_id, transition_id):
	transition_triggered.emit(map_id, transition_id)
#endregion

