extends Button

signal button_held

func _process(_delta: float) -> void:
	if self.button_pressed:
		button_held.emit()
