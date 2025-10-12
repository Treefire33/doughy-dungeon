extends Node

var game_speed: int = 1;
var audio_volume: float = 1;
var toast_size: int = 12;

var room_count: int = 0;

var settings_menu: PackedScene = preload("res://Scenes/Menus/SettingsMenu/settings_menu.tscn");

func load_settings_menu(node: Node):
	var new_settings = settings_menu.instantiate();
	node.add_child(new_settings);
	
func load_settings():
	var settings = ConfigFile.new()
	var result = settings.load("user://settings.cfg")
	if (result != OK):
		return;
	
	for section in settings.get_sections():
		if (section == "game_settings"):
			game_speed = settings.get_value(section, "game_speed", 1)
			audio_volume = settings.get_value(section, "audio_volume", 1)
			toast_size = settings.get_value(section, "toast_size", 12)
		elif (section == "keybinds"):
			for action in Keybinds.bindable_actions:
				var event = settings.get_value("keybinds", action, InputEventAction.new());
				Keybinds.remap_action(action, event);
	
func save_settings():
	var settings = ConfigFile.new()
	settings.set_value("game_settings", "game_speed", game_speed)
	settings.set_value("game_settings", "audio_volume", audio_volume)
	settings.set_value("game_settings", "toast_size", toast_size)
	
	for action in Keybinds.bindable_actions:
		settings.set_value("keybinds", action, Keybinds.get_action_bind(action));
	
	settings.save("user://settings.cfg")
	
func _ready() -> void:
	load_settings()
	DiscordRPC.app_id = 1426862643171430471;
	DiscordRPC.details = "https://treefire33.itch.io/doughy-dungeon";
	DiscordRPC.state = "Crawling through the Doughy Dungeon.";
	DiscordRPC.large_image = "doughygameicon";
	DiscordRPC.large_image_text = "Play Doughy Dungeon on itch.io!";

	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system());
	DiscordRPC.refresh();
	
func _exit_tree() -> void:
	save_settings()
