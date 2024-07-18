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

var _explosion_timer: Timer

### Signals

### Engine Functions
func _init(tf, pf, id, ed, pd, et = 1.0) -> void:
	super._init()
	self.info = Data.components_by_name["十"]
	self.animation_name = "slash"
	self.cooldown = 5.0
	self.throw_force = tf
	self.projectile_force = pf
	self.impact_damage = id
	self.explosion_damage = ed
	self.projectile_damage = pd
	self.explosion_timer = et

	_explosion_timer = Timer.new()
	_explosion_timer.one_shot = true
	_explosion_timer.timeout.connect(_on_explosion_timeout)
	add_child(_explosion_timer)


### Public Functions
func execute(parent: Node2D, direction: Vector2):
	super.execute(parent, direction)
	self.current_parent = parent
	var execute_fn = func():
		_throw_bomb(direction)
		_explosion_timer.start(self.explosion_timer)
		self.finished.emit()
	super.execute_with_delay(execute_fn, 0.1)

### Private Functions
func _throw_bomb(direction: Vector2):
	self.current_bomb = pl_hb_ten_bomb.instantiate()
	current_bomb.position = current_parent.position
	current_bomb.scale = current_parent.scale
	#current_bomb.velocity = Math.dither_v_rot(Math.vector8dir(direction) * Math.dither_f(throw_force, 5), deg_to_rad(10))
	current_bomb.ignore(current_parent)
	# TODO: If the hitbox hits its finish before the timer... what do we do?
	#		Should the timer actually be inside the bomb itself?
	# current_bomb.finished.connect(...)
	current_parent.add_child(current_bomb)
	current_bomb.damage_component.amount = self.impact_damage

func _on_explosion_timeout():
	_spawn_explosion()
	_spawn_all_projectiles()
	_despawn_bomb()

func _despawn_bomb():
	current_bomb.despawn()
	current_bomb = null

func _spawn_explosion():
	self.current_explosion = pl_hb_ten_explosion.instantiate()
	current_explosion.position = current_bomb.position
	current_explosion.scale = current_bomb.scale
	# TODO: Should the explosion ignore the parent?
	# current_explosion.ignore(current_parent)
	current_explosion.finished.connect(_on_explosion_finished)
	current_parent.add_child(current_explosion)
	current_explosion.damage_component.amount = self.explosion_damage

func _on_explosion_finished():
	current_explosion = null

func _spawn_all_projectiles():
	for added_rotation in [0, 90, 180, 270]:
		var projectile = pl_hb_ten_projectile.instantiate()
		projectile.position = current_bomb.position
		projectile.scale = current_bomb.scale
		projectile.rotation_degrees = current_bomb.rotation_degrees + added_rotation
		projectile.velocity = Vector2.UP * self.projectile_force
		current_parent.add_child(projectile)
		projectile.damage_component.amount = self.projectile_damage
