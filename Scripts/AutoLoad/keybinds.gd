extends Node

var bindable_actions: Array[String] = [
	"Pause",
	"Reset",
	"Primary",
	"Secondary",
	"Tertiary",
	"Quaternary",
	"Up",
	"Down",
	"Left",
	"Right",
	# "toggle_debug"
];

var action_descriptions: Dictionary[String, String] = {
	"Pause": "Pauses the game.",
	"Reset": "Quickly restart your run.\nBrings you back to Room 1.",
	"Primary": "Primary action.\nCorresponds to Attack/Enemy1/Proceed.",
	"Secondary": "Secondary action.\nCorresponds to Defend/Enemy2/Risk It.",
	"Tertiary": "Tertiary action.\nCorresponds to Attack/Enemy3/Stay Clear.",
	"Quaternary": "Quaternary action.\nOpens the inventory.",
}

func remap_action(action: String, event: InputEvent):
	InputMap.action_erase_events(action);
	InputMap.action_add_event(action, event);
	
func get_action_text(action: String) -> String:
	var events = InputMap.action_get_events(action);
	if (len(events) <= 0):
		return "";
	return events[0].as_text().split(' ')[0];

func get_action_description(action: String) -> String:
	if (not action_descriptions.has(action)):
		return "";
	return action_descriptions[action];

func get_action_bind(action: String) -> InputEventKey:
	return InputMap.action_get_events(action)[0];

func format_action_string(action_string: String):
	var final_string = action_string;
	for action in bindable_actions:
		var act_string = "[[%s]]" % action;
		final_string = final_string.replacen(act_string, get_action_text(action));
	return final_string;

var keybinds_menu: PackedScene = preload("res://Scenes/Menus/KeybindsMenu/keybinds_menu.tscn");
func load_keybinds_menu(node: Node):
	var new_keybinds = keybinds_menu.instantiate();
	node.add_child(new_keybinds);
