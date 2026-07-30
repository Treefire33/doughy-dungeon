extends Node2D

func _ready() -> void:
    GlobalPlayer.increment_flag(&"iEvilScore");
    Audio.play_music(Audio.evilgrounds_music);
