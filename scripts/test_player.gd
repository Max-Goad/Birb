class_name Player extends CharacterBody2D

enum Direction {
	NONE,
	UP,
	RIGHT,
	DOWN,
	LEFT
}

### Variables
var last_direction := Vector2.DOWN
var knockback := false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var health: HealthComponent = $HealthComponent
@onready var speed: SpeedComponent = $SpeedComponent

# TODO: what's the best way to implement this?
# {name: {ID: value}}
var modifiers: Dictionary = {}

### Signals

### Engine Functions
func _ready() -> void:
	self.add_to_group(Data.GROUP_PLAYER)
	health.on_damage.connect(_on_health_damage)
	health.on_death.connect(_on_death)
	Data.component_unlocked.connect(_on_component_unlocked)

func _process(_delta: float) -> void:
	if knockback:
		if self.velocity == Vector2.ZERO:
			knockback = false

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not knockback:
		if Abilities.current_active.is_null():
			_process_velocity(direction)
			_process_attack(last_direction)
		_process_animation(direction)
	self.velocity = self.velocity.move_toward(Vector2.ZERO, speed.top_speed * speed.deceleration)
	move_and_slide()


### Public Functions
func add_modifier(key: String, applier: Object, value: float):
	var value_pair = modifiers.get(key, {})
	value_pair[applier] = value
	modifiers[key] = value_pair

func remove_modifier(key: String, applier: Object):
	assert(key in modifiers)
	assert(applier in modifiers[key])
	modifiers[key].erase(applier)

func modifier(key: String) -> float:
	return modifiers.get(key, {}).values().reduce(func(a,b): return a*b, 1.0)

### Private Functions
func _process_velocity(direction: Vector2):
	if direction == Vector2.ZERO:
		return
	self.velocity = self.velocity.move_toward(direction * speed.top_speed, speed.top_speed * speed.acceleration)
	if Abilities.current_active.is_null():
		# The player should hold their facing direction while using an ability
		self.last_direction = direction

func _process_animation(direction: Vector2):
	var prefix = ""
	if not Abilities.current_active.is_null():
		prefix = Abilities.current_active.animation_name
		direction = last_direction
	elif direction == Vector2.ZERO:
		prefix = "idle"
		direction = last_direction
	else:
		prefix = "walk"
	match Math.vector4dir(direction):
		Vector2.LEFT:
			self.sprite.play(prefix + "_left")
		Vector2.RIGHT:
			self.sprite.play(prefix + "_right")
		Vector2.UP:
			self.sprite.play(prefix + "_up")
		Vector2.DOWN:
			self.sprite.play(prefix + "_down")

func _process_attack(direction: Vector2):
	if Input.is_action_just_pressed("player_action_1"):
		Abilities.execute_ability(0, self, direction)
	elif Input.is_action_just_pressed("player_action_2"):
		Abilities.execute_ability(1, self, direction)
	elif Input.is_action_just_pressed("player_action_3"):
		Abilities.execute_ability(2, self, direction)
	elif Input.is_action_just_pressed("player_action_4"):
		Abilities.execute_ability(3, self, direction)

func _on_component_unlocked(component: CraftingComponent):
	match component.label:
		"口":
			Data.unlock_ability_slot(Ability.Category.ACTIVE, 1)
		"品":
			Data.unlock_ability_slot(Ability.Category.ACTIVE, 2)
			Data.unlock_ability_slot(Ability.Category.PASSIVE, 1)
		_:
			pass

func _on_health_damage(_amount: int, type: DamageComponent.DamageType, direction: Vector2):
	match type:
		DamageComponent.DamageType.NORMAL:
			_apply_knockback(direction, 1.5)
		DamageComponent.DamageType.HEAVY:
			_apply_knockback(direction, 2.5)

func _on_death():
	queue_free()

func _apply_knockback(direction: Vector2, factor: float):
	if direction == Vector2.ZERO:
		direction = -self.last_direction
	self.velocity = direction * speed.top_speed * factor
	knockback = true
