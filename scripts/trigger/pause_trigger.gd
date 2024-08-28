class_name PauseTrigger extends Trigger

@export var activate_pause = true

func execute():
	get_tree().paused = activate_pause
