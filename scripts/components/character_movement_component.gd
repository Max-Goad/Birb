class_name CharacterMovementComponent extends MovementComponent

### Variables
@export var character: CharacterBody2D

### Signals

### Engine Functions
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	super._process(delta)
	character.move_and_slide()

### Public Functions
func moving() -> bool:
	return character.velocity != Vector2.ZERO

## Apply a velocity to the attached character.
## Will not apply if the movement is locked.
## Can optionally use IGNORE_LOCK to bypass.
func apply_velocity(velocity: Vector2, ignore_lock = false):
	if not locked or ignore_lock:
		character.velocity = velocity

func move_velocity_toward(to: Vector2, delta: float, ignore_lock = false):
	var velocity = character.velocity.move_toward(to, delta)
	apply_velocity(velocity, ignore_lock)

func decelerate(amount: float):
	move_velocity_toward(Vector2.ZERO, amount, IGNORE_LOCK)

### Private Functions
