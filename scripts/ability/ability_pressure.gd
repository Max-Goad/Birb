class_name Pressure extends Ability

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
	self.info = Data.components_by_name["圧"]
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
	super.chain().run(_charge).wait(1.0).run(_push).wait(stun_time).run(_remove_damage_nodes).start_chain()
#endregion

#region Private Functions
func _charge():
	# TODO: Do something?
	pass

func _push():
	for enemy: Enemy in Data.get_enemies():
		var knockback_direction = (enemy.global_position - parent.global_position).normalized()
		if enemy.knockback:
			enemy.knockback.apply_knockback(knockback_direction, knockback_force, stun_time)
			_attach_damage_node(enemy)
	finished.emit()

func _attach_damage_node(character: CharacterBody2D):
	var reactor = DamagingMovementReactor.new()
	reactor.name = "AbilityPressureDamagingMovementReactor"
	reactor.character = character
	reactor.threshold = knockback_force * 100 # TODO: Arbitrary
	reactor.damage = self.damage_component.duplicate()
	character.add_child(reactor)
	knockback_damage_nodes.push_back(reactor)

func _remove_damage_nodes():
	while not knockback_damage_nodes.is_empty():
		var node = knockback_damage_nodes.pop_back()
		if node != null:
			node.queue_free()
	finished.emit()
#endregion
