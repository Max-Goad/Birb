class_name EnemyKyou extends Enemy

const PL_KYOU_PROJECTILE = preload("res://resources/enemies/hb_kyou_projectile.tscn")

enum State
{
	WAITING_TO_FIRE = 0,
	RELOADING,
	GROWING,
}

#region Variables
var projectile: Hurtbox = null
# TODO: How do we dynamically set these?
@export var projectile_speed: float = 10.0
var timer: Timer = null
# TODO: How do we dynamically set these?
@export var grow_time: float = 1.0
@export var reload_time: float = 1.0
var despawn_time: float = 2.0

var current_state: State = State.RELOADING
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	super._ready()
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	projectile = _spawn_projectile()

func _process(delta: float) -> void:
	super._process(delta)
	match current_state:
		State.WAITING_TO_FIRE:
			if timer.is_stopped() and _ready_to_fire():
				_fire(projectile)
				# We replace the previous projectile because
				# it's no longer necessary to track once fired
				projectile = _spawn_projectile()
				print("Kyou -> Reloading")
				current_state = State.RELOADING
				timer.start(reload_time)
		State.RELOADING:
			if timer.is_stopped():
				current_state = State.GROWING
				timer.start(grow_time)
		State.GROWING:
			if timer.is_stopped():
				current_state = State.WAITING_TO_FIRE
			else:
				projectile.scale = scale * (1 - (timer.time_left / grow_time))

#endregion

#region Public Functions
#endregion

#region Private Functions
func _spawn_projectile() -> Hurtbox:
	var new_projectile = PL_KYOU_PROJECTILE.instantiate()
	new_projectile.top_level = false
	new_projectile.scale = Vector2.ZERO
	new_projectile.damage_component = damage
	new_projectile.damage_component.enabled = false
	add_child(new_projectile)
	return new_projectile

func _ready_to_fire():
	return (pathfinding.strategy != PathfindingComponent.Strategy.TRACK_FROM_DISTANCE
		 or pathfinding.current_track_state == PathfindingComponent.TrackState.IN_RANGE)

func _fire(projectile):
	projectile.damage_component.enabled = true
	projectile.top_level = true # Do not follow parent's transforms
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	projectile.global_scale = global_scale
	projectile.velocity = Vector2.UP.rotated(rotation) * projectile_speed
	_attach_despawn_timer(projectile)

func _attach_despawn_timer(projectile):
	var despawn_timer = Timer.new()
	despawn_timer.wait_time = despawn_time
	despawn_timer.autostart = true
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(func(): projectile.queue_free())
	projectile.add_child(despawn_timer)
#endregion

