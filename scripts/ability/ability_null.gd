class_name NullAbility extends Ability

### Variables

### Signals

### Engine Functions
func _init() -> void:
	super._init()
	self.info = CraftingComponent.new()
	self.animation_name = "idle"

### Public Functions
func execute(parent: Node2D, direction: Vector2):
	super.execute(parent, direction)
	finished.emit()

func is_null() -> bool:
	return true

### Private Functions

