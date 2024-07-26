class_name NullAbility extends Ability

#region Variables
#endregion

#region Signals
#endregion

#region Engine Functions
func _init() -> void:
	super._init()
	self.info = CraftingComponent.new()
	self.animation_name = "idle"
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	finished.emit()

func is_null() -> bool:
	return true
#endregion

#region Private Functions
#endregion

