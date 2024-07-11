extends Button

enum Mode {
	SAVE,
	LOAD,
	ERASE
}

@export var textbox: TextEdit
@export var label: Label
@export var slot: int = 0
@export var mode: Mode = Mode.SAVE

func _ready():
	if Data.saves[slot] != null:
		label.text = "YES"
	else:
		label.text =  "NO"

func _pressed() -> void:
	match mode:
		Mode.SAVE:
			if textbox.text:
				Data.test_string = textbox.text
				Data.save_file(slot, "Test")
				textbox.text = ""
		Mode.LOAD:
			textbox.text = ""
			if Data.save_exists(slot):
				Data.load_file(slot)
				textbox.text = Data.test_string
		Mode.ERASE:
			textbox.text = ""
			Data.erase_file(slot)
	if Data.saves[slot] != null:
		label.text = "YES"
	else:
		label.text =  "NO"
