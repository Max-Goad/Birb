class_name MapData extends Resource

## Filename used to uniquely identify the map.
## Also used to access this MapData from SaveData.
@export var filename: String = "UNSET FILENAME"

## Data about all objects marked as "persist" in this map.
## Created and read by the object itself during save/load operations.
## A Map (and its MapData) should not care about or use this data,
## other than to track when objects should be added or removed during load.
## 	Key: NodePath
## 	Value: Dictionary
@export var object_data: Dictionary = {}

func _to_string() -> String:
	return "<MapData(%s) object_data=%s >" % [filename, object_data]

## Creates a fully independant copy of the MapData.
## This function is necessary (instead of using duplicate())
## because duplicate does not properly duplicate subresources
## inside of Arrays or Dictionaries.
## This one is technically not necessary right now (duplicate would
## work fine for MapData at time of writing) but... just in case.
func make_copy() -> MapData:
	var new_copy: MapData = duplicate(true)
	return new_copy


static func generate(filename: String) -> MapData:
	var map_data := MapData.new()
	map_data.filename = filename
	return map_data
