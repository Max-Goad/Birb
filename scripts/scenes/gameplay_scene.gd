extends Node2D

#region Variables
@onready var player: Player = $Player
@onready var camera: MapBoundedFollowCamera = $Camera
@onready var ui_canvas: CanvasLayer = $"UI Canvas"

@export var maps: Array[PackedScene]
var current_map: Map
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	if not current_map:
		current_map = _load_map(0)

func _process(_delta: float) -> void:
	pass
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_map_transition_trigger(map_id: int, transition_id: int):
	_on_map_transition.call_deferred(map_id, transition_id)

func _on_map_transition(map_id: int, transition_id: int):
	# Load new map
	var old_map = current_map
	current_map = _load_map(map_id)
	# Move player to target id location
	var new_transition = current_map.get_transition(transition_id)
	player.global_position = new_transition.entry.global_position
	if new_transition.overlaps_body(player):
		new_transition.ignore_until_exit(player)
	# Unload old map
	old_map.queue_free()

func _load_map(id) -> Map:
	assert(id >= 0 and id < maps.size())
	var new_map: Map = maps[id].instantiate()
	new_map.enter()
	new_map.transition_triggered.connect(_on_map_transition_trigger)
	add_child(new_map)
	camera.update_bound(new_map)
	return new_map
#endregion

