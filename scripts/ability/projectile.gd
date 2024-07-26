class_name Projectile extends RigidBody2D

const MUTUAL_IGNORE = true

#region Variables
var force: Vector2

var max_collisions = 0

var ignored: Array[Node] = []
var collided: Array[Node] = []

var ignore_repeat_collisions = true
var finished_emitted = false

@export var damage: DamageComponent
@export var movement: RigidBodyMovementComponent
#endregion

#region Signals
signal finished
#endregion

#region Engine Functions
func _ready() -> void:
	assert(damage)
	linear_damp = 0.0
	angular_damp = 0.0
	movement.apply_force(force)

func _process(_delta: float) -> void:
	pass

func _body_entered(body: Node):
	if finished_emitted:
		return
	if body in ignored:
		return
	if body in collided and ignore_repeat_collisions:
		return
	if collided.size() > max_collisions:
		return
	print("Projectile: collision detected")
	var success = damage.apply(body, linear_velocity)
	if success:
		collided.push_back(body)
		if collided.size() >= max_collisions:
			finish()
#endregion

#region Public Functions
static func mutual_ignore(projectiles: Array[Projectile]):
	for i in projectiles.size():
		for j in projectiles.size() - 1:
			projectiles[i].ignore_projectile(projectiles[j+1], MUTUAL_IGNORE)


func ignore(body: Node):
	if body != self:
		ignored.push_back(body)

func ignore_projectile(projectile: Projectile, mutual = false):
	ignore(projectile)
	if mutual:
		projectile.ignore(self)

func ignore_all(bodies: Array[Node]):
	for body in bodies:
		ignore(body)

func reset_ignored():
	ignored.clear()

func reset_collisions(max_collisions = self.max_collisions):
	print("Hurtbox: reset collisions")
	collided.clear()
	self.max_collisions = max_collisions
	for body in get_colliding_bodies():
		_body_entered(body)

func finish():
	print("Projectile: finish (%s)" % not finished_emitted)
	if not finished_emitted:
		finished.emit()
		finished_emitted = true
		queue_free()
#endregion

#region Private Functions
#endregion

