class_name Empty extends Ability

const CLOSE = 150
const MID = CLOSE * 2
const FAR = CLOSE * 3

#region Variables
var speed_modifier: float
var drain_frequency: float
var player: Player

var buff_active = false

var drain_timer: Timer
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(speed_modifier: float, drain_frequency: float = 1.0) -> void:
	super._init()
	self.info = Data.components_by_name["空"]
	self.speed_modifier = speed_modifier
	self.drain_frequency = drain_frequency

	drain_timer = Timer.new()
	drain_timer.timeout.connect(_drain)
	add_child(drain_timer)

func _process(_delta: float) -> void:
	if get_tree().debug_collisions_hint:
		queue_redraw()

func _draw() -> void:
	if not buff_active or not get_tree().debug_collisions_hint:
		return
	const FILL = Color(Color.SKY_BLUE, 0.25)
	const STROKE = Color(Color.DARK_BLUE, 0.75)
	draw_circle(player.global_position, FAR, FILL)
	draw_arc(player.global_position, FAR, 0.0, 2*PI, 100, STROKE, 1, true)
	draw_arc(player.global_position, MID, 0.0, 2*PI, 100, STROKE, 1, true)
	draw_arc(player.global_position, CLOSE, 0.0, 2*PI, 100, STROKE, 1, true)

#endregion

#region Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	Abilities.ability_set.connect(_recheck_buff.unbind(3))
	player = Data.get_player()
	if _no_attacks() and not buff_active:
		_apply_buff()

func on_unset():
	Abilities.ability_set.disconnect(_recheck_buff.unbind(3))
	if buff_active:
		_remove_buff()
#endregion

#region Private Functions
func _no_attacks():
	var is_not_attack = func(a: Ability): return a.info.type != CraftingComponent.Type.ATTACK
	return Abilities.get_abilities(Ability.Category.ACTIVE).all(is_not_attack)

func _recheck_buff():
	if _no_attacks():
		if not buff_active:
			_apply_buff()
	else:
		if buff_active:
			_remove_buff()

func _apply_buff():
	player.modifiers.add(Player.Modifiers.MOVEMENT_TOP_SPEED, self, speed_modifier)
	drain_timer.start(drain_frequency)
	buff_active = true

func _remove_buff():
	if player:
		player.modifiers.remove(Player.Modifiers.MOVEMENT_TOP_SPEED, self)
		drain_timer.stop()
		buff_active = false

func _drain():
	for enemy in Data.get_enemies():
		var distance = player.global_position.distance_to(enemy.global_position)
		var damage = 0
		if distance < CLOSE:
			damage = 5
		elif distance >= CLOSE and distance < MID:
			damage = 3
		elif distance >= MID and distance < FAR:
			damage = 1
		# skip the damage if the distance is too far!
		else:
			continue
		enemy.health.damage(damage, DamageComponent.DamageType.LIGHT, Vector2.ZERO)

#endregion
