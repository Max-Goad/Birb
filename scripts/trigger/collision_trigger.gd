@tool
extends Trigger

enum Type { SHAPE, POLYGON }

@export var type: Type :
	set(value):
		type = value
		collision_shape = null
		collision_polygon = null
		notify_property_list_changed()
@export var collision_shape: CollisionShape2D
@export var collision_polygon: CollisionPolygon2D
@export var disabled := true

func execute():
	if collision_shape:
		collision_shape.disabled = disabled
	if collision_polygon:
		collision_polygon.disabled = disabled

func _validate_property(property: Dictionary) -> void:
	if property.name == "collision_shape" and type != Type.SHAPE:
		property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "collision_polygon" and type != Type.POLYGON:
		property.usage &= ~PROPERTY_USAGE_EDITOR
