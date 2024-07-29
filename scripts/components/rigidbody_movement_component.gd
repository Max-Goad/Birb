class_name RigidBodyMovementComponent extends MovementComponent

#region Variables
@export var body: RigidBody2D
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	# character.move_and_slide()
#endregion

#region Public Functions
func node() -> Node2D:
	return body

func moving() -> bool:
	# TODO: How about angular velocity?
	return body.linear_velocity.is_zero_approx() and body.angular_velocity == 0

## Apply a velocity to the attached character.
## Will not apply if the movement is locked.
## Can optionally use IGNORE_LOCK to bypass.
func apply_force(force: Vector2, ignore_lock = false):
	if not currently_locked or ignore_lock:
		body.apply_central_force(force)

func apply_torque(torque: float, ignore_lock = false):
	if not currently_locked or ignore_lock:
		body.apply_torque(torque)
#endregion

#region Private Functions
#endregion

