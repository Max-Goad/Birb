class_name Gameplay extends Node2D

const MAP_DIR = "res://resources/scenes/maps"

#region Variables
@onready var player: Player = $Player
@onready var camera: MapBoundedFollowCamera = $Camera
@onready var ui_canvas: CanvasLayer = $"UI Canvas"

# String (filename) : PackedScene
var maps: Dictionary
var current_map: Map
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	_load_all_maps(Gameplay.MAP_DIR)
	# Temporary glue code
	if not current_map:
		current_map = _instantiate_map(Gameplay.get_map_names()[0])
		current_map.on_enter()
		Data.current_save.current_map = current_map.filename
	Data.save_requested.connect(on_save)
	Data.load_requested.connect(on_load)
	Data.unload_requested.connect(on_unload)

func _process(_delta: float) -> void:
	pass
#endregion

#region Public Functions
static func get_map_names() -> PackedStringArray:
	return DirAccess.get_files_at(Gameplay.MAP_DIR)

func on_save(data: SaveData) -> void:
	data.current_map = current_map.filename
	current_map.on_save(data)
	player.on_save(data)

func on_load(data: SaveData) -> void:
	# TODO: What about ability calls?
	Abilities.unset_current_abilities()
	player.on_load(data)
	current_map = _instantiate_map(data.current_map)
	current_map.on_load(data)
	Abilities.set_current_abilities()

func on_unload() -> void:
	current_map.on_unload()
	_free_map(current_map)
	player.on_unload()
#endregion

#region Private Functions
## NOTE: I forget why I chained things like this but I do remember
## that it's very important that this call is deferred properly!
func _on_map_transition_trigger(map_name: String, transition_id: int):
	_on_map_transition.call_deferred(map_name, transition_id)

## Transition to a new map, properly cleaning up the old map and
## setting up the player at the appropriate location to enter the new map.
func _on_map_transition(map_name: String, transition_id: int):
	Abilities.unset_current_abilities()
	# Unload old map
	current_map.on_exit()
	_free_map(current_map)
	# Load new map
	current_map = _instantiate_map(map_name)
	current_map.on_enter()
	# Move player to target id location
	var new_transition = current_map.get_transition(transition_id)
	player.global_position = new_transition.entry.global_position
	Abilities.set_current_abilities()

## Load all maps from disk into memory for faster swapping/instantiating.
func _load_all_maps(dir_path: String):
	for filename in DirAccess.get_files_at(dir_path):
		maps[filename] = load("%s/%s" % [dir_path,filename])

## Instantiate a new copy of the map based on the map_name.
## Call "on_load()" or "on_enter()" (not both!) after this function.
func _instantiate_map(map_name) -> Map:
	assert(map_name in maps)
	var new_map: Map = maps[map_name].instantiate()
	# We add this field so we can save/load the current map easily
	new_map.filename = map_name
	new_map.transition_triggered.connect(_on_map_transition_trigger)
	add_child(new_map)
	camera.update_map(new_map)
	return new_map

## Remove a map from memory.
## Call "on_unload()" or "on_exit()" (not both!) before this function.
func _free_map(map: Map):
	if map != null:
		remove_child(map)
		map.queue_free()
#endregion
