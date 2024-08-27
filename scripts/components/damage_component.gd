class_name DamageComponent extends Node

#region Variables
@export var enabled = true
## Sets whether the damage component should indicate to its caller
## that a collision with a disabled DamageComponent should still count
@export var disabled_collision = true

@export_range(0,100) var amount: int
@export_group("Knockback")
@export var knockback_degree: KnockbackComponent.Degree
@export var knockback_style: KnockbackComponent.Style
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	pass
#endregion

#region Public Functions
func set_enabled(value = true):
	print("DamageComponent: set enabled (%s)" % value)
	enabled = value

# Return value is whether the damage was applied or not
# If not, it indicates that the damage should be "ignored"
# and not considered in the caller's equations
func apply(node: Node2D, vector: Vector2) -> bool:
	if not enabled:
		return disabled_collision
	print("DamageComponent: %s -> %s" % [self.get_parent().name, node.name])
	var health_component := _find_health_component(node)
	if not health_component:
		print("DamageComponent: can't find health component")
		return false
	var kb_data = _knockback_data(vector.normalized())
	return health_component.damage(amount, kb_data)
#endregion

#region Private Functions
func _find_health_component(parent: Node2D) -> HealthComponent:
	for child in parent.get_children():
		if child is HealthComponent:
			return child
	return null

func _knockback_data(vector: Vector2) -> KnockbackComponent.KBData:
	var data = KnockbackComponent.KBData.new()
	data.degree = knockback_degree
	data.style = knockback_style
	data.vector = vector
	return data
#endregion
