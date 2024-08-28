class_name Map extends Node2D

#region Variables
@export var default_transition: MapTransition
# id : MapTransition
var transitions: Dictionary
var layers: Array[TileMapLayer]
var filename: String

## { NodePath : bool }
var persist_data: Dictionary
#endregion

#region Signals
signal transition_triggered(map_id, transition_id)
#endregion

#region Engine Functions
func _ready() -> void:
	assert(default_transition)
	_collect_layers()
	_collect_persist_objects()
	_generate_transitions()
#endregion

#region Public Functions
## Called right before the game saves to disk
func on_save(data: SaveData) -> void:
	# Persist
	_update_persist_data(data)

## Called right after game loads from disk
func on_load(_data: SaveData) -> void:
	#var map_items: Dictionary = data.map_items.get(self.filename, {})
	# Persist
	#_remove_persist_nodes(_extract_persist_info(data))
	pass

## Called right before game loads from disk
func on_unload() -> void:
	# TODO: Put any logic in here that only happens when you
	#		load the map from disk (not just leave and return)
	pass

## Called each time this map is entered and loaded from memory
## 	- For example: Player walks or reenters a map
func on_enter():
	_remove_persist_nodes(_extract_persist_info(Data.current_save))

## Called each time this map is exited and unloaded into memory
## 	- For example: Player walks away from a map and into a new one
func on_exit():
	_update_persist_data(Data.current_save)

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
	for child in get_children():
		if child is TileMapLayer:
			layers.push_back(child)

func _collect_persist_objects():
	for persist_object in get_tree().get_nodes_in_group(Data.GROUP_PERSIST):
		persist_data[persist_object.get_path()] = true

func _update_persist_data(data: SaveData):
	# Refresh tracked nodes to see if any have been removed
	for path in persist_data.keys():
		var node = get_node_or_null(path)
		var should_persist = node != null and not node.is_queued_for_deletion()
		persist_data[path] = should_persist
		if not should_persist:
			print("Map: (%s) Marking %s as removed" % [filename, path])
	# Update save data with new persist data
	data.map_items.get_or_add(self.filename, {})[Data.GROUP_PERSIST] = persist_data


func _remove_persist_nodes(persist: Dictionary):
	for path in persist:
		var should_persist = persist[path]
		if not should_persist:
			var node = get_node(path)
			print("Map: (%s) Removing persistent %s" % [filename, node.name])
			remove_child(node)
			node.queue_free()

func _extract_persist_info(data: SaveData) -> Dictionary:
	return data.map_items.get(self.filename, {}).get(Data.GROUP_PERSIST, {})

func _generate_transitions():
	for child in get_children():
		if child is MapTransition:
			assert(child.id not in transitions, "map transition id overlap")
			transitions[child.id] = child
			child.triggered.connect(_on_transition_triggered)

func _on_transition_triggered(map_id, transition_id):
	transition_triggered.emit(map_id, transition_id)
#endregion
