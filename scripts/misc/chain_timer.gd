class_name ChainTimer extends Timer

enum Action
{
	WAIT,
	RUN
}
#region Variables
var actions: Array[Action] = []
var fns: Array[Callable] = []
var delays: Array[float] = []

var _chain_started = false
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	self.one_shot = true
	self.autostart = false
	self.timeout.connect(_continue_chain)
#endregion

#region Public Functions
func wait(delay: float) -> ChainTimer:
	assert(delay > 0.0, "Cannot delay by negative (or zero) number")
	actions.push_back(Action.WAIT)
	delays.push_back(delay)
	return self

func run(fn: Callable) -> ChainTimer:
	actions.push_back(Action.RUN)
	fns.push_back(fn)
	return self

func start_chain() -> void:
	assert(not actions.is_empty(), "ChainTimer.start_chain() called without any actions chained!")
	assert(actions.back() != Action.WAIT, "Last chained action is a wait (no reason to do this)")
	if not actions.is_empty():
		_continue_chain()
#endregions

#region Private Functions
func _continue_chain():
	if actions.is_empty():
		return
	var continue_chain = true
	while continue_chain:
		continue_chain = _next_action()
	if actions.is_empty():
		_chain_started = false

func _next_action() -> bool:
	if actions.is_empty():
		return false
	match actions.pop_front():
		Action.WAIT:
			assert(not delays.is_empty())
			self.start(delays.pop_front())
			# Chain will be continued when timer timeout occurs
			return false
		Action.RUN:
			assert(not fns.is_empty())
			var fn: Callable = fns.pop_front()
			fn.call()
			return true
		_:
			assert(false)
			return false
#endregion

