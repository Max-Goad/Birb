class_name MapTransition extends Area2D

#region Variables
@export var id: int
@export var target_map_id: int
@export var target_transition_id: int

@onready var entry: Node2D = $Entry
@onready var exit: CollisionShape2D = $Exit

var ignored: Dictionary = {}
#endregion

#region Signals
signal triggered(target_map_id, target_transition_id)
#endregion

#region Engine Functions
func _ready() -> void:
	area_entered.connect(_on_entered)
	body_entered.connect(_on_entered)
	area_exited.connect(_on_exited)
	body_exited.connect(_on_exited)
#endregion

#region Public Functions
func ignore_until_exit(node):
	print("ignoring %s" % node.name)
	ignored[node] = null
#endregion

#region Private Functions
func _on_entered(node):
	if node is Player:
		if node not in ignored:
			print("entry trigger by %s" % node.name)
			triggered.emit(target_map_id, target_transition_id)

func _on_exited(node):
	ignored.erase(node)

#endregion

