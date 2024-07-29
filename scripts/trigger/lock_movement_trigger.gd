class_name LockMovementTrigger extends Trigger

@export var movement: MovementComponent
@export var time: float = 0.0

func execute():
	movement.lock(time)
	movement.unlocked.connect(_finish)

func _finish():
	movement.unlocked.disconnect(_finish)
	queue_free()

