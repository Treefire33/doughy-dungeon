extends Node

signal settings_changed(setting_name: StringName);

var game_speed: float:
    get: return get_setting_value(&"game_speed");
var audio_volume: float:
    get: return get_setting_value(&"audio_volume");
var music_volume: float = 1:
    get: return get_setting_value(&"music_volume");
var toast_size: int:
    get: return get_setting_value(&"notif_size");
var helpers_enabled: bool:
    get: return get_setting_value(&"helpers_enabled");
var helper_alignment: int:
    get: return get_setting_value(&"helpers_alignment");
var language: String:
    get: return get_setting_value(&"language");
var fullscreen: bool:
    get: return get_setting_value(&"fullscreen");
var horiz_decision_panel: bool:
    get: return get_setting_value(&"horiz_decision_panel");
var mobile_control_override: bool:
    get: return get_setting_value(&"mobile_control_override");
var game_borders: bool:
    get: return get_setting_value(&"game_borders");
var game_font: int:
    get: return get_setting_value(&"game_font");

const font_dict = {
    0: preload("res://PressStart.ttf"),
    1: preload("res://m6x11.ttf"),
    2: preload("res://Iansui-Regular.ttf")
};

var settings_dict: Dictionary[StringName, Dictionary] = {
    # General
    &"game_speed": {
        &"name": &"Game Speed",
        &"category": &"General",
        &"type": TYPE_FLOAT,
        &"type_variant": &"range_spin",
        &"value": 1.0,
        &"min_value": 0.5,
        &"max_value": 10.0,
        &"step": 0.5,

        &"tooltip": (
"""Sets the speed of dungeon gameplay and effects
[font_size=8]Note: this does not affect RPG segements.[/font_size]"""
        )
    },
    &"fullscreen": {
        &"name": &"Fullscreen",
        &"category": &"General",
        &"type": TYPE_BOOL,
        &"value": false,

        &"tooltip": "Toggles fullscreen."
    },
    &"game_borders": {
        &"name": &"Game Borders",
        &"category": &"General",
        &"type": TYPE_BOOL,
        &"value": false,

        &"tooltip": "Toggles the display of a texture in the black borders of the game window when the window is not of a multiple of 800x450px."
    },
    &"keybinds": {
        &"name": &"Keybinds",
        &"category": &"General",
        &"type": TYPE_CALLABLE,
        &"value": Keybinds.load_keybinds_menu,
        &"callable_name": "KEYBINDS",

        &"tooltip": "Opens the keybinds menu."
    },

    # Audio
    &"audio_volume": {
        &"name": &"SFX Volume",
        &"category": &"Audio",
        &"type": TYPE_FLOAT,
        &"type_variant": &"range",
        &"value": 1.0,
        &"min_value": 0,
        &"max_value": 1,
        &"step": 0.01,

        &"tooltip": "Sets the volume of various sound effects."
    },
    &"music_volume": {
        &"name": &"Music Volume",
        &"category": &"Audio",
        &"type": TYPE_FLOAT,
        &"type_variant": &"range",
        &"value": 1.0,
        &"min_value": 0,
        &"max_value": 1.0,
        &"step": 0.01,

        &"tooltip": "Sets the volume of the music."
    },

    # Visual
    &"helpers_enabled": {
        &"name": &"Keybind Helpers Enabled",
        &"category": &"Visual",
        &"type": TYPE_BOOL,
        &"value": true,

        &"tooltip": "Enables the display of notifiers that shows which keybinds correspond to what buttons."
    },
    &"helpers_alignment": {
        &"name": &"Keybind Helper Alignment",
        &"category": &"Visual",
        &"type": TYPE_INT,
        &"type_variant": &"options",
        &"value": 0,
        &"options": [
            [0, "Left"],
            [1, "Center"],
            [2, "Right"]
        ],

        &"tooltip": "Changes the text alignment of the keybind helpers notifiers."
    },
    &"mobile_control_override": {
        &"name": &"Mobile Controls Override",
        &"category": &"Visual",
        &"type": TYPE_BOOL,
        &"value": false,

        &"tooltip": "Forces the display of RPG mobile controls."
    },
    &"notif_size": {
        &"name": &"Notificaton Size",
        &"category": &"Visual",
        &"type": TYPE_INT,
        &"type_variant": &"range_spin",
        &"value": 12,
        &"min_value": 8,
        &"max_value": 32,
        &"step": 1,

        &"tooltip": "Changes the text size of the dungeon notifications."
    },
    &"horiz_decision_panel": {
        &"name": &"Horizontal Decision Panel",
        &"category": &"Visual",
        &"type": TYPE_BOOL,
        &"value": false,

        &"tooltip": "Lays out the dungeon decision options horizontally across the screen. Recommended for mobile users."
    },
    &"game_font": {
        &"name": &"Game Font",
        &"category": &"Visual",
        &"type": TYPE_INT,
        &"type_variant": &"options",
        &"value": 0,
        &"options": [
            [0, "Press Start"],
            [1, "m6x11"],
            [2, "Iansui"]
        ],

        &"tooltip": (
"""Sets the font that the game uses.
[font_size=8]Press Start: The default font the game uses.

m6x11: A smaller pixel font.

Iansui: A more readable, non-pixel font.[/font_size]"""
        )
    },

    # Language
    &"language": {
        &"name": &"Language",
        &"category": &"Language",
        &"type": TYPE_STRING,
        &"type_variant": &"language",
        &"value": OS.get_locale(),

        &"tooltip": "Sets the game's language.\n[font_size=8]Note: Currently only English is available[/font_size]"
    },
};

