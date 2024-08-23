@tool
class_name Hitbox extends Area2D

const MUTUAL_IGNORE = true
const NON_MUTUAL_IGNORE = false

#region Variables
var velocity = Vector2.ZERO
var deceleration = 0.0
var angular_velocity = 0.0
var angular_deceleration = 0.0

var ignored_nodes: Dictionary = {}
var collided_ids: Dictionary = {}
var despawn_timer: Timer = null

@export var limit_collisions = true :
	set(value):
		limit_collisions = value
		notify_property_list_changed()
@export var max_collisions = 1
@export var ignore_repeat_collisions = true

@export var raycast: RayCast2D
#endregion

#region Signals
signal collision_detected(node, velocity)
signal finished
signal freed
var finished_emitted = false
var freed_emitted = false
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	body_shape_entered.connect(_process_collision)
	area_shape_entered.connect(_process_area_collision)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if _check_raycast():
		print("Hitbox: raycast collision detected")
		self.global_position = raycast.get_collision_point()
	else:
		self.position += velocity
	self.rotate(deg_to_rad(angular_velocity))
	# Dampen velocities
	self.velocity = velocity.move_toward(Vector2.ZERO, velocity.length() * deceleration)
	self.angular_velocity = move_toward(angular_velocity, 0.0, angular_deceleration)

func _validate_property(property: Dictionary) -> void:
	if property.name == "max_collisions" and not limit_collisions:
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion

#region Public Functions
## "Virtual" function used to react to a collision
## that has passed through all the other Hitbox checks,
## such as ignored nodes, multiple collisions, etc.
## Return value is whether the reaction to the collision
## should be considered "successful" or not, for purposes
## such as counting collisions before despawning
func on_collision_detected(node: Node2D, velocity: Vector2) -> bool:
	print("Hitbox: on_collision_detected")
	collision_detected.emit(node, velocity)
	return true

func ignore(node: Node2D):
	if node != self:
		self.ignored_nodes[node] = node.name

func ignore_hitbox(hitbox: Hitbox, mutual: bool):
	ignore(hitbox)
	if mutual:
		hitbox.ignore(self)

func ignore_all(nodes: Array[Node2D]):
	for node in nodes:
		self.ignore(node)

static func mutual_ignore(hitboxes: Array[Hitbox]):
	for i in hitboxes.size():
		for j in hitboxes.size() - 1:
			hitboxes[i].ignore_hitbox(hitboxes[j+1], Hitbox.MUTUAL_IGNORE)

func clear_ignores():
	self.ignored_nodes.clear()

func reset_collisions(max_collisions = 0):
	print("Hitbox: reset collisions")
	collided_ids.clear()
	if max_collisions > 0:
		self.limit_collisions = true
		self.max_collisions = max_collisions
	for body in get_overlapping_bodies():
		_process_collision(body.get_rid(), body)
	for area in get_overlapping_areas():
		_process_collision(area.get_rid(), area)

# Use this function if you want to free up the calling object without
# despawning related hitbox objects (such as projectiles)
# Finish will only ever be called once, so despawn() will only emit
# the finished signal if it has not been emitted before
func finish():
	print("Hitbox: finish %s" % not finished_emitted)
	if not finished_emitted:
		finished.emit()
		finished_emitted = true

func despawn():
	print("Hitbox: despawn %s" % not freed_emitted)
	if not freed_emitted:
		finish()
		queue_free()
		freed.emit()
		freed_emitted = true

func despawn_after_delay(delay: float):
	assert(despawn_timer == null, "Duplicate calls to Hitbox.despawn_after_delay()")
	despawn_timer = Timer.new()
	despawn_timer.one_shot = true
	despawn_timer.autostart = true
	despawn_timer.wait_time = delay
	despawn_timer.timeout.connect(despawn)
	add_child(despawn_timer)
#endregion

#region Private Functions
func _should_ignore(rid) -> bool:
	return ignore_repeat_collisions and collided_ids.has(rid)

func _collision_limit_reached() -> bool:
	return limit_collisions and collided_ids.size() >= max_collisions

func _check_raycast() -> bool:
	if not raycast:
		return false
	raycast.global_rotation = 0.0
	raycast.target_position = self.velocity
	raycast.force_raycast_update()
	return raycast.is_colliding() and not _should_ignore(raycast.get_collider_rid())

func _process_collision(rid: RID, node: Node2D, _i: int = 0, _j: int = 0):
	if finished_emitted or freed_emitted:
		return
	if node in ignored_nodes:
		return
	if _should_ignore(rid) or _collision_limit_reached():
		return
	var success = on_collision_detected(node, velocity)
	if success:
		collided_ids[rid] = null
		if _collision_limit_reached():
			despawn()

func _process_area_collision(rid: RID, area: Area2D, _i = 0, _j = 0):
	_process_collision(rid, area)
#endregion
