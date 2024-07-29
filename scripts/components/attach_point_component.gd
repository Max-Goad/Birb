class_name AttachPointComponent extends Node2D


#region Variables
var default: Node2D = get_parent()
@export var center: Node2D :
	get: return _get_with_default(center)
@export var head: Node2D :
	get: return _get_with_default(head)
#endregion

#region Signals
#endregion

#region Engine Functions
#endregion

#region Public Functions
#endregion

#region Private Functions
func _get_with_default(node: Node2D) -> Node2D:
	if node:
		return node
	else:
		return default
#endregion

