class_name CharacterMovementComponent extends MovementComponent

#region Variables
@export var character: CharacterBody2D

var direction = Vector2.ZERO
var speed = 0.0
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	# Setting the direction to ZERO allows the character
	# to immediately accelerate in any direction next time
	if speed == 0.0:
		direction = Vector2.ZERO
	character.velocity = direction * speed
	character.move_and_slide()
#endregion

#region Public Functions
func node() -> Node2D:
	return character

func moving() -> bool:
	return character.velocity != Vector2.ZERO

func apply_direction(new_direction: Vector2, ignore_lock = false) -> bool:
	if currently_locked and not ignore_lock:
		return false
	direction = new_direction
	return true

func apply_speed(new_speed: float, ignore_lock = false) -> bool:
	if currently_locked and not ignore_lock:
		return false
	speed = new_speed
	return true

## Apply a velocity to the attached character.
## Will not apply if the movement is locked.
## Can optionally use IGNORE_LOCK to bypass.
func apply_velocity(velocity: Vector2, ignore_lock = false) -> bool:
	print("CharacterMovementComponent: (%s) apply_velocity")
	var da = apply_direction(velocity.normalized(), ignore_lock)
	var sa = apply_speed(velocity.length(), ignore_lock)
	return da and sa

func apply_rotation(angle: float, ignore_lock = false) -> bool:
	if currently_locked and not ignore_lock:
		return false
	character.global_rotation = angle
	return true

func rotate_velocity_toward(target_direction: Vector2, ignore_lock = false) -> bool:
	if currently_locked and not ignore_lock:
		return false
	# A player not moving, or wishing to move in the
	# opposite direction, should turn around instantly!
	if direction == Vector2.ZERO or direction == -target_direction:
		return apply_direction(target_direction, ignore_lock)
	var target_angle = direction.angle_to(target_direction)
	var angle = move_toward(0, target_angle, rotation_speed / (2*PI))
	var new_direction = direction.normalized().rotated(angle)
	#print("d(%s), ta(%s), a(%s), nd(%s)" % [direction, target_angle, angle, new_direction])
	return apply_direction(new_direction, ignore_lock)

func accelerate(modifier = 1.0, ignore_lock = false) -> bool:
	# TODO: Only have one modifier means that the acceleration modifier will affect top speed
	# 		We should have two modifiers instead (one for each speed element used)
	#		Or potentially pass the structure itself???
	#print("CharacterMovementComponent: (%s) accelerate" % get_parent().name)
	var delta = top_speed * acceleration * modifier
	var new_speed = move_toward(speed, top_speed * modifier, delta)
	#print("CMC accelerate (s = %s, delta = %s, ns = %s)" % [speed, delta, new_speed])
	return apply_speed(new_speed, ignore_lock)

func decelerate(modifier = 1.0) -> bool:
	# TODO: See above comment in accelerate()
	#print("CharacterMovementComponent: (%s) decelerate" % get_parent().name)
	var delta = top_speed * deceleration * modifier
	var new_speed = move_toward(speed, 0.0, delta)
	#print("CMC decelerate (s = %s, delta = %s, ns = %s)" % [speed, delta, new_speed])
	return apply_speed(new_speed, IGNORE_LOCK)
#endregion

#region Private Functions
#endregion

