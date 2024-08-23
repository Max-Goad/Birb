class_name DamagingMovementReactor extends MovementReactor

#region Variables
var damage: DamageComponent
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	super._ready()
	assert(damage)
	if not damage.is_inside_tree():
		add_child(damage)
	self.threshold_exceeded.connect(_on_threshold_exceeded)
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_threshold_exceeded(amount: float, threshold: float):
	damage.amount = int(damage.amount * (amount / threshold))
	damage.apply(character, Vector2.ZERO)
#endregion
