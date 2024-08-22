class_name Two extends Ability

const projecile_template = preload("res://resources/attacks/hb_one.tscn")

#region Variables
var speed: float
var damage: int
var delay: float

var _projectile_delay_timer: Timer
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(speed, damage, delay) -> void:
	super._init()
	self.info = Data.components_by_name["二"]
	self.animation_name = "slash"
	self.cooldown = 0.5
	self.speed = speed
	self.damage = damage
	self.delay = delay

	_projectile_delay_timer = Timer.new()
	_projectile_delay_timer.one_shot = true
	add_child(_projectile_delay_timer)
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	(super.chain()
		.wait(0.1)
		.run(_fire_projectile)
		.wait(delay)
		.run(_fire_projectile)
		.wait(0.2)
		.run(self.finish)
		.start_chain()
	)
#endregion

#region Private Functions
func _fire_projectile():
	var hurtbox: Hurtbox = projecile_template.instantiate()
	hurtbox.top_level = true # Do not follow parent's transforms
	hurtbox.position = self.parent.position
	hurtbox.scale = self.parent.scale
	var clamped_direction = Math.vector8dir(self.direction) * Math.dither_f(self.speed, 5)
	var dithered_direction = Math.dither_v_rot(clamped_direction, deg_to_rad(10))
	hurtbox.velocity = dithered_direction
	hurtbox.rotate(dithered_direction.angle())
	hurtbox.ignore(self.parent)
	self.parent.add_child(hurtbox)
	hurtbox.damage_component.amount = int(damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))
#endregion
