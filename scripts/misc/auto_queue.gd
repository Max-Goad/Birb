# An event queue which stores a series of Callables to be run in sequential order.
#
# The queue nodes can either be Manual or Automatic:
#	- QueueNodes end when receiving a signal provided by the queueing code.
#	- AutoQueueNodes automatically end upon the completion of the Callable.
#
# The queue must be manually started, so multiple events can be stored
# and executed at a later time.
class_name AutoQueue extends Object

class QueueNode:
	var f : Callable
	var s : Signal
	func conn(c : Callable):
		if not s.is_connected(c):
			s.connect(c)
	func run():
		f.call()

class AutoQueueNode extends QueueNode:
	signal auto
	func conn(c : Callable):
		if not auto.is_connected(c):
			auto.connect(c)
	func run():
		f.call()
		auto.emit()

var queue : Array[QueueNode] = []
var running : bool = false

signal complete

#region Public Functions
func push_back(f : Callable, s : Signal):
	#print("AutoQueue: push")
	var node = QueueNode.new()
	node.f = f
	node.s = s
	node.conn(_on_complete)
	queue.push_back(node)

func push_back_auto(f : Callable):
	#print("AutoQueue: push (auto)")
	var node = AutoQueueNode.new()
	node.f = f
	node.conn(_on_complete)
	queue.push_back(node)

func start():
	if not running and queue.size() > 0:
		#print("AutoQueue: start")
		running = true
		_next()
#endregion

#region Private Functions
func _next():
	#print("AutoQueue: next node")
	var node = queue.pop_front()
	node.run()

func _on_complete():
	#print("AutoQueue: node complete")
	if queue.size() > 0:
		_next()
	else:
		#print("AutoQueue: end")
		running = false
		complete.emit()
#endregion
