class_name CharacterMovementComponent extends MovementComponent

#region Variables
@export var character: CharacterBody2D
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	character.move_and_slide()
#endregion

#region Public Functions
func node() -> Node2D:
	return character

func moving() -> bool:
	return character.velocity != Vector2.ZERO

## Apply a velocity to the attached character.
## Will not apply if the movement is locked.
## Can optionally use IGNORE_LOCK to bypass.
func apply_velocity(velocity: Vector2, ignore_lock = false):
	if not currently_locked or ignore_lock:
		character.velocity = velocity

func move_velocity_toward(to: Vector2, delta: float, ignore_lock = false):
	var velocity = character.velocity.move_toward(to, delta)
	apply_velocity(velocity, ignore_lock)

func decelerate(modifier = 1.0):
	move_velocity_toward(Vector2.ZERO, top_speed * deceleration * modifier, IGNORE_LOCK)

func apply_rotation(angle: float, ignore_lock = false):
	if not currently_locked or ignore_lock:
		character.global_rotation = angle
#endregion

#region Private Functions
#endregion

