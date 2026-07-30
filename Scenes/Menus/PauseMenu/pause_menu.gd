extends Control
class_name PauseMenu

@export var resume_button: Button;
@export var restart_button: Button;
@export var options_button: Button;
@export var return_button: Button;
@export var exit_button: Button;

func load_pause_menu(parent: Control):
    resume_button.pressed.connect(func():
        Settings.game_paused = false;
        if (is_instance_valid(Settings._settings_menu)):
            Settings._settings_menu.queue_free();
        queue_free();
    );
    restart_button.pressed.connect(func():
        Settings.game_paused = false;
        SuperLoader.switch_scene("res://Scenes/game.tscn");
    );
    options_button.pressed.connect(func():
        Settings.load_settings_menu(parent);
    );
    return_button.pressed.connect(func():
        Settings.game_paused = false;
        SuperLoader.switch_scene("res://Scenes/rpg_test.tscn");
    );
    exit_button.pressed.connect(func():
        Settings.game_paused = false;
        SuperLoader.switch_scene("res://Scenes/title_screen.tscn");
    );

func _process(delta: float) -> void:
    if (!self.visible || !Settings.game_paused): return;
    if (Input.is_action_just_pressed("Pause")):
        resume_button.pressed.emit();
