class_name Ability extends Node2D

enum Category
{
	ACTIVE = 0,
	PASSIVE = 1,

	NULL = -1,
}

static func component_type_to_category(type: CraftingComponent.Type) -> Category:
	match type:
		CraftingComponent.Type.ATTACK:
			return Category.ACTIVE
		CraftingComponent.Type.SUPPORT:
			return Category.ACTIVE
		# TODO: Could SPECIAL be BOTH active AND passive?
		CraftingComponent.Type.SPECIAL:
			return Category.ACTIVE
		CraftingComponent.Type.PASSIVE:
			return Category.PASSIVE
		_:
			return Category.NULL

### Variables
var info: CraftingComponent
var animation_name: String
var cooldown: float = 0.0
var delay_callable: Callable = func(): pass

var _cooldown_timer: Timer
var _delay_timer: Timer

### Signals
signal finished # Indicates when control should be given back to player
signal cooldown_complete

### Engine Functions
func _init() -> void:
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.timeout.connect(func(): cooldown_complete.emit())
	add_child(_cooldown_timer)

	_delay_timer = Timer.new()
	_delay_timer.one_shot = true
	_delay_timer.timeout.connect(func(): delay_callable.call())
	add_child(_delay_timer)

func _ready():
	if self.info.label:
		self.name = self.info.label
	else:
		self.name = "Null"


### Public Functions
func execute(_parent: Node2D, _direction: Vector2):
	assert(_cooldown_timer.is_stopped())
	_cooldown_timer.start(cooldown)

func execute_with_delay(fn: Callable, delay: float):
	assert(delay > 0.0)
	assert(_delay_timer.is_stopped())
	delay_callable = fn
	_delay_timer.start(delay)

func on_set():
	pass

func on_unset():
	pass

func is_null() -> bool:
	return false

func ready() -> bool:
	return _cooldown_timer.is_stopped()

### Private Functions

static func from_component(component: CraftingComponent) -> Ability:
	match component.label:
		"丨":
			return Stick.new()
		"一":
			return One.new(25, 15)
		"二":
			return Two.new(25, 10, 0.1)
		"三":
			return Three.new(25, 10)
		"十":
			# tf, pf, id, ed, pd, et
			return Ten.new(35.0, 50.0, 5, 20, 10)
		"百":
			# tf, pf, id, ed, pd, et
			return Hundred.new(35.0, 5, 50)
		"早":
			# multiplier, effect time
			return Fast.new(1.5, 3.0)
		"儿":
			# multiplier
			return Legs.new(1.1)
		"大":
			# scale, damage
			return SizeChange.new(component.label, 1.5, 1.5)
		"小":
			# scale, damage
			return SizeChange.new(component.label, 0.667, 0.667)
		"薬":
			# amount
			return Medicine.new(10)
		_:
			return NullAbility.new()
