@tool
class_name SaveMenu extends PanelContainer

const SAVE_POPUP_TEMPLATE = preload("res://resources/ui/save_popup.tscn")
const LOAD_POPUP_TEMPLATE = preload("res://resources/ui/load_popup.tscn")
const DELETE_POPUP_TEMPLATE = preload("res://resources/ui/delete_popup.tscn")

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
signal save_requested(slot, save_name)
signal load_requested(slot)
signal delete_requested(slot)
signal close_requested
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	save_button.pressed.connect(_on_save_button)
	load_button.pressed.connect(_on_load_button)
	delete_button.pressed.connect(_on_delete_button)
	exit_button.pressed.connect(_on_exit_button)

	for i in save_slots.size():
		var save_slot = save_slots[i]
		save_slot.set_slot(i)
		save_slot.selected.connect(set_selected_slot.bind(i))
	refresh_save_slot_data()
#endregion

#region Public Functions
func set_selected_slot(index: int):
	currently_selected_slot = index
	for i in save_slots.size():
		var save_slot = save_slots[i]
		if i == index:
			save_slot.mark_as_selected()
		else:
			save_slot.mark_as_deselected()

func refresh_save_slot_data():
	for i in save_slots.size():
		var save_slot = save_slots[i]
		if Data.save_exists(i):
			save_slot.apply_data(Data.get_save_data(i))
		else:
			save_slot.reset_to_empty()
#endregion

#region Private Functions
func _on_save_button():
	if currently_selected_slot == NO_SLOT_SELECTED:
		return
	var save_popup = SAVE_POPUP_TEMPLATE.instantiate()
	save_popup.confirm_requested.connect(_on_save_popup_confirm.bind(save_popup))
	save_popup.cancel_requested.connect(_on_save_popup_cancel.bind(save_popup))
	Data.get_canvas().add_child(save_popup)
	if Data.save_exists(currently_selected_slot):
		save_popup.set_input_text(Data.get_save_data(currently_selected_slot).save_name)

func _on_load_button():
	if currently_selected_slot == NO_SLOT_SELECTED:
		return
	if not Data.save_exists(currently_selected_slot):
		return
	var load_popup = LOAD_POPUP_TEMPLATE.instantiate()
	load_popup.confirm_requested.connect(_on_load_popup_confirm.bind(load_popup))
	load_popup.cancel_requested.connect(_on_load_popup_cancel.bind(load_popup))
	Data.get_canvas().add_child(load_popup)
	load_popup.set_save_slot(currently_selected_slot, Data.get_save_data(currently_selected_slot).save_name)

func _on_delete_button():
	if currently_selected_slot == NO_SLOT_SELECTED:
		return
	if not Data.save_exists(currently_selected_slot):
		return
	var delete_popup = DELETE_POPUP_TEMPLATE.instantiate()
	delete_popup.confirm_requested.connect(_on_delete_popup_confirm.bind(delete_popup))
	delete_popup.cancel_requested.connect(_on_delete_popup_cancel.bind(delete_popup))
	Data.get_canvas().add_child(delete_popup)
	delete_popup.set_save_slot(currently_selected_slot, Data.get_save_data(currently_selected_slot).save_name)


func _on_exit_button():
	# TODO: Should there be any warnings?
	close_requested.emit()

func _on_save_popup_confirm(save_file_name: String, save_popup: SavePopup):
	var save_name = save_file_name
	if save_name.length() > Data.MAX_SAVE_NAME_SIZE:
		save_popup.set_error("Name Too Long")
	elif not save_name:
		save_popup.set_error("Name Too Short")
	else:
		save_requested.emit(currently_selected_slot, save_file_name)
		_free_popup(save_popup)

func _on_save_popup_cancel(save_popup: SavePopup):
	_free_popup(save_popup)

func _on_load_popup_confirm(load_popup: LoadPopup):
	load_requested.emit(currently_selected_slot)
	_free_popup(load_popup)

func _on_load_popup_cancel(load_popup: LoadPopup):
	_free_popup(load_popup)

func _on_delete_popup_confirm(delete_popup: DeletePopup):
	delete_requested.emit(currently_selected_slot)
	_free_popup(delete_popup)

func _on_delete_popup_cancel(delete_popup: DeletePopup):
	_free_popup(delete_popup)

func _free_popup(popup):
	popup.get_parent().remove_child(popup)
	popup.queue_free()
	set_selected_slot(NO_SLOT_SELECTED)
#endregion
