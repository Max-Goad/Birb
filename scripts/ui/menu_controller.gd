class_name MenuController extends Node

const pl_ingame_menu = preload("res://resources/ui/ingame_menu.tscn")

### Variables
var root: MenuRoot

### Signals

### Engine Functions
func _ready() -> void:
	root = pl_ingame_menu.instantiate()
	root.visible = false
	add_child(root)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not root.visible:
			root.visible = true
			get_tree().paused = true
		else:
			root.visible = false
			get_tree().paused = false

### Public Functions

### Private Functions

