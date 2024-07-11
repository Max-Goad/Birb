class_name Fast extends Ability

### Variables
var player: Player

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
	# TODO: How to get player?
	# self.player.top_speed *= 1.5
	# self.player.acceleration *= 1.5

func on_unset():
	print("fast unset")
	# self.player.top_speed /= 1.5
	# self.player.acceleration /= 1.5

### Private Functions
