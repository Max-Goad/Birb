class_name Fast extends Ability

### Variables
var multiplier = 1.2

var _player: Player

### Signals

### Engine Functions
func _init() -> void:
	super._init()
	self.info = Data.components_by_name["早"]

### Public Functions
func execute(_parent: Node2D, _direction: Vector2):
	pass

func on_set():
	print("fast set")
	_player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	_player.speed.apply_multiplier(self, self.multiplier)

func on_unset():
	print("fast unset")
	if _player:
		_player.speed.remove_multiplier(self)

### Private Functions
