extends Trigger

@export var label: String

func execute():
	Data.unlock_component(Data.components_by_name[label])

