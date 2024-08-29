extends Control

#region Variables
@onready var play_button: Button = %"Play Button"
@onready var mystery_button: Button = %"Mystery Button"
@onready var save_button: Button = %"Save Button"
@onready var settings_button: Button = %"Settings Button"
@onready var quit_button: Button = %"Quit Button"

@onready var save_menu: SaveMenu = %"Save Menu"
@onready var settings_menu: Settings = %"Settings Menu"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	play_button.pressed.connect(_on_play_button)
	mystery_button.pressed.connect(_on_mystery_button)
	save_button.pressed.connect(_on_save_button)
	settings_button.pressed.connect(_on_settings_button)
	quit_button.pressed.connect(_on_quit_button)

	save_menu.close_requested.connect(_on_save_menu_closed)
	settings_menu.close_requested.connect(_on_settings_menu_closed)
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_play_button():
	Scene.push_scene("res://resources/scenes/gameplay.tscn")

func _on_mystery_button():
	# TODO
	# Scene.push_scene("")
	pass

func _on_save_button():
	save_menu.show()
	pass

func _on_settings_button():
	settings_menu.show()

func _on_quit_button():
	Scene.pop_scene()

func _on_save_menu_closed():
	save_menu.hide()

func _on_settings_menu_closed():
	settings_menu.hide()
#endregion
