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

func _process(_delta: float) -> void:
	pass
#endregion

#region Public Functions
static func get_map_names() -> PackedStringArray:
	return DirAccess.get_files_at(Gameplay.MAP_DIR)
#endregion

#region Private Functions
func _on_map_transition_trigger(map_name: String, transition_id: int):
	_on_map_transition.call_deferred(map_name, transition_id)

func _on_map_transition(map_name: String, transition_id: int):
	# Load new map
	var old_map = current_map
	current_map = _load_map(map_name)
	# Move player to target id location
	var new_transition = current_map.get_transition(transition_id)
	player.global_position = new_transition.entry.global_position
	# Unload old map
	old_map.queue_free()

func _load_all_maps(dir_path: String):
	for path in DirAccess.get_files_at(dir_path):
		maps[path] = (load("%s/%s" % [dir_path,path]))

func _load_map(map_name) -> Map:
	assert(map_name in maps)
	var new_map: Map = maps[map_name].instantiate()
	new_map.enter()
	new_map.transition_triggered.connect(_on_map_transition_trigger)
	add_child(new_map)
	camera.update_map(new_map)
	return new_map
#endregion
