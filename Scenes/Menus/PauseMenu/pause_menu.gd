extends Control
class_name PauseMenu

@onready var resume_button: Button = $PauseOptions/Resume;
@onready var restart_button: Button = $PauseOptions/Restart;
@onready var options_button: Button = $PauseOptions/Options;
@onready var exit_button: Button = $PauseOptions/Exit;

func load_pause_menu(room_manager: RoomManager):
	resume_button.pressed.connect(func():
		room_manager.paused = false;
		self.queue_free();
	)
	restart_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://Scenes/game.tscn");
	)
	options_button.pressed.connect(func():
		Settings.load_settings_menu(room_manager.player_ui);
	)
	exit_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn");
	)
