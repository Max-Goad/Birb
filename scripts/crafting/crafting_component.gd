class_name CraftingComponent extends Resource

enum Type {
	NONE = 0,
	ATTACK,
	SUPPORT,
	PASSIVE,
	UNLOCK,
	SPECIAL,
}

static func color(type: Type) -> Color:
	match type:
		Type.ATTACK:
			return Color.PALE_VIOLET_RED
		Type.SUPPORT:
			return Color.PALE_GREEN
		Type.PASSIVE:
			return Color.SKY_BLUE
		Type.SPECIAL:
			return Color.PLUM
		Type.UNLOCK:
			return Color.PALE_GOLDENROD
		_:
			return Color.WHITE

const empty_id = -1

@export var id: int
@export var label: String
@export var type: Type

func _init(id = empty_id, label = "", type = Type.NONE) -> void:
	self.id = id
	self.label = label
	self.type = type

func _to_string() -> String:
	return "CraftingComponent[%s,%s,%s]" % [id,label,type]
