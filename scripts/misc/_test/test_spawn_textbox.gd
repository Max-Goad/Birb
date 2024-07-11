extends Button

### Variables
const textbox_preload = preload("res://resources/ui/textbox.tscn")

@export var timeout: float = 1
@export var cancellable: bool = true

### Signals

### Engine Functions
func _pressed():
	var textbox: Textbox = textbox_preload.instantiate()
	textbox.text = "This is a (%s) textbox" % self.name
	textbox.timeout_override = timeout
	textbox.cancellable = cancellable
	get_tree().current_scene.add_child(textbox)
	textbox.start()
	await textbox.complete


### Public Functions

### Private Functions