# Returns the value dict for a setting
func get_setting_dict(setting_name: StringName):
    return settings_dict[setting_name];

func get_setting_value(setting_name: StringName) -> Variant:
    return settings_dict[setting_name].get(&"value");

func set_setting_value(setting_name: StringName, value: Variant):
    var setting: Dictionary = settings_dict.get(setting_name);
    if (!setting): return;
    if (setting.get(&"value") == null || typeof(setting[&"value"]) != typeof(value)):
        print("Failure to change setting: ", setting_name, ", to value: ", value);
        print("\tMissing setting value entry: ", setting.get(&"value") == null);
        print("\tExpected type: ", typeof(setting[&"value"]), ", provided type: ", typeof(value));
        print(setting);
        return;
    setting.set(&"value", value);
    self.settings_changed.emit(setting_name);

func get_settings_save_dict() -> Dictionary:
    var final: Dictionary = {};
    for setting in settings_dict:
        if (get_setting_dict(setting).get("type", TYPE_NIL) == TYPE_CALLABLE):
            continue;
        final.set(setting, get_setting_value(setting));
    return final;

func load_settings_save_dict(save_dict: Dictionary):
    for setting in save_dict:
        if (get_setting_dict(setting).get("type", TYPE_NIL) == TYPE_CALLABLE):
            continue;
        set_setting_value(setting, save_dict[setting]);

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
            load_settings_save_dict(settings.get_value(section, "settings", {}));
        elif (section == "keybinds"):
            for action in Keybinds.bindable_actions:
                var event = settings.get_value("keybinds", action, InputEventAction.new());
                Keybinds.remap_action(action, event);
    
func save_settings():
    var settings = ConfigFile.new()
    settings.set_value("game_settings", "settings", get_settings_save_dict());
    
    for action in Keybinds.bindable_actions:
        settings.set_value("keybinds", action, Keybinds.get_action_bind(action));
    
    settings.save("user://settings.cfg");
    
func _ready() -> void:
    Settings.settings_changed.connect(func(setting_name: StringName):
        if (setting_name == &"language"):
            TranslationServer.set_locale(language);
        elif (setting_name == &"fullscreen"):
            DisplayServer.window_set_mode(
                DisplayServer.WINDOW_MODE_FULLSCREEN
                if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
            );
        elif (setting_name == &"game_font"):
            SuperLoader.change_font(font_dict[game_font]);
    );
    load_settings();
    
func _exit_tree() -> void:
    save_settings();
