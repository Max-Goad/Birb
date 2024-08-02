@tool
class_name IgnoreParentTransform extends Node

@export var ignore_position = false
@export var ignore_rotation = false
@export var ignore_scale = false
@export var offset = false :
	set(value):
		offset = value
		notify_property_list_changed()
# @export_group("offsets")
@export var offset_nodes: Array[Node] = []
@export var position_offset = Vector2.ZERO
@export var rotation_offset = 0.0
@export var scale_offset = Vector2.ZERO

# Godot is very strange when it comes to keeping an element
# in place relative to its parent while ignoring rotation.
# My custom solution is to "unlink" the child,
# and then remotely push only the position and scale.
# The "offset" value is also relevant for this.
# It's far from a perfect solution, but it is good enough!
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var affected_node = get_parent()
	affected_node.top_level = true
	var remote_transform = RemoteTransform2D.new()
	remote_transform.remote_path = affected_node.get_path()
	remote_transform.update_position = not ignore_position
	remote_transform.update_rotation = not ignore_rotation
	remote_transform.update_scale = not ignore_scale
	affected_node.get_parent().add_child.call_deferred(remote_transform)

func _validate_property(property: Dictionary) -> void:
	if not offset:
		print(property.name)
		if property.name in {"offset_nodes":0, "position_offset":0, "rotation_offset":0, "scale_offset":0}:
			property.usage &= ~PROPERTY_USAGE_EDITOR
