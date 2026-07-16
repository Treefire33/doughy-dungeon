extends Node

var game_speed: int = 1;
var audio_volume: float = 1;
var music_volume: float = 1:
    get: return music_volume;
    set (value):
        music_volume = value;
        if (Audio.music_player != null):
            Audio.music_player.volume_linear = value;
var toast_size: int = 12;
var helpers_enabled: bool = true;
var language: String = "automatic":
    get: return language;
    set (value):
        if (value.to_lower().contains("automatic")):
            language = OS.get_locale();
        else:
            language = value;
        TranslationServer.set_locale(language);

var fullscreen: bool = false:
    get: return fullscreen;
    set (value):
        fullscreen = value;
        if (fullscreen):
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);

var settings_menu: SettingsMenu = load("res://Scenes/Menus/SettingsMenu/settings_menu.tscn").instantiate();

func load_settings_menu(node: Node):
    if (!is_instance_valid(settings_menu)): settings_menu = load("res://Scenes/Menus/SettingsMenu/settings_menu.tscn").instantiate();
    settings_menu.visible = true;
    if (settings_menu.get_parent() == node): return;
    node.add_child(settings_menu);
    
func load_settings():
    var settings = ConfigFile.new()
    var result = settings.load("user://settings.cfg")
    if (result != OK):
        return;
    
    for section in settings.get_sections():
        if (section == "game_settings"):
            game_speed = settings.get_value(section, "game_speed", 1);
            audio_volume = settings.get_value(section, "audio_volume", 1);
            music_volume = settings.get_value(section, "music_volume", 1);
            toast_size = settings.get_value(section, "toast_size", 12);
            helpers_enabled = settings.get_value(section, "helpers_enabled", false);
            language = settings.get_value(section, "language", "automatic");
            fullscreen = settings.get_value(section, "fullscreen", false);
        elif (section == "keybinds"):
            for action in Keybinds.bindable_actions:
                var event = settings.get_value("keybinds", action, InputEventAction.new());
                Keybinds.remap_action(action, event);
    
func save_settings():
    var settings = ConfigFile.new()
    settings.set_value("game_settings", "game_speed", game_speed);
    settings.set_value("game_settings", "audio_volume", audio_volume);
    settings.set_value("game_settings", "music_volume", music_volume);
    settings.set_value("game_settings", "toast_size", toast_size);
    settings.set_value("game_settings", "helpers_enabled", helpers_enabled);
    settings.set_value("game_settings", "language", language);
    settings.set_value("game_settings", "fullscreen", fullscreen);
    
    for action in Keybinds.bindable_actions:
        settings.set_value("keybinds", action, Keybinds.get_action_bind(action));
    
    settings.save("user://settings.cfg");
    
func _ready() -> void:
    load_settings();
    
func _exit_tree() -> void:
    save_settings();
