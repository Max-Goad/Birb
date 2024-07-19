class_name Two extends Ability

const projecile_template = preload("res://resources/attacks/hb_one.tscn")

### Variables
var speed: float
var damage: int
var delay: float

var _projectile_delay_timer: Timer

### Signals

### Engine Functions
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

### Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var execute_fn = func():
		_fire_projectile(parent, direction)
		_projectile_delay_timer.timeout.connect(_fire_second_projectile.bind(parent, direction))
		_projectile_delay_timer.start(delay)
	super.execute_with_delay(execute_fn, 0.1)

### Private Functions
func _fire_projectile(parent: Player, direction: Vector2, callback = func():pass):
	var hurtbox: Hurtbox = projecile_template.instantiate()
	hurtbox.top_level = true # Do not follow parent's transforms
	hurtbox.position = parent.position
	hurtbox.scale = parent.scale
	hurtbox.velocity = Math.dither_v_rot(Math.vector8dir(direction) * Math.dither_f(self.speed, 2.5), deg_to_rad(10))
	hurtbox.finished.connect(callback)
	hurtbox.ignore(parent)
	parent.add_child(hurtbox)
	hurtbox.damage_component.amount = int(damage * parent.modifier("damage"))

func _fire_second_projectile(parent: Node2D, direction: Vector2):
	_fire_projectile(parent, direction, func(): self.finished.emit())
	_projectile_delay_timer.timeout.disconnect(_fire_second_projectile.bind(parent, direction))
