class_name King extends Ability

const PL_SILLY_LITTLE_CROWN = preload("res://resources/attacks/silly_little_crown.tscn")
const CROWN_NAME = "Silly Little Crown"

#region Variables
var player: Player
#endregion

#region Signals
#endregion

#region Engine Functions
func _init() -> void:
	super._init()
	self.info = Data.components_by_name["楽"]
#endregion

#region Public Functions
func execute(_parent: Player, _direction: Vector2):
	pass

func on_set():
	player = Data.get_player()
	_attach_silly_little_crown(player)

func on_unset():
	_detach_silly_little_crown(player)
#endregion

#region Private Functions
func _attach_silly_little_crown(node):
	print("attaching silly little crown to %s" % node)
	var crown = PL_SILLY_LITTLE_CROWN.instantiate()
	crown.name = CROWN_NAME
	node.add_child(crown)

func _detach_silly_little_crown(node):
	print("detaching silly little crown from %s" % node)
	for child in node.get_children():
		if child.name == CROWN_NAME:
			node.remove_child(child)
			return
#endregion
