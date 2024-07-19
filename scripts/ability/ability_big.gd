class_name Big extends Ability

### Variables
var scale_modifier: float
var damage_modifier: float
var player: Player

### Signals

### Engine Functions
func _init(scale_modifier: float, damage_modifier: float) -> void:
	super._init()
	self.info = Data.components_by_name["大"]
	self.scale_modifier = scale_modifier
	self.damage_modifier = damage_modifier

### Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER) as Player
	# TODO: Change this to a modifier
	player.scale *= scale_modifier
	player.modifiers.add("damage", self, damage_modifier)

func on_unset():
	if player:
		# TODO: Change this to a modifier
		player.scale /= self.scale_modifier
		player.modifiers.remove("damage", self)

### Private Functions
