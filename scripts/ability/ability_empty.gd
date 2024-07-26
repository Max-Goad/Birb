class_name Empty extends Ability

#region Variables
var speed_modifier: float
var drain_frequency: float
var player: Player

var buff_active = false
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(speed_modifier: float, drain_frequency: float = 1.0) -> void:
	super._init()
	self.info = Data.components_by_name["空"]
	self.speed_modifier = speed_modifier
	self.drain_frequency = drain_frequency
#endregion

#region Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	Abilities.ability_set.connect(_recheck_buff.unbind(3))
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER) as Player
	if _no_attacks() and not buff_active:
		_apply_buff()

func on_unset():
	Abilities.ability_set.disconnect(_recheck_buff.unbind(3))
	if buff_active:
		_remove_buff()
#endregion

#region Private Functions
func _no_attacks():
	var is_not_attack = func(a: Ability): return a.info.type != CraftingComponent.Type.ATTACK
	return Abilities.get_abilities(Ability.Category.ACTIVE).all(is_not_attack)

func _recheck_buff():
	if _no_attacks():
		if not buff_active:
			_apply_buff()
	else:
		if buff_active:
			_remove_buff()

func _apply_buff():
	player.modifiers.add(Player.Modifiers.MOVEMENT_TOP_SPEED, self, speed_modifier)
	buff_active = true

func _remove_buff():
	if player:
		player.modifiers.remove(Player.Modifiers.MOVEMENT_TOP_SPEED, self)
		buff_active = false


#endregion
