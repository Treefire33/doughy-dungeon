extends Control

@onready var start_button = $MenuButtons/Start;
@onready var settings_button = $MenuButtons/Options;
@onready var quit_button = $MenuButtons/Quit;

func _play_music():
    Audio.play_music(Audio.overworld_music);

func _ready():
    if (GlobalPlayer.grounds_for_evil >= 10):
        GlobalPlayer.grounds_for_evil = 0;
        Audio.play_music(Audio.evilgrounds_music);
        get_tree().change_scene_to_file.call_deferred("res://Scenes/grounds_for_evil.tscn");
        return;
    start_button.grab_focus();
    start_button.pressed.connect(func():
        Audio.play_audio(Audio.purchase_sfx, 0.07);
        get_tree().change_scene_to_file("res://Scenes/rpg_test.tscn");
        GlobalPlayer.grounds_for_evil = 0;
        GlobalPlayer._game_started = true;
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
            if (!GlobalPlayer._game_started): GlobalPlayer.grounds_for_evil += 1;
        );
    _play_music();
