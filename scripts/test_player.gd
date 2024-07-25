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
@onready var movement: MovementComponent = $MovementComponent

var modifiers := ModifierMap.new()

### Signals

### Engine Functions
func _ready() -> void:
	self.add_to_group(Data.GROUP_PLAYER)
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
	_process_velocity_deceleration()

### Public Functions

### Private Functions
func _process_velocity(direction: Vector2):
	if direction == Vector2.ZERO:
		return
	var mod_speed = movement.top_speed * modifiers.gett("movement_top_speed")
	var mod_accel = movement.acceleration * modifiers.gett("movement_acceleration")
	movement.move_velocity_toward(direction * mod_speed, mod_speed * mod_accel)
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

func _process_velocity_deceleration():
	var mod_speed: float = movement.top_speed * modifiers.gett("movement_top_speed")
	var mod_decel: float = movement.deceleration * modifiers.gett("movement_deceleration")
	movement.decelerate(mod_speed * mod_decel)

func _on_component_unlocked(component: CraftingComponent):
	match component.label:
		"口":
			Data.unlock_ability_slot(Ability.Category.ACTIVE, 1)
		"品":
			Data.unlock_ability_slot(Ability.Category.ACTIVE, 2)
			Data.unlock_ability_slot(Ability.Category.PASSIVE, 1)
		_:
			pass

func _on_death():
	queue_free()
