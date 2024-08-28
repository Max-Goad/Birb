extends Trigger

@export var node: Node

func _ready() -> void:
	assert(node != null)

func execute():
	node.queue_free()
