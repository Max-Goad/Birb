class_name MovementComponent extends Node

const IGNORE_LOCK = true
const FORCE_UNLOCK = true
const RELOCK = true

### Variables
@export var top_speed: float = 1.0
@export_range(0.0, 1.0) var acceleration := 1.0
@export_range(0.0, 1.0) var deceleration := 1.0
@export_range(0.0, 1.0) var rotation_speed = 0.0
@export_range(0.0, 1.0) var rotation_deceleration := 1.0

var locked = false
var unlock_when_stopped = false
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
	if not moving() and unlock_when_stopped:
		unlock(FORCE_UNLOCK)

### Public Functions
func moving() -> bool:
	assert(false, "MovementComponent.moving() is abstract")
	return false

## Lock all movement.
## Can optionally pass a time, which will
## set a timer which automatically unlocks the lock.
## If no time is passed, the lock will not auto unlock.
## If RELOCK is passed, the lock will continue
## until the new time has elapsed (ignores initial time)
func lock(time: float = 0.0, relock = false):
	if locked:
		if relock and time > 0.0:
			lock_timer.wait_time = time
	else:
		locked = true
		if time > 0.0:
			lock_timer.start(time)

## Lock all movement until the character has stopped completely
func lock_until_stopped():
	if not locked:
		lock()
		unlock_when_stopped = true

## Unlock the current lock on movement.
## Will fail to unlock if a timer was set, but
## this can be overridden by passing FORCE_UNLOCK
func unlock(force = false):
	if lock_timer.is_stopped() or force:
		locked = false
		unlock_when_stopped = false

### Private Functions

