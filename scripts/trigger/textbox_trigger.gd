class_name TextboxTrigger extends Trigger

@export_multiline var text: String = ""
@export_range(0.0, 10.0) var timeout: float = 0.0
@export var settings: LabelSettings
@export var text_speed: float = 0.0
@export var canvas: CanvasLayer = null

const textbox_scene = preload("res://resources/ui/textbox.tscn")

@warning_ignore("shadowed_variable")
static func new_node(text = "", timeout = 0.0, settings = null, text_speed = 0.0) -> TextboxTrigger:
	var tt = Node.new()
	tt.set_script(Trigger.Basic.textbox)
	var textbox_trigger = tt as TextboxTrigger
	textbox_trigger.text = text
	textbox_trigger.timeout = timeout
	textbox_trigger.settings = settings
	textbox_trigger.text_speed = text_speed
	return textbox_trigger

func execute():
	var textbox: Textbox = textbox_scene.instantiate()
	textbox.text = text
	textbox.timeout = timeout
	textbox.settings = settings
	textbox.text_speed = text_speed
	if canvas == null:
		get_tree().current_scene.add_child(textbox)
	else:
		canvas.add_child(textbox)
	textbox.start()
	await textbox.complete
