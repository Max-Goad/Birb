class_name Player extends CharacterBody2D

enum Modifiers {
	DAMAGE = 10,
	DAMAGE_INCOMING,

	HEAL = 20,

	MOVEMENT_TOP_SPEED = 30,
	MOVEMENT_ACCELERATION,
	MOVEMENT_DECELERATION,
	# Rotation?
	MOVEMENT_PROJECTILE_SPEED,
}

#region Variables
var last_movement_direction := Vector2.DOWN

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var health: HealthComponent = $HealthComponent
@onready var movement: CharacterMovementComponent = $MovementComponent
@onready var knockback: KnockbackComponent = $KnockbackComponent

var modifiers := ModifierMap.new()
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	self.add_to_group(Data.GROUP_PLAYER)
	health.on_death.connect(_on_death)
	Data.component_unlocked.connect(_on_component_unlocked)
	movement.locked.connect(_on_movement_locked)
	movement.unlocked.connect(_on_movement_unlocked)

func _process(_delta: float) -> void:
	var movement_direction = Input.get_vector("player_movement_left", "player_movement_right", "player_movement_up", "player_movement_down")
	var view_direction = Input.get_vector("player_view_left", "player_view_right", "player_view_up", "player_view_down")
	if view_direction == Vector2.ZERO:
		view_direction = movement_direction
	if not movement.currently_locked:
		if Abilities.current_active.is_null():
			_process_velocity(movement_direction)
			_process_attack(last_movement_direction)
			# TODO?
			#_process_attack(view_direction)
		_process_animation(view_direction)
	_process_velocity_deceleration()
	if Input.is_action_just_pressed("debug"):
		Scene.toggle_debug_collision_shapes()
#endregion

#region Public Functions
func on_save(data: SaveData) -> void:
	data.player_position = self.global_position

func on_load(data: SaveData) -> void:
	self.global_position = data.player_position
	hitbox.disabled = false

func on_unload() -> void:
	hitbox.disabled = true
	self.movement.stop_all_movement(MovementComponent.IGNORE_LOCK)
#endregion

#region Private Functions
func _process_velocity(movement_direction: Vector2):
	if movement_direction == Vector2.ZERO:
		return
	movement.rotate_velocity_toward(movement_direction)
	movement.accelerate(modifiers.gett(Player.Modifiers.MOVEMENT_TOP_SPEED) * modifiers.gett(Player.Modifiers.MOVEMENT_ACCELERATION))
	if Abilities.current_active.is_null():
		# The player should hold their facing direction while using an ability
		self.last_movement_direction = movement_direction

func _process_animation(direction: Vector2):
	var prefix = ""
	var animation_name = ""
	if not Abilities.current_active.is_null():
		prefix = Abilities.current_active.animation_name
		direction = last_movement_direction
	elif direction == Vector2.ZERO:
		prefix = "idle"
		direction = last_movement_direction
	else:
		prefix = "walk"
	match Math.vector4dir(direction):
		Vector2.LEFT:
			animation_name = prefix + "_left"
		Vector2.RIGHT:
			animation_name = prefix + "_right"
		Vector2.UP:
			animation_name = prefix + "_up"
		Vector2.DOWN:
			animation_name = prefix + "_down"
	if animation_name != self.sprite.animation or not self.sprite.is_playing():
		# print("Play new animation (%s)" % animation_name)
		self.sprite.play(animation_name)

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
	movement.decelerate(modifiers.gett(Player.Modifiers.MOVEMENT_TOP_SPEED) * modifiers.gett(Player.Modifiers.MOVEMENT_DECELERATION))

func _on_component_unlocked(component: CraftingComponent):
	match component.label:
		"口":
			Data.unlock_ability_slot(Ability.Category.ACTIVE, 1)
		"品":
			Data.unlock_ability_slot(Ability.Category.ACTIVE, 2)
			Data.unlock_ability_slot(Ability.Category.PASSIVE, 1)
		_:
			pass

func _on_movement_locked():
	sprite.pause()

func _on_movement_unlocked():
	sprite.play()

func _on_death():
	queue_free()
#endregion
