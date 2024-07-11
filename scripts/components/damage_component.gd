class_name DamageComponent extends Node2D

enum DamageType {
	NORMAL = 0,
	HEAVY = 1,
}

### Variables
@export_range(0,100) var amount: int
@export var type: DamageComponent.DamageType

@export_range(0,100) var alt_amount: int
@export var alt_type: DamageComponent.DamageType

### Signals

### Engine Functions
func _ready() -> void:
	pass

### Public Functions
func apply(node: Node2D, alt = false) -> bool:
	print("apply to %s" % node.name)
	var health_component = _find_health_component(node)
	if not health_component:
		print("can't find health component")
		return false
	print("prnt pos = %s" % get_parent().position)
	print("body pos = %s" % node.position)
	var direction = node.position - get_parent().position
	if not alt:
		health_component.damage(amount, type, direction.normalized())
	else:
		health_component.damage(alt_amount, alt_type, direction.normalized())
	return true


### Private Functions
func _find_health_component(parent: Node2D) -> Node2D:
	for child in parent.get_children():
		if child is HealthComponent:
			return child
	return null

