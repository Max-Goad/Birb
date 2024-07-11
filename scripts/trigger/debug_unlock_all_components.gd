extends Trigger

func execute():
	for component in Data.components_by_id.values():
		if not Data.is_component_unlocked(component.id):
			Data.unlock_component(component)

