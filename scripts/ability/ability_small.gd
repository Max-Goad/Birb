class_name Small extends Ability

### Variables
var scale_modifier: float
var damage_incoming_modifier: float
var player: Player

### Signals

### Engine Functions
func _init(scale_modifier: float, damage_incoming_modifier: float) -> void:
	super._init()
	self.info = Data.components_by_name["小"]
	self.scale_modifier = scale_modifier
	self.damage_incoming_modifier = damage_incoming_modifier

### Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER) as Player
	# TODO: Change this to a modifier
	player.scale *= scale_modifier
	player.modifiers.add("damage_incoming", self, damage_incoming_modifier)
	# TODO: This kinda sucks
	player.health.damage_modifier_fn = player.modifiers.gett.bind("damage_incoming")

func on_unset():
	if player:
		# TODO: Change this to a modifier
		player.scale /= scale_modifier
		player.modifiers.remove("damage_incoming", self)
		player.health.damage_modifier_fn = Callable()

### Private Functions
