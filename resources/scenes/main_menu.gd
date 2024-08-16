extends Control

#region Variables
@onready var play_button: Button = $"Menu/MarginContainer/VBoxContainer/Play Button"
@onready var mystery_button: Button = $"Menu/MarginContainer/VBoxContainer/Mystery Button"
@onready var data_button: Button = $"Menu/MarginContainer/VBoxContainer/Data Button"
@onready var settings_button: Button = $"Menu/MarginContainer/VBoxContainer/Settings Button"
@onready var quit_button: Button = $"Menu/MarginContainer/VBoxContainer/Quit Button"

@onready var settings_menu: Settings = $"Settings Menu"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	play_button.pressed.connect(_on_play_button)
	mystery_button.pressed.connect(_on_mystery_button)
	data_button.pressed.connect(_on_data_button)
	settings_button.pressed.connect(_on_settings_button)
	quit_button.pressed.connect(_on_quit_button)

	settings_menu.closed.connect(_on_settings_menu_closed)
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

func _on_data_button():
	# TODO
	# Scene.push_scene("")
	pass

func _on_settings_button():
	settings_menu.show()

func _on_quit_button():
	Scene.pop_scene()

func _on_settings_menu_closed():
	settings_menu.hide()
#endregion

