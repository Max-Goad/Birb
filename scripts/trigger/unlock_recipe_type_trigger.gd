extends Trigger

@export var recipe_type: CraftingRecipe.Type

func execute():
	Data.unlock_recipe_type(recipe_type)

