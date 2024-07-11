extends Button

const damage_indicator_preload = preload("res://resources/ui/damage_indicator.tscn")

@export var damage: int = 100
@export var color: Color = Color.WHITE
@export var random: bool = false

func _pressed() -> void:
	print("pressed")
	var di = damage_indicator_preload.instantiate()
	if random:
		di.damage = randi_range(-100, 100)
		di.color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	else:
		di.damage = self.damage
		di.color = self.color
	di.position = self.position - Vector2(0, 50)
	get_parent().add_child(di)

