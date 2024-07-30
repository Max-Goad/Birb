@tool
extends Node2D

#region Variables
@export var health_component: HealthComponent
@export var hide_when_full: bool = false
@export var hide_when_empty: bool = true
@export var offset: Vector2 :
	set(value):
		offset = value
		if health_bar:
			health_bar.position = offset

@onready var health_bar: ProgressBar = $"Health Bar"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	assert(health_component != null, "missing health component")
	health_bar.max_value = health_component.max_hp
	health_bar.value = health_component.current_hp
	health_component.on_damage.connect(_on_health_damage)
	health_component.on_heal.connect(_on_health_heal)
	_setup_transform()
	_update_visibility()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_health_damage(amount: int, _type: DamageComponent.DamageType, _direction: Vector2):
	health_bar.change_value(-amount)
	_update_visibility()

func _on_health_heal(amount: int):
	health_bar.change_value(amount)
	_update_visibility()

# Godot is very strange when it comes to keeping an element
# in place relative to its parent while ignoring rotation.
# My custom solution is to "unlink" the child,
# and then remotely push only the position and scale.
# The "offset" value is also relevant for this.
# It's far from a perfect solution, but it is good enough!
func _setup_transform():
	top_level = true
	var remote_transform = RemoteTransform2D.new()
	remote_transform.remote_path = get_path()
	remote_transform.update_rotation = false
	get_parent().add_child.call_deferred(remote_transform)

func _update_visibility():
	var full = health_component.current_hp >= health_component.max_hp
	var empty = health_component.current_hp <= 0
	print("HealthBarComponent: curr %s, max %s" % [health_component.current_hp, health_component.max_hp])
	print("HealthBarComponent: full %s, hwf %s, empty %s, hwe %s" % [full, hide_when_full, empty, hide_when_empty])
	if (full and hide_when_full) or (empty and hide_when_empty):
		self.visible = false
	else:
		self.visible = true
	health_bar.position = offset
#endregion
