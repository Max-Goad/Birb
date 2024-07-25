class_name MovementComponent extends Node

const FORCE_UNLOCK = true

### Variables
@export var character: CharacterBody2D

@export_category("Speed")
@export var top_speed: float = 1.0
@export_range(0.0, 1.0) var acceleration := 1.0
@export_range(0.0, 1.0) var deceleration := 1.0
@export_range(0.0, 1.0) var rotation_speed = 0.5
@export var ability_speed = 1.0
@export var projectile_speed = 1.0

var locked = false
var lock_timer = Timer.new()

### Signals

### Engine Functions
func _ready() -> void:
	lock_timer = Timer.new()
	lock_timer.autostart = false
	lock_timer.one_shot = true
	lock_timer.timeout.connect(unlock)
	add_child(lock_timer)

func _process(_delta: float) -> void:
	character.move_and_slide()

### Public Functions
func moving() -> bool:
	return character.velocity != Vector2.ZERO

## Apply a velocity to the attached character.
## Will not apply if the movement is locked.
func apply_velocity(velocity: Vector2):
	if not locked:
		character.velocity = velocity

func move_velocity_toward(to: Vector2, delta: float):
	var velocity = character.velocity.move_toward(to, delta)
	apply_velocity(velocity)

## Lock all movement.
## Can optionally pass a time, which will
## set a timer which automatically unlocks the lock.
## If no time is passed, the lock will not auto unlock.
func lock(time: float = -0.0):
	locked = true
	if time > 0.0:
		lock_timer.start(time)

## Unlock the current lock on movement.
## Will fail to unlock if a timer was set, but
## this can be overridden by passing FORCE_UNLOCK
func unlock(force = false):
	if lock_timer.is_stopped() or force:
		locked = false

### Private Functions

