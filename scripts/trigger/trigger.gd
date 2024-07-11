class_name Trigger extends Node

func execute():
	assert(false, "call to base Trigger.execute() in invalid")

class Basic:
	const change_scene = preload("res://scripts/trigger/change_scene_trigger.gd")
	const textbox: Script = preload("res://scripts/trigger/textbox_trigger.gd")
	const store_node_data = preload("res://scripts/trigger/store_node_data_trigger.gd")
