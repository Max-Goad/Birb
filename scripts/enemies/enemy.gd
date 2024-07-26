class_name Enemy extends CharacterBody2D

#region Variables
@export var target: Node2D

@onready var health: HealthComponent = $HealthComponent
@onready var pathfinding: PathfindingComponent = $PathfindingComponent
@onready var vector_to_target: VectorVisualizer = $"Vector To Target"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	pathfinding.follow(target)
	vector_to_target.target = target

func _process(_delta: float) -> void:
	pass
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion

