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
	# var old_velocity = character.velocity
	var new_velocity = direction * speed
	character.velocity = new_velocity
	character.move_and_slide()
	var final_velocity = character.velocity
	direction = final_velocity.normalized()
	speed = final_velocity.length()

#endregion

#region Public Functions
func node() -> Node2D:
	return character

func moving() -> bool:
	return character.velocity != Vector2.ZERO

func apply_direction(new_direction: Vector2, ignore_lock = false):
	if not currently_locked or ignore_lock:
		direction = new_direction

func apply_speed(new_speed: float, ignore_lock = false):
	if not currently_locked or ignore_lock:
		speed = new_speed

## Apply a velocity to the attached character.
## Will not apply if the movement is locked.
## Can optionally use IGNORE_LOCK to bypass.
func apply_velocity(velocity: Vector2, ignore_lock = false):
	print("CMC apply_velocity")
	apply_direction(velocity.normalized(), ignore_lock)
	apply_speed(velocity.length(), ignore_lock)

func apply_rotation(angle: float, ignore_lock = false):
	if not currently_locked or ignore_lock:
		character.global_rotation = angle

func rotate_velocity_toward(target_direction: Vector2, ignore_lock = false):
	if not currently_locked or ignore_lock:
		# A player not moving, or wishing to move in the
		# opposite direction, should turn around instantly!
		if direction == Vector2.ZERO or direction == -target_direction:
			apply_direction(target_direction, ignore_lock)
			return
		var target_angle = direction.angle_to(target_direction)
		var angle = move_toward(0, target_angle, rotation_speed)
		var new_direction = direction.normalized().rotated(angle)
		#print("d(%s), ta(%s), a(%s), nd(%s)" % [direction, target_angle, angle, new_direction])
		apply_direction(new_direction, ignore_lock)

func accelerate(modifier = 1.0):
	# TODO: Only have one modifier means that the acceleration modifier will affect top speed
	# 		We should have two modifiers instead (one for each speed element used)
	#		Or potentially pass the structure itself???
	var delta = top_speed * acceleration * modifier
	var new_speed = move_toward(speed, top_speed * modifier, delta)
	#print("CMC accelerate (s = %s, delta = %s, ns = %s)" % [speed, delta, new_speed])
	apply_speed(new_speed, IGNORE_LOCK)

func decelerate(modifier = 1.0):
	# TODO: See above comment in accelerate()
	var delta = top_speed * deceleration * modifier
	var new_speed = move_toward(speed, 0.0, delta)
	#print("CMC decelerate (s = %s, delta = %s, ns = %s)" % [speed, delta, new_speed])
	apply_speed(new_speed, IGNORE_LOCK)
#endregion

#region Private Functions
#endregion

