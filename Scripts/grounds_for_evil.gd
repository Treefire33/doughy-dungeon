extends Node2D

func _ready() -> void:
    GlobalPlayer.grounds_for_evil += 1;
    Audio.play_music(Audio.evilgrounds_music);
