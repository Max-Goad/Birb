class_name SpeedComponent extends Node

@export var top_speed: float = 1 :
	get: return _combine_multipliers(top_speed)
@export_range(0.01,1.0) var acceleration := 1.0 :
	get: return _combine_multipliers(acceleration)
@export_range(0.01,1.0) var deceleration := 1.0 :
	get: return _combine_multipliers(deceleration)
@export var ability_speed = 1.0 :
	get: return _combine_multipliers(ability_speed)
@export var projectile_speed = 1.0 :
	get: return _combine_multipliers(projectile_speed)

# object id : float
var multipliers: Dictionary = {}

func apply_multiplier(applier: Object, multiplier: float):
	assert(applier not in multipliers)
	multipliers[applier] = multiplier

func remove_multiplier(applier: Object):
	assert(applier in multipliers)
	multipliers.erase(applier)

func _combine_multipliers(value: float):
	return multipliers.values().reduce(func(a,b): return a*b, value)
