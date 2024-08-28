class_name SaveData extends Resource

@export var save_name: String

@export var components_unlocked := {0:null} # key-only Set
@export var recipe_types_unlocked := {} # key-only Set
@export var active_ability_slots_unlocked := 1
@export var passive_ability_slots_unlocked := 1

@export var current_map := ""
## { file_name : ??? }
@export var map_items := {}

@export var player_position := Vector2.ZERO

## JSON Version
#static func serialize(sd: SaveData) -> Dictionary:
#	return {
#		"save_name": sd.save_name,
#
#		"components_unlocked": sd.components_unlocked,
#		"recipe_types_unlocked": sd.recipe_types_unlocked,
#		"active_ability_slots_unlocked": sd.active_ability_slots_unlocked,
#		"passive_ability_slots_unlocked": sd.passive_ability_slots_unlocked,
#
#		"current_map": sd.current_map,
#
#		"player_position": var_to_str(sd.player_position),
#	}
#
#static func deserialize(raw: Dictionary) -> SaveData:
#	var out = SaveData.new()
#	out.save_name = raw["save_name"]
#
#	out.components_unlocked = raw["components_unlocked"]
#	out.recipe_types_unlocked = raw["recipe_types_unlocked"]
#	out.active_ability_slots_unlocked = raw["active_ability_slots_unlocked"]
#	out.passive_ability_slots_unlocked = raw["passive_ability_slots_unlocked"]
#
#	out.current_map = raw["current_map"]
#
#	out.player_position = str_to_var(raw["player_position"])
#
#	return out
#
