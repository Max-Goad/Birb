@tool
class_name Hurtbox extends Hitbox

#region Variables
@export var damage_component: DamageComponent
@export var receive_damage: bool = false
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	super._ready()
	assert(damage_component)
#endregion

#region Public Functions
func on_collision_detected(node: Node2D, velocity: Vector2) -> bool:
	print("Hurtbox: on_collision_detected")
	super.on_collision_detected(node, velocity)
	if node is Hurtbox and not node.receive_damage:
		# Hurtboxes by default do not receive damage, so
		# unless otherwise specified, ignore this collision.
		return false
	elif node is Hitbox:
		# Hitboxes that receive damage should be attached
		# to nodes instead of being the root node!
		return damage_component.apply(node.get_parent(), velocity)
	else:
		# All other types of collision objects are processed as roots
		return damage_component.apply(node, velocity)
#endregion

#region Private Functions
#endregion
