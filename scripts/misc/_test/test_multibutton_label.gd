extends Label

@export var multi_button: MultiButton

func _ready() -> void:
	multi_button.pressed.connect(func(type): self.text = MultiButton.to_str(type))
