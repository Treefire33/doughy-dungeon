extends Control

@onready var start_button = $MenuButtons/Start;
@onready var settings_button = $MenuButtons/Options;
@onready var quit_button = $MenuButtons/Quit;

func _ready():
    start_button.grab_focus();
    start_button.pressed.connect(func():
        Audio.play_audio(Audio.purchase_sfx, 0.07);
        SuperLoader.super_loader.switch_scene("res://Scenes/rpg_test.tscn");
    );
    settings_button.pressed.connect(func():
        Settings.load_settings_menu(self);
    );
    var platform = OS.get_name();
    if (platform == "Web" || platform == "iOS" || platform == "Android"):
        quit_button.queue_free();
    else:
        quit_button.pressed.connect(func():
            get_tree().quit(0);
        );
    Audio.play_music(Audio.overworld_music);
