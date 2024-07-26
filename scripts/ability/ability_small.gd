class_name Small extends Ability

#region Variables
var scale_modifier: float
var damage_incoming_modifier: float
var player: Player
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(scale_modifier: float, damage_incoming_modifier: float) -> void:
	super._init()
	self.info = Data.components_by_name["小"]
	self.scale_modifier = scale_modifier
	self.damage_incoming_modifier = damage_incoming_modifier
#endregion

#region Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER) as Player
	# TODO: Change this to a modifier
	player.scale *= scale_modifier
	player.modifiers.add(Player.Modifiers.DAMAGE_INCOMING, self, damage_incoming_modifier)
	# TODO: This kinda sucks
	player.health.damage_modifier_fn = player.modifiers.gett.bind(Player.Modifiers.DAMAGE_INCOMING)

func on_unset():
	if player:
		# TODO: Change this to a modifier
		player.scale /= scale_modifier
		player.modifiers.remove(Player.Modifiers.DAMAGE_INCOMING, self)
		player.health.damage_modifier_fn = Callable()
#endregion

#region Private Functions
#endregion
