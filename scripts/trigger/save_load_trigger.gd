class_name SaveLoadTrigger extends Trigger

enum Type {	SAVE, LOAD }

@export var type := Type.SAVE
@export var slot := 0
@export var deferred := false

func execute():
	match type:
		Type.SAVE:
			if deferred:
				Data.save_file.call_deferred(slot)
			else:
				Data.save_file(slot)
		Type.LOAD:
			if deferred:
				Data.load_file.call_deferred(slot)
			else:
				Data.load_file(slot)
