extends Node

enum Strategy
{
	FOLLOW = 0,
}

### Variables
@export var strategy = Strategy.FOLLOW
@export var character: CharacterBody2D
@export var target: Node2D
@export var speed: SpeedComponent

### Signals

### Engine Functions
func _ready() -> void:
	assert(character)
	assert(target)
	assert(speed)

func _process(delta: float) -> void:
	_process_strategy(delta)
	character.move_and_slide()

### Public Functions

### Private Functions
func _process_strategy(delta):
	match strategy:
		Strategy.FOLLOW:
			character.velocity = character.velocity.move_toward(target.position - character.position, speed.top_speed * delta)

