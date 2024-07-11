extends Trigger

@export var label: String
@export var category: Ability.Category
@export var slot: int

func execute():
	Abilities.set_ability(self.category, self.slot, Data.components_by_name[label])

