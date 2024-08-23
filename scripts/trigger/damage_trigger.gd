class_name DamageTrigger extends Trigger

@export var damage: DamageComponent
@export var target: Node2D
@export var velocity = Vector2.ZERO

func _ready() -> void:
	assert(damage)
	assert(target)

func execute():
	damage.apply(target, velocity)
