extends Node

var defend_sfx: AudioStream = preload("res://Audio/Defend.wav");
var die_sfx: AudioStream = preload("res://Audio/Die.wav");
var hit_sfx: AudioStream = preload("res://Audio/Hit.wav");
var purchase_sfx: AudioStream = preload("res://Audio/Purchase.wav");
var item_activated: AudioStream = preload("res://Audio/ItemUsed.wav");

# var melancholic_field: AudioStream = preload("res://Audio/Music/MelancholicField.wav");
# var idle_battle: AudioStream = preload("res://Audio/Music/IdleBattle.wav");
# var quickening_pace: AudioStream = preload("res://Audio/Music/QuickeningPace.wav");

var overworld_music: AudioStreamInteractive = preload("res://Audio/Music/overworld_music.tres");
var dungeon_music: AudioStreamInteractive = preload("res://Audio/Music/dungeon_music.tres");
var music_player: AudioStreamPlayer;
var current_interactive_stream: AudioStreamPlaybackInteractive;

enum DungeonMusic {
	IdleBattle,
	QuickeningPace,
	BossFightA
}

enum OverworldMusic {
	MelancholicField
}

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

func play_music(clip: AudioStreamInteractive, position: float = 0):
	music_player.volume_linear = Settings.music_volume;
	music_player.stream = clip;
	music_player.play(position);
	current_interactive_stream = music_player.get_stream_playback() as AudioStreamPlaybackInteractive;

func change_music(clip: int):
	if (current_interactive_stream == null):
		return
	current_interactive_stream.switch_to_clip(clip);

func stop_music():
	music_player.stop();

func _ready() -> void:
	music_player = AudioStreamPlayer.new();
	get_node("/root/").add_child.call_deferred(music_player);
