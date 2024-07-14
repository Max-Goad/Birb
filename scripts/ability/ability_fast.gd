class_name Fast extends Ability

### Variables
var multiplier = 1.2

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
	var player: Player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	# TODO: Should this be a component?
	player.top_speed *= self.multiplier
	player.acceleration *= self.multiplier

func on_unset():
	print("fast unset")
	var player: Player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	# TODO: Should this be a component?
	player.top_speed /= self.multiplier
	player.acceleration /= self.multiplier

### Private Functions
