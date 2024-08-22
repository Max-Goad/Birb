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
	self.animation_name = "lunge"
	self.cooldown = 0.5
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	self.parent = parent
	self.direction = direction
	super.chain().run(_windup).wait(0.35).run(_lunge).wait(0.15).run(_spawn_hurtbox).start_chain()
	# TODO: Damage? Damage modifier?
#endregion

#region Private Functions
func _windup():
	self.parent.movement.apply_direction(-self.direction, MovementComponent.IGNORE_LOCK)
	self.parent.movement.apply_speed(self.parent.movement.top_speed * 0.75, MovementComponent.IGNORE_LOCK)

func _lunge():
	self.parent.movement.apply_direction(self.direction, MovementComponent.IGNORE_LOCK)
	self.parent.movement.apply_speed(self.parent.movement.top_speed * 2, MovementComponent.IGNORE_LOCK)

func _spawn_hurtbox():
	var hurtbox: Node2D = pl_hb_stick.instantiate()
	hurtbox.ignore(self.parent)
	_position_hurtbox(hurtbox, self.direction)
	hurtbox.finished.connect(func(): self.finished.emit())
	hurtbox.despawn_after_delay(0.16)
	self.parent.add_child(hurtbox)

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
