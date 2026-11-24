extends Control

@onready var start_button = $MenuButtons/Start;
@onready var settings_button = $MenuButtons/Options;
@onready var quit_button = $MenuButtons/Quit;

func _ready():
    start_button.grab_focus();
    start_button.pressed.connect(func():
        Audio.play_audio(Audio.purchase_sfx, 0.07);
        RPGManager.move_rooms(&"TEST_SCENE", 0);
    );
    settings_button.pressed.connect(func():
        Settings.load_settings_menu(self);
    );
    var platform = OS.get_name();
    if (platform == "Web"):
        quit_button.queue_free();
    else:
        quit_button.pressed.connect(SuperLoader.quit);
    Audio.play_music(Audio.overworld_music);

func _notification(what: int) -> void:
    match what:
        NOTIFICATION_WM_GO_BACK_REQUEST:
            SuperLoader.quit();
