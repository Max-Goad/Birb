class_name Legs extends Ability

#region Variables
var multiplier: float
var player: Player
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(multiplier: float) -> void:
	super._init()
	self.info = Data.components_by_name["儿"]
	self.multiplier = multiplier
#endregion

#region Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	player.modifiers.add(Player.Modifiers.MOVEMENT_TOP_SPEED, self, multiplier)
	player.modifiers.add(Player.Modifiers.MOVEMENT_ACCELERATION, self, multiplier)
	player.modifiers.add(Player.Modifiers.MOVEMENT_DECELERATION, self, multiplier)

func on_unset():
	if player:
		player.modifiers.remove(Player.Modifiers.MOVEMENT_TOP_SPEED, self)
		player.modifiers.remove(Player.Modifiers.MOVEMENT_ACCELERATION, self)
		player.modifiers.remove(Player.Modifiers.MOVEMENT_DECELERATION, self)
#endregion

#region Private Functions
#endregion
