extends Control

#region Variables
@onready var new_game_button: Button = %"New Game Button"
@onready var load_game_button: Button = %"Load Game Button"
@onready var mystery_button: Button = %"Mystery Button"
@onready var settings_button: Button = %"Settings Button"
@onready var quit_button: Button = %"Quit Button"

@onready var save_menu: SaveMenu = %"Save Menu"
@onready var settings_menu: Settings = %"Settings Menu"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_button)
	load_game_button.pressed.connect(_on_load_game_button)
	mystery_button.pressed.connect(_on_mystery_button)
	settings_button.pressed.connect(_on_settings_button)
	quit_button.pressed.connect(_on_quit_button)

	# No point to having a save button in the main menu
	save_menu.save_button.hide()
	save_menu.load_requested.connect(_on_load_requested)
	save_menu.delete_requested.connect(_on_delete_requested)

	save_menu.close_requested.connect(_on_save_menu_closed)
	settings_menu.close_requested.connect(_on_settings_menu_closed)
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_new_game_button():
	_start_game()

func _on_load_game_button():
	save_menu.show()

func _on_mystery_button():
	# TODO
	# Scene.push_scene("")
	pass

func _on_settings_button():
	settings_menu.show()

func _on_quit_button():
	Scene.pop_scene()

func _start_game():
	Scene.push_scene("res://resources/scenes/gameplay.tscn")

func _on_load_requested(slot: int):
	# Don't load the file now, because the gameplay scene isn't active.
	# Instead, save the slot number and launch the gameplay scene.
	if Data.save_exists(slot):
		Data.save_slot_to_load = slot
	_start_game()

func _on_delete_requested(slot: int):
	Data.erase_file(slot)
	save_menu.refresh_save_slot_data()
func _on_save_menu_closed():
	save_menu.hide()

func _on_settings_menu_closed():
	settings_menu.hide()
#endregion
