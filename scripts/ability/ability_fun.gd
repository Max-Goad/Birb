class_name Fun extends Ability

const PL_SILLY_LITTLE_HAT = preload("res://resources/attacks/silly_little_hat.tscn")
const HAT_NAME = "Silly Little Hat"

### Variables
var spawners: Array[Spawner] = []

### Signals

### Engine Functions
func _init() -> void:
	super._init()
	self.info = Data.components_by_name["楽"]

### Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	# Find all spawners
	var nodes = get_tree().get_nodes_in_group(Data.GROUP_SPAWNER)
	spawners.assign(nodes)
	for spawner in spawners:
		spawner.connect_on_spawn(self, _attach_silly_little_hat)

func on_unset():
	for spawner in spawners:
		spawner.disconnect_on_spawn(self, _detach_silly_little_hat)

### Private Functions
func _attach_silly_little_hat(enemy: Enemy):
	print("attaching silly little hat to %s" % enemy)
	var hat = PL_SILLY_LITTLE_HAT.instantiate()
	hat.name = HAT_NAME
	enemy.add_child(hat)

func _detach_silly_little_hat(enemy: Enemy):
	print("detaching silly little hat from %s" % enemy)
	for child in enemy.get_children():
		if child.name == HAT_NAME:
			enemy.remove_child(child)
			return
