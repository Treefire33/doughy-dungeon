extends Node

var defend_sfx: AudioStream = preload("res://Audio/Defend.wav");
var die_sfx: AudioStream = preload("res://Audio/Die.wav");
var hit_sfx: AudioStream = preload("res://Audio/Hit.wav");
var purchase_sfx: AudioStream = preload("res://Audio/Purchase.wav");
var item_activated: AudioStream = preload("res://Audio/ItemUsed.wav");

func play_audio(clip: AudioStream, position: float = 0):
	var player = AudioStreamPlayer2D.new();
	player.position = Vector2(400, 225)
	get_node("/root/").add_child(player);
	player.volume_linear = Settings.audio_volume;
	player.stream = clip;
	player.play(position);
	player.finished.connect(func():
		player.queue_free();
	)
