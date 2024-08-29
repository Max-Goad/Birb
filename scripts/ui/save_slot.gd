class_name SaveSlot extends PanelContainer

#region Variables
@export var slot := -1
@export var title_prefix := "Save Slot"

@onready var selected_icon: Label = %"Selected Icon"
@onready var slot_title: Label = %"Slot Title"
@onready var slot_name: Label = %"Slot Name"

var current_color := Color.WHITE
#endregion

#region Signals
signal selected
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	mark_as_deselected()
	mouse_entered.connect(_highlight)
	mouse_exited.connect(_reset_highlight)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			selected.emit()
#endregion

#region Public Functions
func set_slot(i: int):
	slot_title.text = "%s %d" % [title_prefix, i + 1]

func mark_as_selected():
	selected_icon.text = "X"

func mark_as_deselected():
	selected_icon.text = ""
#endregion

#region Private Functions
func _highlight():
		self_modulate = self_modulate * 2

func _reset_highlight():
		self_modulate = current_color
#endregion
