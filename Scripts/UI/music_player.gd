extends Node2D
class_name MusicPlayer

@export var song_info: RichTextLabel;
@export var pauseplay_button: Button;
@export var forward_button: Button;
@export var backward_button: Button;
@export var skip_forward_button: Button;
@export var skip_backward_button: Button;
@export var song_position: Slider;
@export var pause_button: Button;

# just this way 'til later
var song_dict: Dictionary = {
    &"MelancholicField": {
        &"Name": &"Melancholic Field",
        &"Caption": "Midnight Dungeons' theme.",
        &"Stream": preload("res://Audio/Music/MelancholicField.wav")
    },

    &"IdleBattle": {
        &"Name": &"Idle Battle",
        &"Caption": "Doughy Alcove and Doughy Dungeon idle track.",
        &"Stream": preload("res://Audio/Music/IdleBattle.wav")
    },
    &"QuickeningPace": {
        &"Name": &"Quickening Pace",
        &"Caption": "Doughy Alcove quickening track.",
        &"Stream": preload("res://Audio/Music/QuickeningPace.wav")
    },
    &"BossFightA": {
        &"Name": &"Vs. Yeast Mother",
        &"Caption": "Doughy Alcove boss track.",
        &"Stream": preload("res://Audio/Music/BossFightA.wav")
    },

    &"IdleWaters": {
        &"Name": &"Idle Waters",
        &"Caption": "Oceanic Dungeon idle track.",
        &"Stream": preload("res://Audio/Music/IdleWaters.wav")
    },
    &"RapidWaters": {
        &"Name": &"Rapid Waters",
        &"Caption": "Oceanic Dungeon quickening track.",
        &"Stream": preload("res://Audio/Music/RapidWaters.wav")
    },
    &"BossFightO": {
        &"Name": &"Vs. Sunfish",
        &"Caption": "Oceanic Dungeon boss track.",
        &"Stream": preload("res://Audio/Music/BossFightO.wav")
    },

    &"RisingHeat": {
        &"Name": &"Rising Heat",
        &"Caption": "Doughy Dungeon quickening track.",
        &"Stream": preload("res://Audio/Music/RisingHeat.wav")
    },
    &"BossFightD": {
        &"Name": &"Vs. The Baker",
        &"Caption": "Doughy Dungeon boss track.",
        &"Stream": preload("res://Audio/Music/BossFightD.wav")
    },

    &"evilgrounds": {
        &"Name": &"evilgrounds",
        &"Caption": "Did something you shouldn't have?",
        &"Stream": preload("res://Audio/Music/evilgrounds.wav")
    },
    &"ErrorWorld": {
        &"Name": &"Error World",
        &"Caption": "You never returned.",
        &"Stream": preload("res://Audio/Music/ErrorWorld.wav")
    },
    &"BossFightE": {
        &"Name": &"ERROR_ERRONEOUS_ENTITY",
        &"Caption": "You're in the wrong place, at the right time.",
        &"Stream": preload("res://Audio/Music/BossFightE.wav")
    },
}
var current_song: int;
var changing_song_position: bool;

func play_song(song_name: StringName):
    var song_info_dict = song_dict[song_name];
    song_info.text = "%s\n[font_size=16]%s[/font_size]" % [song_info_dict[&"Name"], song_info_dict[&"Caption"]];
    current_song = song_dict.keys().find(song_name);;
    Audio.play_music_stream(song_info_dict[&"Stream"]);
    song_position.min_value = 0;
    song_position.max_value = Audio.music_player.stream.get_length();
    pauseplay_button.play(&"Pause");

func _ready() -> void:
    pauseplay_button.pressed.connect(func(): 
        Audio.music_player.stream_paused = !Audio.music_player.stream_paused;
        pauseplay_button.play(&"Pause" if !Audio.music_player.stream_paused else &"Play");
    );

    forward_button.pressed.connect(func():
        Audio.music_player.seek(Audio.music_player.get_playback_position() + 10);
    );
    backward_button.pressed.connect(func():
        Audio.music_player.seek(Audio.music_player.get_playback_position() - 10);
    );

    skip_forward_button.pressed.connect(func():
        var next_index = current_song + 1;
        if (next_index >= song_dict.keys().size()):
            next_index = 0;
        play_song(song_dict.keys()[next_index]);
    );
    skip_backward_button.pressed.connect(func():
        var next_index = current_song - 1;
        if (next_index < 0):
            next_index = song_dict.keys().size() - 1;
        play_song(song_dict.keys()[next_index]);
    );

    pause_button.pressed.connect(func():
        SuperLoader.switch_scene("res://Scenes/title_screen.tscn");
    );

    song_position.drag_started.connect(func():
        changing_song_position = true;
    );
    song_position.drag_ended.connect(func(_v):
        changing_song_position = false;
        Audio.music_player.seek(song_position.value);
    );

    Audio.music_player.finished.connect(func():
        Audio.music_player.stream_paused = true;
    );

    if (!Audio.music_player.is_node_ready()):
        await Audio.music_player.ready;
    play_song(&"MelancholicField");

func _process(delta: float) -> void:
    if (!changing_song_position):
        song_position.value = Audio.music_player.get_playback_position();
