class_name MovementSpeedComponent extends Node

@export var top_speed: float
@export_range(0.01,1.0) var acceleration := 1.0
@export_range(0.01,1.0) var deceleration := 1.0

var top_speed_multiplier = 1.0
var acceleration_multiplier = 1.0
var deceleration_multiplier = 1.0
