extends Node

### Variables
enum Action {
	PUSH = 0,
	POP = 1,
	CHANGE = 2,
}

# Scenes are stored as their file paths
var scene_stack : Array[StringName] = []

var completed_actions: Array[Action] = []
var on_push_triggers: Array[Trigger] = []
var on_pop_triggers: Array[Trigger] = []
var on_change_triggers: Array[Trigger] = []

### Public Functions
func push_scene(path: StringName):
	scene_stack.push_back(path)
	get_tree().change_scene_to_file(path)
	completed_actions.push_back(Action.PUSH)

func pop_scene():
	scene_stack.pop_back()
	if scene_stack.size() > 0:
		get_tree().change_scene_to_file(scene_stack.back())
		completed_actions.push_back(Action.POP)
	else:
		get_tree().quit()

# Pop + Push (skipping parent scene load)
# TODO: Should a change trigger a PUSH notification?
func change_scene(path: StringName):
	scene_stack.pop_back()
	scene_stack.push_back(path)
	get_tree().change_scene_to_file(path)
	completed_actions.push_back(Action.CHANGE)

# Runs this trigger the next time a scene is pushed
# Note: The trigger is only run on the frame AFTER the push occurs
#		(The active scene will be the newly pushed scene)
func on_push(trigger: Trigger):
	if trigger.get_parent():
		trigger.reparent(self)
	else:
		add_child(trigger)
	on_push_triggers.push_back(trigger)

# Runs this trigger the next time a scene is popped
# Note: The trigger is only run on the frame AFTER the pop occurs
#		(The active scene will be the scene under the popped scene)
func on_pop(trigger: Trigger):
	if trigger.get_parent():
		trigger.reparent(self)
	else:
		add_child(trigger)
	on_pop_triggers.push_back(trigger)

# Runs this trigger the next time a scene is changed
# Note: The trigger is only run on the frame AFTER the change occurs
#		(The active scene will be the newly changed scene)
func on_change(trigger: Trigger):
	if trigger.get_parent():
		trigger.reparent(self)
	else:
		add_child(trigger)
	on_change_triggers.push_back(trigger)

### Engine Functions
func _ready() -> void:
	# The root of the scene stack should be whatever scene we start with
	scene_stack.push_back(get_tree().current_scene.scene_file_path)

func _process(_d: float) -> void:
	while not completed_actions.is_empty():
		var action = completed_actions.pop_front()
		match action:
			Action.PUSH:
				while not on_push_triggers.is_empty():
					var trigger = on_push_triggers.pop_front()
					await trigger.execute()
			Action.POP:
				while not on_pop_triggers.is_empty():
					var trigger = on_pop_triggers.pop_front()
					await trigger.execute()
			Action.CHANGE:
				while not on_change_triggers.is_empty():
					var trigger = on_change_triggers.pop_front()
					await trigger.execute()
