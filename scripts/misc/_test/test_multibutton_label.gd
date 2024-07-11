extends Label

### Variables
@export var multi_button: MultiButton

### Engine Functions
func _ready() -> void:
	multi_button.pressed.connect(func(type): self.text = MultiButton.to_str(type))
