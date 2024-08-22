class_name MenuController extends Node

const pl_ingame_menu = preload("res://resources/ui/ingame_menu.tscn")

#region Variables
var root: MenuRoot
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	root = pl_ingame_menu.instantiate()
	root.visible = false
	root.closed.connect(_on_menu_closed)
	add_child(root)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not root.visible:
			show_menu()
		else:
			hide_menu()

#endregion

#region Public Functions
func show_menu():
	root.visible = true
	get_tree().paused = true

func hide_menu():
	root.visible = false
	get_tree().paused = false
#endregion

#region Private Functions
func _on_menu_closed():
	if root.visible:
		hide_menu()
#endregion
