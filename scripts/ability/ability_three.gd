class_name Three extends Ability

const projecile_template = preload("res://resources/attacks/hb_one.tscn")

#region Variables
var speed: float
var damage: int
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
	(super.chain()
		.wait(0.1)
		.run(_fire_3_projectiles)
		.wait(0.2)
		.run(self.finish)
		.start_chain()
	)
#endregion

#region Private Functions
func _fire_3_projectiles():
	var a = _create_projectile()
	var b = _create_projectile(deg_to_rad(10.0))
	var c = _create_projectile(deg_to_rad(-10.0))

	Hurtbox.mutual_ignore([a,b,c])
	a.ignore(self.parent)
	b.ignore(self.parent)
	c.ignore(self.parent)
	self.parent.add_child(a)
	self.parent.add_child(b)
	self.parent.add_child(c)
	a.damage_component.amount = int(damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))
	b.damage_component.amount = int(damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))
	c.damage_component.amount = int(damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))


func _create_projectile(rotation_rad: float = 0.0) -> Hurtbox:
	var hurtbox: Hurtbox = projecile_template.instantiate()
	hurtbox.position = self.parent.position
	hurtbox.scale = self.parent.scale
	var rotated_direction = Math.vector8dir(self.direction).rotated(rotation_rad)
	var speed_direction = rotated_direction * Math.dither_f(self.speed, 5)
	var final_direction = Math.dither_v_rot(speed_direction, deg_to_rad(10))
	hurtbox.velocity = final_direction
	hurtbox.rotate(final_direction.angle())
	hurtbox.damage_component.amount = int(damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))
	return hurtbox
#endregion
