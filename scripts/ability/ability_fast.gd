class_name Fast extends Ability

#region Variables
var multiplier: float
var effect_time: float

var player: Player
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(multiplier, effect_time) -> void:
	super._init()
	self.info = Data.components_by_name["早"]
	self.animation_name = "idle"
	self.cooldown = 10.0

	self.multiplier = multiplier
	self.effect_time = effect_time
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	self.player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	player.modifiers.add(Player.Modifiers.MOVEMENT_TOP_SPEED, self, multiplier)
	player.modifiers.add(Player.Modifiers.MOVEMENT_ACCELERATION, self, multiplier)
	player.modifiers.add(Player.Modifiers.MOVEMENT_DECELERATION, self, multiplier)
	player.modifiers.add(Player.Modifiers.MOVEMENT_PROJECTILE_SPEED, self, multiplier)

	var effect_timer = Timer.new()
	effect_timer.one_shot = true
	effect_timer.timeout.connect(_reset_multiplier)
	player.add_child(effect_timer)
	effect_timer.start(effect_time)

	finished.emit()
#endregion

#region Private Functions
func _reset_multiplier():
	if player:
		player.modifiers.remove(Player.Modifiers.MOVEMENT_TOP_SPEED, self)
		player.modifiers.remove(Player.Modifiers.MOVEMENT_ACCELERATION, self)
		player.modifiers.remove(Player.Modifiers.MOVEMENT_DECELERATION, self)
		player.modifiers.remove(Player.Modifiers.MOVEMENT_PROJECTILE_SPEED, self)
#endregion
