class_name SaveData extends Resource

@export var save_name: String

@export var components_unlocked := {0:null} # key-only Set
@export var recipe_types_unlocked := {} # key-only Set
@export var active_ability_slots_unlocked := 1
@export var passive_ability_slots_unlocked := 1

## Stores the current map at time of save.
@export var current_map := ""

## Map Data contains all the data necessary for saving and loading
## map state, including all its persisting objects.
##	Key: String (map filename)
##	Value: MapData
@export var map_data: Dictionary = {}

## Stores the current player position at the time of save.
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
