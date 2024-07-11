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
		CraftingComponent.Type.PASSIVE:
			return Category.PASSIVE
		_:
			return Category.NULL

### Variables
var info: CraftingComponent
var animation_name: String
var cooldown: float = 0.0

var _cooldown_timer: Timer

### Signals
signal finished
signal cooldown_complete

### Engine Functions
func _init() -> void:
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.timeout.connect(func(): cooldown_complete.emit())
	add_child(_cooldown_timer)

func _ready():
	if self.info.label:
		self.name = self.info.label
	else:
		self.name = "Null"


### Public Functions
func execute(_parent: Node2D, _direction: Vector2):
	assert(_cooldown_timer.is_stopped())
	_cooldown_timer.start(cooldown)

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
		"早":
			return Fast.new()
		"薬":
			return Medicine.new(10)
		_:
			return NullAbility.new()
