class_name Medicine extends Ability

### Variables
var amount: int

### Signals

### Engine Functions
func _init(amount: int) -> void:
	super._init()
	self.info = Data.components_by_name["薬"]
	self.animation_name = "idle"
	self.cooldown = 10.0
	self.amount = amount

### Public Functions
func execute(parent: Node2D, direction: Vector2):
	super.execute(parent, direction)
	var health := _find_health_component(parent)
	assert(health)
	health.heal(amount)
	# If we call finish immediately, it can screw up the call ordering
	# So we use call_deferred to mimic the async behavior
	call_deferred("_finish")

### Private Functions
func _find_health_component(parent: Node2D) -> HealthComponent:
	for child in parent.get_children():
		if child is HealthComponent:
			return child
	return null

func _finish():
	self.finished.emit()
