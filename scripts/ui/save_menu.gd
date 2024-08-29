@tool
class_name SaveMenu extends PanelContainer

const SAVE_POPUP_TEMPLATE = preload("res://resources/ui/save_popup.tscn")
const NO_SLOT_SELECTED = -1

#region Variables
var currently_selected_slot := NO_SLOT_SELECTED

@onready var save_button: Button = %"Save Button"
@onready var load_button: Button = %"Load Button"
@onready var delete_button: Button = %"Delete Button"
@onready var exit_button: Button = %"Exit Button"
@onready var contents: PanelContainer = %Contents

@onready var save_slots: Array[SaveSlot] = [
	%"Save Slot 1", %"Save Slot 2", %"Save Slot 3"
	]
#endregion

#region Signals
signal close_requested
#endregion

#region Engine Functions
func _ready() -> void:
	save_button.pressed.connect(_on_save_button)
	load_button.pressed.connect(_on_load_button)
	delete_button.pressed.connect(_on_delete_button)
	exit_button.pressed.connect(_on_exit_button)

	for i in save_slots.size():
		var save_slot = save_slots[i]
		save_slot.set_slot(i)
		save_slot.selected.connect(_on_save_slot_selected.bind(i))
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_save_button():
	if currently_selected_slot == NO_SLOT_SELECTED:
		return
	var save_popup = SAVE_POPUP_TEMPLATE.instantiate()
	# TODO: Get the name of the save game and prefill
	save_popup.confirm_requested.connect(_on_save_popup_confirm.bind(save_popup))
	save_popup.cancel_requested.connect(_on_save_popup_cancel.bind(save_popup))
	add_sibling(save_popup)
	# open save prompt
	pass

func _on_load_button():
	# open load prompt
	pass

func _on_delete_button():
	# open delete prompt
	pass

func _on_exit_button():
	# TODO: Should there be any warnings?
	close_requested.emit()

func _on_save_slot_selected(index: int):
	currently_selected_slot = index
	for i in save_slots.size():
		var save_slot = save_slots[i]
		if i == index:
			save_slot.mark_as_selected()
		else:
			save_slot.mark_as_deselected()

func _on_save_popup_confirm(save_file_name: String, save_popup: SavePopup):
	var save_name = save_file_name
	if save_name.length() > Data.MAX_SAVE_NAME_SIZE:
		save_popup.set_error("Name Too Long")
	elif not save_name:
		save_popup.set_error("Name Too Short")
	else:
		# Save file
		save_popup.get_parent().remove_child(save_popup)
		save_popup.queue_free()

func _on_save_popup_cancel(save_popup: SavePopup):
	currently_selected_slot = NO_SLOT_SELECTED
	save_popup.get_parent().remove_child(save_popup)
	save_popup.queue_free()
#endregion
