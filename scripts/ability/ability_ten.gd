class_name Ten extends Ability

const pl_hb_ten_bomb = preload("res://resources/attacks/hb_ten_bomb.tscn")
const pl_hb_ten_explosion = preload("res://resources/attacks/hb_ten_explosion.tscn")
const pl_hb_ten_projectile = preload("res://resources/attacks/hb_one.tscn")

#region Variables
var throw_force: float
var projectile_force: float
var impact_damage: int
var explosion_damage: int
var projectile_damage: int
var explosion_timer: float
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(tf, pf, id, ed, pd, et = 1.0) -> void:
	super._init()
	self.info = Data.components_by_name["十"]
	self.animation_name = "slash"
	self.cooldown = 1.5
	self.throw_force = tf
	self.projectile_force = pf
	self.impact_damage = id
	self.explosion_damage = ed
	self.projectile_damage = pd
	self.explosion_timer = et
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	(self.chain()
		.wait(0.1)
		.run(_throw_bomb)
		.wait(0.2)
		.run(self.finish)
		.start_chain())
#endregion

#region Private Functions
func _throw_bomb():
	var bomb = pl_hb_ten_bomb.instantiate()
	bomb.top_level = true # Do not follow parent's transforms
	bomb.position = self.parent.position
	bomb.scale = self.parent.scale
	bomb.velocity = Math.dither_v_rot(Math.vector8dir(self.direction) * Math.dither_f(throw_force, 5), deg_to_rad(10))
	bomb.deceleration = 0.15
	bomb.angular_velocity = Math.rand_negative(Math.dither_f(10.0, 5.0))
	bomb.angular_deceleration = Math.dither_f(0.3, 0.15)
	bomb.ignore(self.parent)
	bomb.finished.connect(func(): call_deferred("_on_bomb_finished", bomb))
	self.parent.add_child(bomb)
	bomb.damage_component.amount = int(impact_damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))

func _on_bomb_finished(bomb):
	var explosion = _spawn_explosion(bomb)
	_spawn_all_projectiles(bomb, explosion)

func _spawn_explosion(bomb) -> Hurtbox:
	var explosion = pl_hb_ten_explosion.instantiate()
	explosion.top_level = true # Do not follow parent's transforms
	explosion.position = bomb.position
	explosion.scale = bomb.scale
	# explosion.ignore(self.parent)
	self.parent.add_child(explosion)
	explosion.damage_component.amount = int(explosion_damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))

	# There's a small amount of time when both are still alive/active
	explosion.ignore_hitbox(bomb, Hitbox.MUTUAL_IGNORE)
	return explosion

func _spawn_all_projectiles(bomb, explosion):
	var spawned_projectiles: Array[Hitbox] = []
	for added_rotation in [0, 90, 180, 270]:
		var projectile = pl_hb_ten_projectile.instantiate()
		projectile.name = "Ten Projectile %s" % added_rotation
		projectile.top_level = true # Do not follow parent's transforms
		projectile.position = bomb.position
		projectile.scale = bomb.scale
		projectile.rotation_degrees = bomb.rotation_degrees + added_rotation
		projectile.velocity = Vector2.RIGHT.rotated(projectile.rotation) * projectile_force
		self.parent.add_child(projectile)
		projectile.damage_component.amount = int(projectile_damage * self.parent.modifiers.gett(Player.Modifiers.DAMAGE))
		spawned_projectiles.append(projectile)

	# Projectiles, Bomb, and Explosion should ignore each other
	for p in spawned_projectiles:
		p.ignore_hitbox(bomb, Hitbox.MUTUAL_IGNORE)
		p.ignore_hitbox(explosion, Hitbox.MUTUAL_IGNORE)
	# Projectiles should ignore each other
	Hitbox.mutual_ignore(spawned_projectiles)
#endregion
