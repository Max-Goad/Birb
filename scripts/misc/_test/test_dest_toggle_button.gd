extends Button

@export var destination: Destination

func _toggled(t: bool) -> void:
	destination.selectable = t
