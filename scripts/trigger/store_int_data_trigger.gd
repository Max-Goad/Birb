extends Trigger

@export var value: int
@export var data_property_path: String

func execute():
	assert(Data.get(data_property_path) != null, "data property path is invalid")
	Data.set(data_property_path, value)
	pass
