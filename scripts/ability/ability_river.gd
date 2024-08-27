class_name River extends Ability

#region Variables
var knockback_force: float
var stun_time: float
var knockback_direction = Vector2.UP

var damage_component: DamageComponent
var knockback_damage_nodes: Array[Node] = []
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(knockback_force, stun_time) -> void:
	super._init()
	self.info = Data.components_by_name["川"]
	self.animation_name = "idle"
	self.cooldown = 3.0

	self.knockback_force = knockback_force
	self.stun_time = stun_time

	self.damage_component = DamageComponent.new()
	self.damage_component.amount = 10
	self.damage_component.knockback_degree = KnockbackComponent.Degree.NO_RECOIL
#endregion

#region Public Functions
func execute(parent: Player, direction: Vector2):
	super.execute(parent, direction)
	var knockback_direction = Math.vector4dir(direction)
	_apply_vfx(knockback_direction)
	for enemy: Enemy in Data.get_enemies():
		if enemy.knockback:
			enemy.knockback.apply_knockback(knockback_direction, knockback_force, stun_time)
			_attach_damage_node(enemy)
	# Player should be affected less
	var player = Data.get_player()
	player.knockback.apply_knockback(knockback_direction, knockback_force / 2, stun_time / 2)
	player.knockback.knockback_finished.connect(_on_knockback_complete, CONNECT_ONE_SHOT)
	_attach_damage_node(player)
#endregion

#region Private Functions
func _apply_vfx(direction: Vector2):
	var vfx = VFXRiver.new()
	vfx.flow_speed = -direction * 2
	if direction in [Vector2.UP, Vector2.DOWN]:
		vfx.horizontal = false
	Data.get_canvas().add_child(vfx, true)

func _attach_damage_node(character: CharacterBody2D):
	var reactor = DamagingMovementReactor.new()
	reactor.name = "AbilityRiverDamagingMovementReactor"
	reactor.character = character
	reactor.threshold = knockback_force * 100 # TODO: Arbitrary
	reactor.damage = self.damage_component.duplicate()
	character.add_child(reactor)
	knockback_damage_nodes.push_back(reactor)

func _on_knockback_complete():
	while not knockback_damage_nodes.is_empty():
		var node = knockback_damage_nodes.pop_back()
		if node != null:
			node.queue_free()
	finished.emit()
#endregion
