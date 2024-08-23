@tool
## There's no easy way to ignore certain parts of a
## Node2D's parent's transform, so we have to override
## the parts of the transform that we don't want to take.
## This class helps us do this in a simple, reusable way.
class_name IgnoreParentTransform extends Node

var node: Node2D = null
@export var ignore_position = false
@export var ignore_rotation = false
@export var ignore_scale = false
@export var offset = false :
	set(value):
		offset = value
		notify_property_list_changed()
@export_group("Offset Parameters")
@export var offset_nodes: Array[Node] = []
@export var offset_position = Vector2.ZERO
@export var offset_rotation = 0.0
@export var offset_scale = Vector2.ZERO


func _ready() -> void:
	node = get_parent()

func _process(_delta: float) -> void:
	if ignore_position:
		if offset:
			node.global_position = offset_position
		else:
			node.global_position = Vector2.ZERO
	if ignore_rotation:
		if offset:
			node.global_rotation = offset_rotation
		else:
			node.global_rotation = 0.0
	if ignore_scale:
		if offset:
			node.global_scale = offset_scale
		else:
			node.global_scale = Vector2.ZERO

func _validate_property(property: Dictionary) -> void:
	if not offset:
		print(property.name)
		if property.name.contains("offset_"):
			property.usage &= ~PROPERTY_USAGE_EDITOR
