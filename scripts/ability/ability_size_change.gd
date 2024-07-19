class_name SizeChange extends Ability

### Variables
var scale_multiplier: float
var damage_multiplier: float
var player: Player

### Signals

### Engine Functions
func _init(component_label: String, scale_multiplier: float, damage_multiplier: float) -> void:
	super._init()
	self.info = Data.components_by_name[component_label]
	self.scale_multiplier = scale_multiplier
	self.damage_multiplier = damage_multiplier

### Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER) as Player
	# TODO: Change this to a modifier
	player.scale *= scale_multiplier
	player.modifiers.add("damage", self, damage_multiplier)

func on_unset():
	if player:
		# TODO: Change this to a modifier
		player.scale /= self.scale_multiplier
		player.modifiers.remove("damage", self)

### Private Functions
