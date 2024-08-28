class_name SaveLoadTrigger extends Trigger

enum Type {	SAVE, LOAD }

@export var type := Type.SAVE
@export var slot := 0

func execute():
	match type:
		Type.SAVE:
			Data.save_file.call_deferred(slot)
		Type.LOAD:
			Data.load_file.call_deferred(slot)
