class_name LoadPopup extends PanelContainer

const SAVE_SLOT_NAME_TEXT_FORMAT := "Slot %d: %s"

#region Variables
@onready var save_slot_name: Label = %"Save Slot Name"
@onready var confirm_button: Button = %"Confirm Button"
@onready var cancel_button: Button = %"Cancel Button"
#endregion

#region Signals
signal confirm_requested
signal cancel_requested
#endregion

#region Engine Functions
func _ready() -> void:
	reset_save_slot()
	confirm_button.pressed.connect(_on_confirm_button)
	cancel_button.pressed.connect(_on_cancel_button)
#endregion

#region Public Functions
func set_save_slot(i: int, s: String):
	if s.is_empty():
		push_warning("LoadPopup: Attempting to set save slot name with empty string. Calling reset_save_slot() instead...")
		reset_save_slot()
		return
	save_slot_name.text = SAVE_SLOT_NAME_TEXT_FORMAT % [i, s]

func reset_save_slot():
	save_slot_name.text = ""
#endregion

#region Private Functions
func _on_confirm_button():
	confirm_requested.emit()

func _on_cancel_button():
	cancel_requested.emit()
#endregion
