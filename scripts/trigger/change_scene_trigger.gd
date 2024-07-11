class_name ChangeSceneTrigger extends Trigger

@export var action = Scene.Action.PUSH
@export var scene: PackedScene

@warning_ignore("shadowed_variable")
static func new_node(action: Scene.Action, scene: PackedScene) -> ChangeSceneTrigger:
	var node = Node.new()
	node.set_script(Trigger.Basic.change_scene)
	var change_scene_trigger = node as ChangeSceneTrigger
	change_scene_trigger.action = action
	change_scene_trigger.scene = scene
	return change_scene_trigger

func execute():
	match action:
		Scene.Action.PUSH:
			Scene.push_scene(scene.resource_path)
		Scene.Action.POP:
			Scene.pop_scene()
		Scene.Action.CHANGE:
			Scene.change_scene(scene.resource_path)

