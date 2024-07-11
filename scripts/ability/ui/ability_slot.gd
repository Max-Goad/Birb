class_name AbilitySlot extends AspectRatioContainer

### Variables
var slot_id: int
var color := Color.WHITE
var ability: Ability
var category: Ability.Category

@onready var label: Label = $Slot/Label
@onready var cooldown: Timer = $Slot/Timer
@onready var progress_bar: ProgressBar = $Slot/ProgressBar

### Signals

### Engine Functions
func _ready() -> void:
	Abilities.ability_set.connect(_on_ability_set)
	Abilities.ability_reset.connect(_on_ability_reset)
	Abilities.ability_executed.connect(_on_ability_executed)
	Abilities.ability_ready.connect(_on_ability_ready)
	Abilities.ability_canceled.connect(_on_ability_canceled)

	label.text = ""
	cooldown.one_shot = true
	progress_bar.value = 100

func _process(_delta: float) -> void:
	if not cooldown.is_stopped():
		var percent_left = (cooldown.time_left * 100.0 / cooldown.wait_time)
		progress_bar.value = 100 - percent_left
		print("percent left = %s" % percent_left)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if Ability.component_type_to_category(Crafting.current_component.type) == self.category:
			Abilities.set_ability(self.category, self.slot_id, Crafting.current_component)

### Public Functions

### Private Functions
func _on_ability_set(category: Ability.Category, slot: int, ability: Ability):
	if self.slot_id != slot or category != self.category:
		return
	print("[AbilitySlot] on ability set to %s (slot %s)" % [ability.info.label, slot])
	color = CraftingComponent.color(ability.info.type)
	self.ability = ability
	self.modulate = color
	label.text = ability.info.label
	if not cooldown.is_stopped():
		_on_ability_canceled(slot)

func _on_ability_reset(category: Ability.Category, slot: int):
	if self.slot_id != slot or category != self.category:
		return
	print("[AbilitySlot] on ability reset (slot %s)" % [slot])
	color = Color.WHITE
	self.modulate = color
	label.text = ""

func _on_ability_executed(slot: int, time: float):
	if self.slot_id != slot or self.category != Ability.Category.ACTIVE:
		return
	progress_bar.value = 0
	print("execute with time %s" % time)
	cooldown.start(time)
	self.modulate = color * Color.GRAY

func _on_ability_ready(slot: int):
	if self.slot_id != slot or self.category != Ability.Category.ACTIVE:
		return
	self.modulate = color

func _on_ability_canceled(slot: int):
	if self.slot_id != slot or self.category != Ability.Category.ACTIVE:
		return
	progress_bar.value = 100
	cooldown.stop()

