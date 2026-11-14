extends Node2D

@export var exit_button: Button;

func _ready() -> void:
    exit_button.pressed.connect(func():
        Settings.game_paused = false;
        SuperLoader.switch_scene("res://Scenes/title_screen.tscn");
    );
    GlobalPlayer.increment_flag(&"iEvilScore");
    Audio.play_music(Audio.evilgrounds_music);
