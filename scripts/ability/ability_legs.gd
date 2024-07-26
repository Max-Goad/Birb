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
	player.modifiers.add("movement_top_speed", self, multiplier)
	player.modifiers.add("movement_acceleration", self, multiplier)
	player.modifiers.add("movement_deceleration", self, multiplier)

func on_unset():
	if player:
		player.modifiers.remove("movement_top_speed", self)
		player.modifiers.remove("movement_acceleration", self)
		player.modifiers.remove("movement_deceleration", self)
#endregion

#region Private Functions
#endregion
