class_name Fast extends Ability

### Variables
var multiplier: float
var effect_time: float

var player: Player

### Signals

### Engine Functions
func _init(multiplier, effect_time) -> void:
	super._init()
	self.info = Data.components_by_name["早"]
	self.animation_name = "idle"
	self.cooldown = 10.0

	self.multiplier = multiplier
	self.effect_time = effect_time

### Public Functions
func execute(parent: Node2D, direction: Vector2):
	super.execute(parent, direction)
	self.player = get_tree().get_first_node_in_group(Data.GROUP_PLAYER)
	player.speed.apply_multiplier(self, self.multiplier)
	var effect_timer = Timer.new()
	effect_timer.one_shot = true
	effect_timer.timeout.connect(_reset_multiplier)
	player.add_child(effect_timer)
	effect_timer.start(effect_time)
	finished.emit()

### Private Functions
func _reset_multiplier():
	if player:
		player.speed.remove_multiplier(self)
