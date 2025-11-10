extends Control
class_name SettingsMenu

@onready var game_speed: SpinBox = $SettingsContainer/GameSpeed/Value;
@onready var audio_volume: Slider = $SettingsContainer/AudioVolume/Value;
@onready var music_volume: Slider = $SettingsContainer/MusicVolume/Value;
@onready var notif_size: SpinBox = $SettingsContainer/NotificationSize/Value;
@onready var keybinds_button: Button = $Keybinds;
@onready var settings_done: Button = $Done;

func _ready():
	game_speed.grab_focus();
	game_speed.value = Settings.game_speed;
	game_speed.value_changed.connect(func(value: float):
		Settings.game_speed = value;
	)
	
	audio_volume.value = Settings.audio_volume;
	audio_volume.value_changed.connect(func(value: float):
		Settings.audio_volume = value;
	)

	music_volume.value = Settings.music_volume;
	music_volume.value_changed.connect(func(value: float):
		Settings.music_volume = value;
	)
	
	notif_size.value = Settings.toast_size;
	notif_size.value_changed.connect(func(value: float):
		Settings.toast_size = value;
	)
	
	keybinds_button.pressed.connect(func():
		Keybinds.load_keybinds_menu(self.get_parent());
	)
	
	settings_done.pressed.connect(func():
		self.queue_free();
	)
