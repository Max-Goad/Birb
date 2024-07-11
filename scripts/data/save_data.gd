class_name SaveData extends Object

var save_name: String

var components_unlocked := {0:null} # key-only Set
var recipe_types_unlocked := {} # key-only Set
var active_ability_slots_unlocked = 1
var passive_ability_slots_unlocked = 2


static func serialize(sd: SaveData) -> Dictionary:
	return {
		"save_name": sd.save_name,

		"components_unlocked": sd.components_unlocked,
		"recipe_types_unlocked": sd.recipe_types_unlocked,
		"active_ability_slots_unlocked": sd.active_ability_slots_unlocked,
		"passive_ability_slots_unlocked": sd.passive_ability_slots_unlocked,
	}

static func deserialize(raw: Dictionary) -> SaveData:
	var out = SaveData.new()
	out.save_name = raw["save_name"]

	out.components_unlocked = raw["components_unlocked"]
	out.recipe_types_unlocked = raw["recipe_types_unlocked"]
	out.active_ability_slots_unlocked = raw["active_ability_slots_unlocked"]
	out.passive_ability_slots_unlocked = raw["passive_ability_slots_unlocked"]

	return out
