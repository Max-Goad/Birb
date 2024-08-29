class_name SaveInputBox extends PanelContainer

const ERROR_TEXT_FORMAT := "Error: %s"

#region Variables
@onready var input_text: TextEdit = %"Input Text"
@onready var error_text: Label = %"Error Text"
@onready var confirm_button: Button = %"Confirm Button"
@onready var cancel_button: Button = %"Cancel Button"
#endregion

#region Signals
signal confirm_requested(text)
signal cancel_requested
#endregion

#region Engine Functions
func _ready() -> void:
	reset_input_text()
	reset_error()
	confirm_button.pressed.connect(_on_confirm_button)
	cancel_button.pressed.connect(_on_cancel_button)
#endregion

#region Public Functions
func set_input_text(s: String):
	input_text.text = s

func reset_input_text():
	input_text.text = ""

func set_error(s: String):
	if s.is_empty():
		push_warning("SaveInputBox: Attempting to set error with empty string. Calling reset_error() instead...")
		reset_error()
		return
	error_text.text = ERROR_TEXT_FORMAT % s

func reset_error():
	error_text.text = ""
#endregion

#region Private Functions
func _on_confirm_button():
	confirm_requested.emit(input_text.text)

func _on_cancel_button():
	cancel_requested.emit()
#endregion
