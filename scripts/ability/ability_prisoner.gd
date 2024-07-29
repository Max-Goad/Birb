class_name Prisoner extends Ability

const PL_TARGET_RETICLE = preload("res://resources/ui/target_reticle.tscn")
const PRISONER_SPRITE = preload("res://resources/attacks/prisoner_sprite.tscn")

#region Variables
var effect_time: float
var reticle: TargetReticle
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(effect_time) -> void:
	super._init()
	self.info = Data.components_by_name["囚"]
	self.animation_name = "idle"
	self.cooldown = 1.0

	self.effect_time = effect_time
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var target: Enemy = _closest_enemy()
	if target and not target.movement.currently_locked:
		_lock_movement(target)
		_attach_sprite(target)
	finished.emit()

func on_set():
	reticle = PL_TARGET_RETICLE.instantiate()
	reticle.target_strategy = _closest_enemy_center
	add_child(reticle)

func on_unset():
	reticle.queue_free()
#endregion

#region Private Functions
func _closest_enemy() -> Enemy:
	return Data.get_closest_enemy(Data.get_player().global_position)

func _closest_enemy_center() -> Node2D:
	var closest_enemy: Enemy = _closest_enemy()
	if closest_enemy:
		return closest_enemy.attach_points.center
	else:
		return null

func _lock_movement(target: Enemy):
	var lock_movement_trigger = LockMovementTrigger.new()
	lock_movement_trigger.movement = target.movement
	lock_movement_trigger.time = effect_time
	target.add_child(lock_movement_trigger)
	lock_movement_trigger.execute()

func _attach_sprite(target: Enemy):
	var sprite = PRISONER_SPRITE.instantiate()
	target.attach_points.center.add_child(sprite)
	var detach_sprite = func(): sprite.queue_free()
	target.movement.unlocked.connect(detach_sprite)

#endregion
