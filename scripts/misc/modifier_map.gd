class_name ModifierMap

#region Variables
var _map: Dictionary
#endregion

#region Engine Functions
#endregion

#region Public Functions
func add(key, applier: Object, value: float):
	var value_pair = _map.get(key, {})
	value_pair[applier] = value
	_map[key] = value_pair

func remove(key, applier: Object):
	assert(key in _map)
	assert(applier in _map[key])
	_map[key].erase(applier)

# Fuck it I have a headache and no function override is stupid AF
func gett(key) -> float:
	return _map.get(key, {}).values().reduce(func(a,b): return a*b, 1.0)

func clear(key):
	assert(key in _map)
	_map[key].clear()

func clear_all():
	_map = {}
#endregion

#region Private Functions
#endregion

