@tool
class_name NavMap extends Node2D

### Variables
@export var pawn: NavPawn
@export var connections: Array[Connection]

var nodes: Array[Destination]
var node_to_index: Dictionary
var astar: AStar2D

### Signals

### Public Functions_path
# Note: Returns [] if we're already at the destination
#		Returns null if there's no path to the destination
func generate_path(from: Vector2, to: Destination) -> Array[Destination]:
	var dest = _point_is_on_destination(from)
	if dest:
		if dest == to:
			return [dest]
		else:
			var indexes = astar.get_id_path(node_to_index[dest], node_to_index[to])
			return _indexes_to_destinations(indexes)

	var conn = _point_is_on_connection(from)
	if conn:
		if conn.bidirectional:
			var indexes = _shortest_path([get_node(conn.a), get_node(conn.b)], to)
			return _indexes_to_destinations(indexes)
		else:
			var indexes = astar.get_id_path(node_to_index[get_node(conn.b)], node_to_index[to])
			return _indexes_to_destinations(indexes)

	# Last resort:
	#	We're off the navigation tree, so build a path starting from the closest node.
	var indexes = astar.get_id_path(node_to_index[closest_to(from)], node_to_index[to])
	return _indexes_to_destinations(indexes)

func closest_to(pos: Vector2) -> Destination:
	return nodes[astar.get_closest_point(pos)]

func random() -> Destination:
	return nodes.pick_random()

### Engine Functions
func _ready() -> void:
	for child in get_children():
		assert(child is Destination, "invalid navigation child")
		nodes.push_back(child)
	astar = _generate_astar()

	if Engine.is_editor_hint() or get_tree().debug_collisions_hint:
		return

	for node in nodes:
		node.selected.connect(_on_node_selected.bind(node))
	if pawn:
		pawn.reached_destination.connect(func(dest): dest.reach())

func _draw() -> void:
	if Engine.is_editor_hint() or get_tree().debug_collisions_hint:
		_debug_draw_connections()

### Private Functions
func _generate_astar() -> AStar2D:
	var out := AStar2D.new()
	for i in nodes.size():
		var node = nodes[i]
		out.add_point(i, node.position)
		node_to_index[node] = i
		print("Node %s (%d)" % [node.name, i])

	for connection in connections:
		var a: Destination = get_node(connection.a)
		var b: Destination = get_node(connection.b)
		out.connect_points(node_to_index[a], node_to_index[b], connection.bidirectional)
	return out

func _point_is_on_line(point: Vector2, l1: Vector2, l2: Vector2) -> bool:
	# A point is aligned with a line if the vector(l1 -> l2)
	# is parallel with the vector(point -> l2).
	var line = (l2 - l1).normalized()
	var comparison = (l2 - point).normalized()
	var aligned = snapped(comparison.cross(line), 0.001) == 0
	# Alignment isn't good enough, we need to make sure the point
	# actually is within the x/y range of l1 -> l2
	var xmin = min(l1.x, l2.x)
	var xmax = max(l1.x, l2.x)
	var ymin = min(l1.y, l2.y)
	var ymax = max(l1.y, l2.y)
	var within_range = (point.x >= xmin and point.x <= xmax
					and point.y >= ymin and point.y <= ymax)
	return aligned and within_range

func _point_is_on_connection(point: Vector2) -> Connection:
	for connection in connections:
		var a: Destination = get_node(connection.a)
		var b: Destination = get_node(connection.b)
		if _point_is_on_line(point, a.position, b.position):
			return connection
	return null

func _point_is_on_destination(point: Vector2) -> Destination:
	for node in nodes:
		if point == node.position:
			return node
	return null

func _shortest_path(from_candidates: Array[Destination], to: Destination) -> PackedInt64Array:
	var shortest: PackedInt64Array = []
	for from in from_candidates:
		var p = astar.get_id_path(node_to_index[from], node_to_index[to])
		if not shortest or p.size() < shortest.size():
			shortest = p
	return shortest

func _indexes_to_destinations(indexes: PackedInt64Array) -> Array[Destination]:
	var out: Array[Destination] = []
	for i in indexes:
		out.push_back(nodes[i])
	return out

func _on_node_selected(node: Destination):
	if pawn:
		pawn.initiate_move(generate_path(pawn.position, node))

func _debug_draw_connections():
	for connection in connections:
		var a: Vector2 = get_node(connection.a).position
		var b: Vector2 = get_node(connection.b).position
		if (connection.bidirectional):
			draw_line(a, b, Color.AQUA, 2.0)
		else:
			var h: Vector2 = (a+b)/2
			draw_line(a, h, Color.AQUA, 2.0)
			draw_line(h, b, Color.LIGHT_CORAL, 2.0)
