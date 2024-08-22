class_name Map extends Node2D

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
func get_bounds() -> Rect2i:
	var bounds = Rect2i()
	for child in get_children():
		if child is TileMapLayer:
			bounds = bounds.merge(child.get_used_rect())
	return bounds

# Note: All layers must use the same tileset in this scheme
#		Otherwise, attempting to try and get the tile sizes would be impossible
func get_tile_size() -> Vector2i:
	var tileset: TileSet = null
	for child in get_children():
		if child is TileMapLayer:
			if tileset == null:
				tileset = child.tile_set
			else:
				assert(tileset == child.tile_set)
	return tileset.tile_size

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
