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
		current_map = _enter_new_map(Gameplay.get_map_names()[0])
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
	current_map = _enter_new_map(data.current_map)
	current_map.on_load(data)
	Abilities.set_current_abilities()

func on_unload() -> void:
	current_map.on_unload()
	_exit_old_map(current_map)
	player.on_unload()
#endregion

#region Private Functions
func _on_map_transition_trigger(map_name: String, transition_id: int):
	_on_map_transition.call_deferred(map_name, transition_id)

func _on_map_transition(map_name: String, transition_id: int):
	Abilities.unset_current_abilities()
	# Unload old map
	_exit_old_map(current_map)
	# Load new map
	current_map = _enter_new_map(map_name)
	# Move player to target id location
	var new_transition = current_map.get_transition(transition_id)
	player.global_position = new_transition.entry.global_position
	Abilities.set_current_abilities()

func _load_all_maps(dir_path: String):
	for filename in DirAccess.get_files_at(dir_path):
		maps[filename] = load("%s/%s" % [dir_path,filename])

func _enter_new_map(map_name) -> Map:
	assert(map_name in maps)
	var new_map: Map = maps[map_name].instantiate()
	# We add this field so we can save/load the current map easily
	new_map.filename = map_name
	new_map.transition_triggered.connect(_on_map_transition_trigger)
	add_child(new_map)
	new_map.on_enter()
	camera.update_map(new_map)
	return new_map

func _exit_old_map(map: Map):
	if map != null:
		map.on_exit()
		remove_child(map)
		map.queue_free()
#endregion
