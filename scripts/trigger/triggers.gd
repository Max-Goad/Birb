class_name Triggers extends Trigger

func _ready() -> void:
	assert(self.process_mode == PROCESS_MODE_ALWAYS)

func execute():
	for trigger in get_children():
		assert(trigger is Trigger, "Non-Trigger child found under triggers")
		print("Triggers: execute trigger %s" % trigger.name)
		await trigger.execute()
