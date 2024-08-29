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

static func generate(filename: String) -> MapData:
	var map_data := MapData.new()
	map_data.filename = filename
	return map_data
