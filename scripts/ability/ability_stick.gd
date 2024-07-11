class_name Stick extends Ability

const pl_hb_stick = preload("res://resources/attacks/hb_stick.tscn")

### Variables

### Signals

### Engine Functions
func _init() -> void:
	super._init()
	self.info = Data.components_by_name["丨"]
	self.animation_name = "slash"
	self.cooldown = 0.5

### Public Functions
func execute(parent: Node2D, direction: Vector2):
	super.execute(parent, direction)
	var hurtbox: Node2D = pl_hb_stick.instantiate()
	hurtbox.ignore(parent)
	_position_hurtbox(hurtbox, direction)
	hurtbox.finished.connect(func(): self.finished.emit())
	parent.add_child(hurtbox)

### Private Functions
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
