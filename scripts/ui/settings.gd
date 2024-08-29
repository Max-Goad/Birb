class_name Settings extends PanelContainer

#region Variables
@onready var save_and_quit_button: Button = $"MarginContainer/VBoxContainer/Save And Quit Button"
#endregion

#region Signals
signal close_requested
#endregion

#region Engine Functions
func _ready() -> void:
	save_and_quit_button.pressed.connect(_on_save_and_quit)
#endregion

#region Public Functions
func _on_save_and_quit():
	# TODO: Save settings
	close_requested.emit()
#endregion

#region Private Functions
#endregion
