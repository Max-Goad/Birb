class_name Three extends Ability

const projecile_template = preload("res://resources/attacks/hb_one.tscn")

### Variables
var speed: float
var damage: int

var _projectile_finished_num = 0

### Signals

### Engine Functions
func _init(speed, damage) -> void:
	super._init()
	self.info = Data.components_by_name["三"]
	self.animation_name = "slash"
	self.cooldown = 1.0
	self.speed = speed
	self.damage = damage

### Public Functions
func execute(parent: Node2D, direction: Vector2):
	super.execute(parent, direction)
	var execute_fn = func():
		var a = _create_projectile(parent, Math.vector8dir(direction))
		var b = _create_projectile(parent, Math.vector8dir(direction).rotated(deg_to_rad(10.0)))
		var c = _create_projectile(parent, Math.vector8dir(direction).rotated(deg_to_rad(-10.0)))

		a.ignore_all([b,c,parent])
		parent.add_child(a)
		a.damage_component.amount = self.damage
		b.ignore_all([a,c,parent])
		parent.add_child(b)
		b.damage_component.amount = self.damage
		c.ignore_all([a,b,parent])
		parent.add_child(c)
		c.damage_component.amount = self.damage

	super.execute_with_delay(execute_fn, 0.1)

### Private Functions
func _create_projectile(parent: Node2D, direction: Vector2) -> Hurtbox:
	var hurtbox: Hurtbox = projecile_template.instantiate()
	hurtbox.position = parent.position
	hurtbox.scale = parent.scale
	hurtbox.velocity = Math.dither_v_rot(direction, deg_to_rad(10)) * Math.dither_f(self.speed, 5)
	hurtbox.finished.connect(_projectile_finished)
	return hurtbox

func _projectile_finished():
	_projectile_finished_num += 1
	if _projectile_finished_num >= 3:
		self.finished.emit()
