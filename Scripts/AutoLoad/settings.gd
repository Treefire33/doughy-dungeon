extends Node

signal settings_changed();

var game_speed: float = 1;
var audio_volume: float = 1;
var music_volume: float = 1:
    get: return music_volume;
    set (value):
        music_volume = value;
        if (Audio.music_player != null):
            Audio.music_player.volume_linear = value;
var toast_size: int = 12;
var helpers_enabled: bool = true;
var helper_alignment: int = 0:
    set (value):
        helper_alignment = value;
        AccessibilityHelper.update_binds();
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

var horiz_decision_panel: bool = false:
    get: return horiz_decision_panel;
    set (value):
        horiz_decision_panel = value;
        if (RoomManager.instance):
            RoomManager.instance.player_ui.decision_panel.horizify_panel();

var mobile_control_override: bool = false:
    get: return mobile_control_override;
    set (value):
        mobile_control_override = value;
        self.settings_changed.emit();

var game_borders: bool = true;

var font_dict = {
    0: preload("res://PressStart.ttf"),
    1: preload("res://m6x11.ttf"),
    2: preload("res://Iansui-Regular.ttf")
};
var game_font: int = 0:
    get: return game_font;
    set (value):
        game_font = value;
        SuperLoader.change_font(font_dict[game_font]);

var _settings_menu: SettingsMenu = load("res://Scenes/Menus/SettingsMenu/settings_menu.tscn").instantiate();
func load_settings_menu(node: Node):
    if (!is_instance_valid(_settings_menu)): _settings_menu = load("res://Scenes/Menus/SettingsMenu/settings_menu.tscn").instantiate();
    _settings_menu.visible = true;
    if (_settings_menu.get_parent() == node): return;
    node.add_child(_settings_menu);

var _pause_menu: PauseMenu = load("res://Scenes/Menus/PauseMenu/pause_menu.tscn").instantiate();
var game_paused: bool = false:
    get: return game_paused;
    set (value):
        game_paused = value;
        get_tree().paused = game_paused;
func pause_game(node: Control):
    if (game_paused): return;
    if (!is_instance_valid(_pause_menu)): _pause_menu = load("res://Scenes/Menus/PauseMenu/pause_menu.tscn").instantiate();
    game_paused = true;
    _pause_menu.visible = true;
    if (_pause_menu.get_parent() == node): return;
    _pause_menu.load_pause_menu(node);
    node.add_child(_pause_menu);
    
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
            helper_alignment = settings.get_value(section, "helper_alignment", 0);
            language = settings.get_value(section, "language", "automatic");
            fullscreen = settings.get_value(section, "fullscreen", false);
            horiz_decision_panel = settings.get_value(section, "horiz_decision_panel", false);
            game_borders = settings.get_value(section, "game_borders", false);
            game_font = settings.get_value(section, "game_font", 0);
            mobile_control_override = settings.get_value(section, "mobile_control_override", false);
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
    settings.set_value("game_settings", "helper_alignment", helper_alignment);
    settings.set_value("game_settings", "language", language);
    settings.set_value("game_settings", "fullscreen", fullscreen);
    settings.set_value("game_settings", "horiz_decision_panel", horiz_decision_panel);
    settings.set_value("game_settings", "game_borders", game_borders);
    settings.set_value("game_settings", "game_font", game_font);
    settings.set_value("game_settings", "mobile_control_override", mobile_control_override);
    
    for action in Keybinds.bindable_actions:
        settings.set_value("keybinds", action, Keybinds.get_action_bind(action));
    
    settings.save("user://settings.cfg");
    
func _ready() -> void:
    load_settings();
    
func _exit_tree() -> void:
    save_settings();
