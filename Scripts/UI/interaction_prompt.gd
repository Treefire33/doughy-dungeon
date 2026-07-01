extends Panel

@onready var action_prompt: Label = $StaticPrompt;

func _ready() -> void:
	action_prompt.text = Keybinds.format_action_string("[[Primary]] to Interact");
