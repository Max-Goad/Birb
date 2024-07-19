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
	player.speed.apply_multiplier(self, self.multiplier)

func on_unset():
	if player:
		player.speed.remove_multiplier(self)

### Private Functions
