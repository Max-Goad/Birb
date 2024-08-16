class_name Stick extends Ability

const pl_hb_stick = preload("res://resources/attacks/hb_stick.tscn")

#region Variables
#endregion

#region Signals
#endregion

#region Engine Functions
func _init() -> void:
	super._init()
	self.info = Data.components_by_name["丨"]
	self.animation_name = "slash"
	self.cooldown = 0.5
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	# TODO: Is the IGNORE_LOCK necessary?
	parent.movement.apply_direction(-direction, MovementComponent.IGNORE_LOCK)
	parent.movement.apply_speed(parent.movement.top_speed * 0.75, MovementComponent.IGNORE_LOCK)
	super.execute_with_delay(_lunge.bind(parent, direction), 0.35)
	# TODO: Damage? Damage modifier?
#endregion

#region Private Functions
func _lunge(parent: Player, direction: Vector2):
	parent.movement.apply_direction(direction, MovementComponent.IGNORE_LOCK)
	parent.movement.apply_speed(parent.movement.top_speed * 2, MovementComponent.IGNORE_LOCK)
	_spawn_hurtbox(parent, direction)

func _spawn_hurtbox(parent: Player, direction: Vector2):
	var hurtbox: Node2D = pl_hb_stick.instantiate()
	hurtbox.ignore(parent)
	_position_hurtbox(hurtbox, direction)
	hurtbox.finished.connect(func(): self.finished.emit())
	parent.add_child(hurtbox)

func _position_hurtbox(hurtbox: Node2D, direction: Vector2):
	match Math.vector4dir(direction):
		Vector2.UP:
			hurtbox.rotation_degrees = -90
			hurtbox.scale.y = -hurtbox.scale.y
		Vector2.RIGHT:
			hurtbox.rotation_degrees = 0
		Vector2.DOWN:
			hurtbox.rotation_degrees = 90
			hurtbox.scale.y = -hurtbox.scale.y
		Vector2.LEFT:
			hurtbox.scale.x = -hurtbox.scale.x
		_:
			hurtbox.rotation_degrees = 0
#endregion
