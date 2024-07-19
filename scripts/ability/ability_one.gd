class_name One extends Ability

const pl_hb_one = preload("res://resources/attacks/hb_one.tscn")

### Variables
var speed: float
var damage: int

### Signals

### Engine Functions
func _init(speed, damage) -> void:
	super._init()
	self.info = Data.components_by_name["一"]
	self.animation_name = "slash"
	self.cooldown = 0.33
	self.speed = speed
	self.damage = damage

### Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	super.execute_with_delay(_fire.bind(parent, direction), 0.1)

### Private Functions
func _fire(parent: Player, direction: Vector2):
	var hurtbox: Hurtbox = pl_hb_one.instantiate()
	hurtbox.top_level = true # Do not follow parent's transforms
	hurtbox.position = parent.position
	hurtbox.scale = parent.scale
	hurtbox.velocity = Math.dither_v_rot(Math.vector8dir(direction) * Math.dither_f(self.speed, 5), deg_to_rad(10))
	hurtbox.ignore(parent)
	hurtbox.finished.connect(func(): self.finished.emit())
	parent.add_child(hurtbox)
	hurtbox.damage_component.amount = int(damage * parent.modifiers.gett("damage"))
