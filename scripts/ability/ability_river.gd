class_name River extends Ability

#region Variables
var knockback_force: float
var stun_time: float
var knockback_direction = Vector2.UP
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(knockback_force, stun_time) -> void:
	super._init()
	self.info = Data.components_by_name["川"]
	self.animation_name = "idle"
	self.cooldown = 3.0

	self.knockback_force = knockback_force
	self.stun_time = stun_time
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var knockback_direction = _next_direction()
	for enemy: Enemy in Data.get_enemies():
		if enemy.knockback:
			enemy.knockback.apply_knockback(knockback_direction, knockback_force, stun_time)
	# Player should be affected less
	var player = Data.get_player()
	player.knockback.apply_knockback(knockback_direction, knockback_force / 4)
	finished.emit()
#endregion

#region Private Functions
func _next_direction() -> Vector2:
	knockback_direction = knockback_direction.rotated(PI/2 * randi_range(0,3))
	return knockback_direction
#endregion
