class_name Hundred extends Ability

const pl_hb_hundred_bomb = preload("res://resources/attacks/hb_hundred_bomb.tscn")
const pl_hb_hundred_explosion = preload("res://resources/attacks/hb_hundred_explosion.tscn")

#region Variables
var throw_force: float
var impact_damage: int
var explosion_damage: int
var explosion_timer: float
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(tf, id, ed, et = 1.0) -> void:
	super._init()
	self.info = Data.components_by_name["百"]
	self.animation_name = "slash"
	self.cooldown = 1.5
	self.throw_force = tf
	self.impact_damage = id
	self.explosion_damage = ed
	self.explosion_timer = et
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	(super.chain()
		.wait(0.1)
		.run(_throw_bomb)
		.wait(0.2)
		.run(self.finish)
		.start_chain()
	)
#endregion

#region Private Functions
func _throw_bomb():
	var bomb = pl_hb_hundred_bomb.instantiate()
	bomb.top_level = true # Do not follow parent's transforms
	bomb.position = self.parent.position
	bomb.scale = self.parent.scale
	bomb.velocity = Math.dither_v_rot(Math.vector8dir(self.direction) * Math.dither_f(throw_force, 5), deg_to_rad(10))
	bomb.deceleration = 0.15
	bomb.ignore(self.parent)
	bomb.finished.connect(_on_bomb_finished.bind(self.parent, bomb))
	self.parent.add_child(bomb)
	bomb.damage_component.amount = int(impact_damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))

func _on_bomb_finished(parent, bomb):
	call_deferred("_spawn_explosion", parent, bomb)

func _spawn_explosion(parent, bomb):
	var explosion = pl_hb_hundred_explosion.instantiate()
	explosion.top_level = true # Do not follow parent's transforms
	explosion.position = bomb.position
	explosion.scale = bomb.scale
	# explosion.ignore(parent)
	parent.add_child(explosion)
	explosion.damage_component.amount = int(explosion_damage * parent.modifiers.gett(Player.Modifiers.DAMAGE))
	# There's a small amount of time when both are still alive/active
	explosion.ignore_hurtbox(bomb, Hitbox.MUTUAL_IGNORE)
#endregion
