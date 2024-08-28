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
	if not current_map:
		current_map = _load_map(Gameplay.get_map_names()[0])
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

func on_load(data: SaveData) -> void:
	# TODO: What about ability calls?
	current_map = _load_map(data.current_map)

func on_unload() -> void:
	remove_child(current_map)
	current_map.queue_free()
#endregion

#region Private Functions
func _on_map_transition_trigger(map_name: String, transition_id: int):
	_on_map_transition.call_deferred(map_name, transition_id)

func _on_map_transition(map_name: String, transition_id: int):
	Abilities.unset_current_abilities()
	# Load new map
	var old_map = current_map
	current_map = _load_map(map_name)
	# Move player to target id location
	var new_transition = current_map.get_transition(transition_id)
	player.global_position = new_transition.entry.global_position
	# Unload old map
	remove_child(old_map)
	old_map.queue_free()
	Abilities.set_current_abilities()

func _load_all_maps(dir_path: String):
	for filename in DirAccess.get_files_at(dir_path):
		maps[filename] = load("%s/%s" % [dir_path,filename])

func _load_map(map_name) -> Map:
	assert(map_name in maps)
	var new_map: Map = maps[map_name].instantiate()
	# We add this field so we can save/load the current map easily
	new_map.filename = map_name
	new_map.enter()
	new_map.transition_triggered.connect(_on_map_transition_trigger)
	add_child(new_map)
	camera.update_map(new_map)
	return new_map
#endregion
