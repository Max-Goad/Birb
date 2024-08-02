class_name Enemy extends CharacterBody2D

#region Variables
@export var target: Node2D

@onready var health: HealthComponent = $HealthComponent
@onready var movement: CharacterMovementComponent = $MovementComponent
@onready var pathfinding: PathfindingComponent = $PathfindingComponent
@onready var attach_points: AttachPointComponent = $AttachPointComponent
#endregion

#region Signals
signal dead
#endregion

#region Engine Functions
func _ready() -> void:
	health.on_death.connect(_on_death)
	pathfinding.target = target

func _process(_delta: float) -> void:
	pass
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_death():
	dead.emit()
#endregion

