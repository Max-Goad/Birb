class_name IgnoreParentRotation extends Node

# Godot is very strange when it comes to keeping an element
# in place relative to its parent while ignoring rotation.
# My custom solution is to "unlink" the child,
# and then remotely push only the position and scale.
# The "offset" value is also relevant for this.
# It's far from a perfect solution, but it is good enough!
func _ready() -> void:
	var affected_node = get_parent()
	affected_node.top_level = true
	var remote_transform = RemoteTransform2D.new()
	remote_transform.remote_path = affected_node.get_path()
	remote_transform.update_rotation = false
	affected_node.get_parent().add_child.call_deferred(remote_transform)
