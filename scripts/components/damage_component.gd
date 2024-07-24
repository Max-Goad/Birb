class_name DamageComponent extends Node2D

enum DamageType {
	NORMAL = 0,
	HEAVY = 1,
}

### Variables

@export var enabled = true
## Sets whether the damage component should indicate to its caller
## that a collision with a disabled DamageComponent should still count
@export var disabled_collision = true

@export_range(0,100) var amount: int
@export var type: DamageComponent.DamageType

@export_range(0,100) var alt_amount: int
@export var alt_type: DamageComponent.DamageType

### Signals

### Engine Functions
func _ready() -> void:
	pass

### Public Functions
func set_enabled(value):
	print("DamageComponent: set enabled (%s)" % value)
	enabled = value

# Return value is whether the damage was applied or not
# If not, it indicates that the damage should be "ignored"
# and not considered in the caller's equations
func apply(node: Node2D, alt = false) -> bool:
	if not enabled:
		return disabled_collision
	print("DamageComponent: %s -> %s" % [self.get_parent().name, node.name])
	var health_component = _find_health_component(node)
	if not health_component:
		print("DamageComponent: can't find health component")
		return false
	print("DamageComponent: prnt pos = %s" % get_parent().position)
	print("DamageComponent: body pos = %s" % node.position)
	var direction = node.position - get_parent().position
	if not alt:
		return health_component.damage(amount, type, direction.normalized())
	else:
		return health_component.damage(alt_amount, alt_type, direction.normalized())


### Private Functions
func _find_health_component(parent: Node2D) -> Node2D:
	for child in parent.get_children():
		if child is HealthComponent:
			return child
	return null

