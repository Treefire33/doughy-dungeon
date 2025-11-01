extends Control

@onready var start_button = $MenuButtons/Start;
@onready var settings_button = $MenuButtons/Options;

func _ready():
	start_button.grab_focus();
	start_button.pressed.connect(func():
		Audio.play_audio(Audio.purchase_sfx, 0.07);
		get_tree().change_scene_to_file("res://Scenes/rpg_test.tscn")
	);
	settings_button.pressed.connect(func():
		Settings.load_settings_menu(self);
	);
