class_name Enemy extends CharacterBody2D

#region Variables
@export var target: Node2D

@onready var health: HealthComponent = $HealthComponent
@onready var pathfinding: PathfindingComponent = $PathfindingComponent
@onready var attach_points: AttachPointComponent = $AttachPointComponent
@onready var vector_to_target: VectorVisualizer = $"Vector To Target"
#endregion

#region Signals
signal dead
#endregion

#region Engine Functions
func _ready() -> void:
	health.on_death.connect(_on_death)
	pathfinding.follow(target)
	vector_to_target.target = target

func _process(_delta: float) -> void:
	pass
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_death():
	dead.emit()
#endregion

