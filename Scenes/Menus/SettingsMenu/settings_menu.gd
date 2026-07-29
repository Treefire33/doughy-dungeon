extends Control
class_name SettingsMenu

@export var game_speed: SpinBox;
@export var notif_size: SpinBox;
@export var fullscreen_button: MidnightCheckbox;
@export var horiz_panel: MidnightCheckbox;
@export var audio_volume: Slider;
@export var music_volume: Slider;
@export var language_dropdown: OptionButton;
@export var keybind_helpers: MidnightCheckbox;
@export var helper_aligment: OptionButton;
@export var keybinds_button: Button;
@export var settings_done: Button;

@export var game_borders: MidnightCheckbox;
@export var game_font: OptionButton;

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

    helper_aligment.select(Settings.helper_alignment);
    helper_aligment.item_selected.connect(func(idx):
        Settings.helper_alignment = idx;
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

    horiz_panel.set_pressed_no_signal(Settings.horiz_decision_panel);
    horiz_panel.toggled.connect(func(toggled: bool):
        Settings.horiz_decision_panel = toggled;
    );

    game_borders.set_pressed_no_signal(Settings.game_borders);
    game_borders.toggled.connect(func(toggled: bool):
        Settings.game_borders = toggled;
    );

    game_font.select(Settings.game_font);
    game_font.item_selected.connect(func(idx):
        Settings.game_font = idx;
    );
    
    settings_done.grab_focus();
    settings_done.pressed.connect(func():
        queue_free();
    );

    var platform = OS.get_name();
    if (platform == "Web" || platform == "iOS" || platform == "Android"):
        fullscreen_button.visible = false;
