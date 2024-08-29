class_name Map extends Node2D

#region Variables
@export var default_transition: MapTransition
# id : MapTransition
var transitions: Dictionary
var layers: Array[TileMapLayer]
var filename: String

#endregion

#region Signals
signal transition_triggered(map_id, transition_id)
#endregion

#region Engine Functions
func _ready() -> void:
	assert(default_transition)
	_collect_layers()
	_generate_transitions()
#endregion

#region Public Functions
## Called right before the game saves to disk
## The "data" param is an in-out param, so write to it!
func on_save(data: SaveData) -> void:
	var map_data: MapData = data.map_data.get_or_add(filename, MapData.generate(filename)) as MapData
	# TODO: Save other map data here?
	# Overwrite instead of add to existing object data
	map_data.object_data = _save_object_data()

## Called right after game loads from disk
## NOTE: on_load and on_enter are mutually exclusive, meaning
##		 if one runs, the other will NOT RUN (unless otherwise specified)
func on_load(data: SaveData) -> void:
	# TODO: Is this possible?
	if not data.map_data.has(filename):
		return

	var map_data: MapData = data.map_data[filename]
	# TODO: Load other map data here?

	# Check through list of existing objects to see whether
	# they should continue to exist or be removed.
	_remove_persist_objects(map_data)
	# Let objects initialize themselves with the saved object data.
	# If object data exists but no node is found, first init a new object.
	_load_object_data(map_data)

## Called right before game loads from disk
## NOTE: on_unload and on_exit are mutually exclusive, meaning
##		 if one runs, the other will NOT RUN (unless otherwise specified)
func on_unload() -> void:
	# TODO: Put any logic in here that only happens when you
	#		load the map from disk (not just leave and return)
	pass

## Called each time this map is entered and loaded from memory
## 	- For example: Player walks or reenters a map
## NOTE: on_load and on_enter are mutually exclusive, meaning
##		 if one runs, the other will NOT RUN (unless otherwise specified)
func on_enter():
	if not Data.current_save.map_data.has(filename):
		# This can occur the very first time the player enters this map
		return
	_remove_persist_objects(Data.current_save.map_data[filename])

## Called each time this map is exited and unloaded into memory
## 	- For example: Player walks away from a map and into a new one
## NOTE: on_unload and on_exit are mutually exclusive, meaning
##		 if one runs, the other will NOT RUN (unless otherwise specified)
func on_exit():
	var map_data: MapData = Data.current_save.map_data.get_or_add(filename, MapData.generate(filename)) as MapData
	map_data.object_data = _save_object_data()


func get_map_scale() -> Vector2:
	var layer_scale = Vector2.ZERO
	for layer in layers:
		if layer_scale == Vector2.ZERO:
			layer_scale = layer.scale
		else:
			assert(layer_scale == layer.scale)
	return layer_scale


func get_bounds() -> Rect2i:
	var bounds = Rect2i()
	for layer in layers:
		bounds = bounds.merge(layer.get_used_rect())
	return bounds

# Note: All layers must use the same tileset in this scheme
#		Otherwise, attempting to try and get the tile sizes would be impossible
func get_tile_size() -> Vector2i:
	var tileset: TileSet = null
	for layer in layers:
		if tileset == null:
			tileset = layer.tile_set
		else:
			assert(tileset == layer.tile_set)
	return tileset.tile_size

func get_transition(id: int) -> MapTransition:
	return transitions.get(id, default_transition)
#endregion

#region Private Functions
func _collect_layers():
	# TODO: Use groups instead?
	for child in get_children():
		if child is TileMapLayer:
			layers.push_back(child)

func _save_object_data() -> Dictionary:
	var output := {}
	for object in _get_persist_objects():
		# TODO: Possible?
		if not object or object.is_queued_for_deletion():
			continue
		var object_data := {}
		# TODO: Could we also check to see if the object
		#		has a "SaveComponent" child? How would it work?
		if object.has_method("on_save"):
			object.on_save(object_data)
		# Even if the object doesn't have an "on_save()", we still
		# want to add it to the map data because its existence proves
		# it should persist when the SaveData is loaded again.
		output[object.get_path()] = object_data
	return output

func _load_object_data(map_data: MapData):
	for object_path in map_data.object_data:
		if not has_node(object_path):
			# TODO: This isn't implemented yet
			pass
		var object_data = map_data.object_data[object_path]
		var object = get_node(object_path)
		# TODO: Could we also check to see if the object
		#		has a "SaveComponent" child? How would it work?
		if object.has_method("on_load"):
			object.on_load(object_data)

func _get_persist_objects() -> Array[Node]:
	return get_tree().get_nodes_in_group(Data.GROUP_PERSIST)

func _remove_persist_objects(map_data: MapData):
	for object in _get_persist_objects():
		if object.get_path() not in map_data.object_data:
			print("Map: Object (%s) not found in loaded data; Removing from %s" % [object.name, filename])
			object.get_parent().remove_child(object)
			object.queue_free()

func _generate_transitions():
	# TODO: Use groups instead?
	for child in get_children():
		if child is MapTransition:
			assert(child.id not in transitions, "map transition id overlap")
			transitions[child.id] = child
			child.triggered.connect(_on_transition_triggered)

func _on_transition_triggered(map_id, transition_id):
	transition_triggered.emit(map_id, transition_id)
#endregion
