class_name Enemy extends CharacterBody2D

### Variables
@export var target: Node2D

@onready var pathfinding: PathfindingComponent = $PathfindingComponent
@onready var vector_to_target: VectorVisualizer = $"Vector To Target"

### Signals

### Engine Functions
func _ready() -> void:
	pathfinding.follow(target)
	vector_to_target.target = target

func _process(_delta: float) -> void:
	pass

### Public Functions

### Private Functions

