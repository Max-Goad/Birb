class_name MapTransition extends Area2D

#region Variables
@export var id: int
@export var target_map_id: int
@export var target_transition_id: int

@onready var entry: Node2D = $Entry
@onready var exit: CollisionShape2D = $Exit
#endregion

#region Signals
signal triggered(target_map_id, target_transition_id)
#endregion

#region Engine Functions
func _ready() -> void:
	area_entered.connect(_on_entered)
	body_entered.connect(_on_entered)
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_entered(node):
	if node is Player:
		triggered.emit(target_map_id, target_transition_id)
#endregion

