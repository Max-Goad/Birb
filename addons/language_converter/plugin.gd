@tool
extends EditorPlugin

var dock

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	dock = preload("res://addons/language_converter/dock.tscn").instantiate()

	# Add the loaded scene to the docks.
	add_control_to_bottom_panel(dock, "Language")
	# Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_bottom_panel(dock)
	# Erase the control from the memory.
	dock.free()
