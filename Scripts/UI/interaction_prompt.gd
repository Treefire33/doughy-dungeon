extends Panel

@onready var action_prompt: Label = $StaticPrompt;

func _ready() -> void:
	var a = Keybinds.format_action_string("[[Primary]] to Interact");
	action_prompt.text = a;
