class_name Medicine extends Ability

#region Variables
var amount: int
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(amount: int) -> void:
	super._init()
	self.info = Data.components_by_name["薬"]
	self.animation_name = "idle"
	self.cooldown = 10.0
	self.amount = amount
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var health := _find_health_component(parent)
	assert(health)
	health.heal(int(amount * parent.modifiers.gett("heal")))
	finished.emit()
#endregion

#region Private Functions
func _find_health_component(parent: Player) -> HealthComponent:
	for child in parent.get_children():
		if child is HealthComponent:
			return child
	return null
#endregion
