class_name NavPawn extends Node2D

### Variables
@onready var path: Path2D = $Path
@onready var follow: PathFollow2D = $Path/Follow

@export_range(0.5, 4.0) var move_speed : float = 1.0

var moving : bool
var direction: Vector2
var destination: Destination

### Signals
signal reached_destination

### Public Functions
func initiate_move(p: Array[Destination]):
	# If we have no path it means the destination is unreachable.
	# Do nothing.
	if not p:
		return

	# Create curve from path
	path.curve.clear_points()
	# If we're not at a destination, add our current position at the start
	if position != p.front().position:
		path.curve.add_point(position)
	for d in p:
		path.curve.add_point(d.position)
	#
	follow.progress = 0
	destination = p.back()
	moving = true

### Engine Functions
func _ready():
	assert(not follow.loop, "pawn follow node must not loop")
	_reset()

func _process(delta):
	if moving:
		if follow.progress_ratio >= 1.0 or self.position == destination.position:
			_reach_destination()
		else:
			follow.progress += move_speed * 250 * delta
			position = follow.position
			direction = _determine_direction()

## Private Functions
func _reset():
	path.curve.clear_points()
	follow.progress = 0
	moving = false
	direction = Vector2.ZERO

func _determine_direction() -> Vector2:
	var original_progress = follow.progress
	var original_position = follow.position
	follow.progress += 5
	var predicted_position = follow.position
	follow.progress = original_progress
	return (predicted_position - original_position).normalized()

func _reach_destination():
	reached_destination.emit(self.destination)
	_reset()
