extends Button

#region Variables
const textbox_preload = preload("res://resources/ui/textbox.tscn")

@export var timeout: float = 1
@export var cancellable: bool = true
#endregion

#region Signals
#endregion

#region Engine Functions
func _pressed():
	var textbox: Textbox = textbox_preload.instantiate()
	textbox.text = "This is a (%s) textbox" % self.name
	textbox.timeout_override = timeout
	textbox.cancellable = cancellable
	get_tree().current_scene.add_child(textbox)
	textbox.start()
	await textbox.complete
#endregion


#region Public Functions
#endregion

#region Private Functions
#endregion

