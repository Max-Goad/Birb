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
	player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	player.scale *= self.scale_multiplier
	# TODO: Damage multiplication?

func on_unset():
	if player:
		player.scale /= self.scale_multiplier
		# TODO: Damage multiplication?

### Private Functions
