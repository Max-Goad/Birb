class_name SpeedComponent extends Node

@export var top_speed: float = 1.0
@export_range(0.0, 1.0) var acceleration := 1.0
@export_range(0.0, 1.0) var deceleration := 1.0
@export_range(0.0, 1.0) var rotation_speed = 0.5
@export var ability_speed = 1.0
@export var projectile_speed = 1.0
