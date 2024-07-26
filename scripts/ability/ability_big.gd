class_name Big extends Ability

#region Variables
var scale_modifier: float
var damage_modifier: float
var player: Player
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(scale_modifier: float, damage_modifier: float) -> void:
	super._init()
	self.info = Data.components_by_name["大"]
	self.scale_modifier = scale_modifier
	self.damage_modifier = damage_modifier
#endregion

#region Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = Data.get_player()
	# TODO: Change this to a modifier
	player.scale *= scale_modifier
	player.modifiers.add(Player.Modifiers.DAMAGE, self, damage_modifier)

func on_unset():
	if player:
		# TODO: Change this to a modifier
		player.scale /= self.scale_modifier
		player.modifiers.remove(Player.Modifiers.DAMAGE, self)
#endregion

#region Private Functions
#endregion
