class_name Legs extends Ability

### Variables
var multiplier: float
var player: Player

### Signals

### Engine Functions
func _init(multiplier: float) -> void:
	super._init()
	self.info = Data.components_by_name["儿"]
	self.multiplier = multiplier

### Public Functions
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

### Private Functions
