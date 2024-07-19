class_name Hurtbox extends Area2D

const MUTUAL_IGNORE = true
const NON_MUTUAL_IGNORE = false

### Variables
var velocity = Vector2.ZERO
var deceleration = 0.0
var angular_velocity = 0.0
var angular_deceleration = 0.0

var ignored_nodes: Dictionary = {}
var collided_ids: Dictionary = {}

@export var max_collisions = 1
@export var frame_alt_damage: Array[bool]

# @onready var speed_component: SpeedComponent = $SpeedComponent
@onready var damage_component: DamageComponent = $DamageComponent

### Signals
signal finished
signal freed
var finished_emitted = false
var freed_emitted = false

### Engine Functions
func _ready() -> void:
	# assert(speed_component)
	assert(damage_component)
	body_shape_entered.connect(_hit_body)
	area_shape_entered.connect(_hit_area)

func _process(_delta: float) -> void:
	self.position += velocity
	self.rotate(deg_to_rad(angular_velocity))
	self.velocity = velocity.move_toward(Vector2.ZERO, velocity.length() * deceleration)
	self.angular_velocity = move_toward(angular_velocity, 0.0, angular_deceleration)

### Public Functions
func ignore(node: Node2D):
	if node != self:
		self.ignored_nodes[node] = node.name

func ignore_hurtbox(hurtbox: Hurtbox, mutual: bool):
	ignore(hurtbox)
	if mutual:
		hurtbox.ignore(self)

func ignore_all(nodes: Array[Node2D]):
	for node in nodes:
		self.ignore(node)

static func mutual_ignore(hurtboxes: Array[Hurtbox]):
	for i in hurtboxes.size():
		for j in hurtboxes.size() - 1:
			hurtboxes[i].ignore_hurtbox(hurtboxes[j+1], Hurtbox.MUTUAL_IGNORE)

# Use this function if you want to free up the calling object without
# despawning related hurtbox objects (such as projectiles)
# Finish will only ever be called once, so despawn() will only emit
# the finished signal if it has not been emitted before
func finish():
	print("hurtbox: finish %s" % not finished_emitted)
	if not finished_emitted:
		finished.emit()
		finished_emitted = true

func despawn():
	print("hurtbox: despawn %s" % not freed_emitted)
	if not freed_emitted:
		finish()
		queue_free()
		freed.emit()
		freed_emitted = true

### Private Functions
func _hit_body(body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int):
	if finished_emitted or freed_emitted:
		return
	if body in ignored_nodes:
		return
	if collided_ids.has(body_rid) or collided_ids.size() > max_collisions:
		return
	print("hit body %s, alt? %s" % [local_shape_index,_index_is_alt(local_shape_index)])
	var success = damage_component.apply(body, _index_is_alt(local_shape_index))
	if success:
		collided_ids[body_rid] = null
		if collided_ids.size() >= max_collisions:
			despawn()

func _hit_area(area_rid: RID, area: Area2D, _area_shape_index: int, local_shape_index: int):
	if finished_emitted or freed_emitted:
		return
	if area in ignored_nodes:
		return
	if collided_ids.has(area_rid) or collided_ids.size() > max_collisions:
		return
	# print("hit area %s, alt? %s" % [local_shape_index,_index_is_alt(local_shape_index)])
	var success = damage_component.apply(area.get_parent(), _index_is_alt(local_shape_index))
	if success:
		collided_ids[area_rid] = null
		if collided_ids.size() >= max_collisions:
			despawn()

func _index_is_alt(i) -> bool:
	if i >= frame_alt_damage.size():
		return false
	else:
		return frame_alt_damage[i]
