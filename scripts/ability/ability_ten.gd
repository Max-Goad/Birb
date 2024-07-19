class_name Ten extends Ability

const pl_hb_ten_bomb = preload("res://resources/attacks/hb_ten_bomb.tscn")
const pl_hb_ten_explosion = preload("res://resources/attacks/hb_ten_explosion.tscn")
const pl_hb_ten_projectile = preload("res://resources/attacks/hb_ten_projectile.tscn")

### Variables
var throw_force: float
var projectile_force: float
var impact_damage: int
var explosion_damage: int
var projectile_damage: int
var explosion_timer: float

var current_parent: Node2D = null
var current_bomb: Hurtbox = null
var current_explosion: Hurtbox = null

### Signals

### Engine Functions
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


### Public Functions
func execute(parent: Player, direction: Vector2):
	assert(current_bomb == null)
	assert(current_explosion == null)
	super.execute(parent, direction)
	self.current_parent = parent
	var execute_fn = func():
		_throw_bomb(direction)
		finished.emit()
	super.execute_with_delay(execute_fn, 0.1)

### Private Functions
func _throw_bomb(direction: Vector2):
	self.current_bomb = pl_hb_ten_bomb.instantiate()
	current_bomb.top_level = true # Do not follow parent's transforms
	current_bomb.position = current_parent.position
	current_bomb.scale = current_parent.scale
	current_bomb.velocity = Math.dither_v_rot(Math.vector8dir(direction) * Math.dither_f(throw_force, 5), deg_to_rad(10))
	current_bomb.deceleration = 0.15
	current_bomb.angular_velocity = Math.rand_negative(Math.dither_f(10.0, 5.0))
	current_bomb.angular_deceleration = Math.dither_f(0.3, 0.15)
	current_bomb.ignore(current_parent)
	current_bomb.finished.connect(func(): call_deferred("_on_bomb_finished"))
	current_parent.add_child(current_bomb)
	current_bomb.damage_component.amount = int(impact_damage * current_parent.modifier("damage"))

func _on_bomb_finished():
	_spawn_explosion()
	_spawn_all_projectiles()
	current_bomb = null

func _spawn_explosion():
	self.current_explosion = pl_hb_ten_explosion.instantiate()
	current_explosion.top_level = true # Do not follow parent's transforms
	current_explosion.position = current_bomb.position
	current_explosion.scale = current_bomb.scale
	# current_explosion.ignore(current_parent)
	current_explosion.finished.connect(_on_explosion_finished)
	current_parent.add_child(current_explosion)
	current_explosion.damage_component.amount = int(explosion_damage * current_parent.modifier("damage"))

	# There's a small amount of time when both are still alive/active
	current_explosion.ignore_hurtbox(current_bomb, Hurtbox.MUTUAL_IGNORE)

func _on_explosion_finished():
	current_explosion = null

func _spawn_all_projectiles():
	var spawned_projectiles: Array[Hurtbox] = []
	for added_rotation in [0, 90, 180, 270]:
		var projectile = pl_hb_ten_projectile.instantiate()
		projectile.name = "Ten Projectile %s" % added_rotation
		projectile.top_level = true # Do not follow parent's transforms
		projectile.position = current_bomb.position
		projectile.scale = current_bomb.scale
		projectile.rotation_degrees = current_bomb.rotation_degrees + added_rotation
		projectile.velocity = Vector2.RIGHT.rotated(projectile.rotation) * projectile_force
		current_parent.add_child(projectile)
		projectile.damage_component.amount = int(projectile_damage * current_parent.modifier("damage"))
		spawned_projectiles.append(projectile)

	# Projectiles, Bomb, and Explosion should ignore each other
	for p in spawned_projectiles:
		p.ignore_hurtbox(current_bomb, Hurtbox.MUTUAL_IGNORE)
		p.ignore_hurtbox(current_explosion, Hurtbox.MUTUAL_IGNORE)
	# Projectiles should ignore each other
	Hurtbox.mutual_ignore(spawned_projectiles)
