@tool
class_name Spawner extends Node2D

enum Behavior
{
	LOCATION,
	RADIUS,
}

#region Variables
@export_category("Enemy Settings")
@export var template: PackedScene
@export var target: Node2D

@export_category("Spawner Settings")
@export var autostart: bool = true
@export var unlimited: bool = false :
	set(value):
		unlimited = value
		notify_property_list_changed()
@export var maximum: int = 1
@export var rate: float = 1.0

@export var behavior: Behavior = Behavior.LOCATION :
	set(value):
		behavior = value
		notify_property_list_changed()
@export var location: Vector2 = Vector2.ZERO
@export var radius: float = 1.0

var timer: Timer
var spawned_enemies: Array[Enemy] = []
var spawn_callbacks: Dictionary = {}
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready():
	if Engine.is_editor_hint():
		return
	self.add_to_group(Data.GROUP_SPAWNER)
	timer = Timer.new()
	timer.timeout.connect(spawn_enemy)
	add_child(timer)
	if autostart and should_spawn_enemy():
		start()

func _validate_property(property: Dictionary):
	if ((property.name == "maximum" and unlimited)
	 or (property.name == "location" and behavior != Behavior.LOCATION)
	 or (property.name == "radius" and behavior != Behavior.RADIUS)
	):
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion

#region Public Functions
func start():
	print("Spawner: start")
	timer.start(1.0 / rate)

func stop():
	print("Spawner: stop")
	timer.stop()

func should_spawn_enemy() -> bool:
	return unlimited or (spawned_enemies.size() < maximum)

func spawn_enemy():
	print("Spawner: spawn enemy")
	var enemy = template.instantiate()
	_prepare_spawned_enemy(enemy)
	add_child(enemy)
	spawned_enemies.push_back(enemy)
	for callback: Callable in spawn_callbacks.values():
		callback.call(enemy)
	if not should_spawn_enemy():
		stop()

func connect_on_spawn(key: Object, callback: Callable):
	assert(key not in spawn_callbacks)
	print("Spawner: connected on spawn callback")
	spawn_callbacks[key] = callback
	for enemy in spawned_enemies:
		callback.call(enemy)

func disconnect_on_spawn(key: Object, reset_fn: Callable = func(_e): pass):
	if key not in spawn_callbacks:
		return
	print("Spawner: disconnected on spawn callback")
	spawn_callbacks.erase(key)
	for enemy in spawned_enemies:
		reset_fn.call(enemy)
#endregion

#region Private Functions
func _prepare_spawned_enemy(enemy: Enemy):
	if behavior == Behavior.LOCATION:
		enemy.position = location
	elif behavior == Behavior.RADIUS:
		enemy.position = Vector2(randf_range(radius/4, radius), 0).rotated(randf_range(0, PI))
	enemy.target = target
	enemy.dead.connect(_on_enemy_death.bind(enemy))

func _on_enemy_death(enemy: Enemy):
	spawned_enemies.erase(enemy)
#endregion
