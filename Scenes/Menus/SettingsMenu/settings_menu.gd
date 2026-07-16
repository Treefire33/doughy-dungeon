extends Control
class_name SettingsMenu

@export var game_speed: SpinBox;
@export var notif_size: SpinBox;
@export var fullscreen_button: CheckBox;
@export var audio_volume: Slider;
@export var music_volume: Slider;
@export var language_dropdown: OptionButton;
@export var keybind_helpers: CheckBox;
@export var keybinds_button: Button;
@export var settings_done: Button;

var language_list: Array[StringName] = [];
func _ready():
    game_speed.value = Settings.game_speed;
    game_speed.value_changed.connect(func(value: float):
        Settings.game_speed = value;
    );
    
    audio_volume.value = Settings.audio_volume;
    audio_volume.value_changed.connect(func(value: float):
        Settings.audio_volume = value;
    );

    music_volume.value = Settings.music_volume;
    music_volume.value_changed.connect(func(value: float):
        Settings.music_volume = value;
    );
    
    notif_size.value = Settings.toast_size;
    notif_size.value_changed.connect(func(value: float):
        Settings.toast_size = value;
    );

    keybind_helpers.set_pressed_no_signal(Settings.helpers_enabled);
    keybind_helpers.toggled.connect(func(toggled: bool):
        Settings.helpers_enabled = toggled;
        AccessibilityHelper.update_binds();
    );
    
    keybinds_button.pressed.connect(func():
        Keybinds.load_keybinds_menu(self.get_parent());
    );

    var i: int = 0;
    for language in TranslationServer.get_loaded_locales():
        language_list.insert(i, language);
        language_dropdown.add_item("%s (%s)" % [ TranslationServer.get_language_name(language.split('_')[0]), language ], i);
        if (Settings.language == language): language_dropdown.select(i);
        i += 1;
    language_dropdown.item_selected.connect(func(idx):
        Settings.language = language_list[idx];
    );

    fullscreen_button.set_pressed_no_signal(Settings.fullscreen);
    fullscreen_button.toggled.connect(func(toggled: bool):
        Settings.fullscreen = toggled;
    );
    
    settings_done.grab_focus();
    settings_done.pressed.connect(func():
        self.visible = false;
    );
