class_name Three extends Ability

const projecile_template = preload("res://resources/attacks/hb_one.tscn")

#region Variables
var speed: float
var damage: int

var _projectile_finished_num = 0
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(speed, damage) -> void:
	super._init()
	self.info = Data.components_by_name["三"]
	self.animation_name = "slash"
	self.cooldown = 1.0
	self.speed = speed
	self.damage = damage
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var execute_fn = func():
		var a = _create_projectile(parent, Math.vector8dir(direction))
		var b = _create_projectile(parent, Math.vector8dir(direction).rotated(deg_to_rad(10.0)))
		var c = _create_projectile(parent, Math.vector8dir(direction).rotated(deg_to_rad(-10.0)))

		Hurtbox.mutual_ignore([a,b,c])
		a.ignore(parent)
		b.ignore(parent)
		c.ignore(parent)
		parent.add_child(a)
		parent.add_child(b)
		parent.add_child(c)
		a.damage_component.amount = int(damage * parent.modifiers.gett(Player.Modifiers.DAMAGE))
		b.damage_component.amount = int(damage * parent.modifiers.gett(Player.Modifiers.DAMAGE))
		c.damage_component.amount = int(damage * parent.modifiers.gett(Player.Modifiers.DAMAGE))

	super.execute_with_delay(execute_fn, 0.1)
#endregion

#region Private Functions
func _create_projectile(parent: Node2D, direction: Vector2) -> Hurtbox:
	var hurtbox: Hurtbox = projecile_template.instantiate()
	hurtbox.position = parent.position
	hurtbox.scale = parent.scale
	var clamped_direction = Math.vector8dir(direction) * Math.dither_f(self.speed, 5)
	var dithered_direction = Math.dither_v_rot(clamped_direction, deg_to_rad(10))
	hurtbox.velocity = dithered_direction
	hurtbox.rotate(dithered_direction.angle())
	hurtbox.finished.connect(_projectile_finished)
	hurtbox.damage_component.amount = int(damage * parent.modifiers.gett(Player.Modifiers.DAMAGE))
	return hurtbox

func _projectile_finished():
	_projectile_finished_num += 1
	if _projectile_finished_num >= 3:
		self.finished.emit()
#endregion
