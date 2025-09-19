extends Control

@onready var room_count_label: RichTextLabel = $RoomCount;
@onready var try_again: Button = $TryAgain;

func _ready():
	room_count_label.text = "You reached: Room " + str(Settings.room_count);
	try_again.pressed.connect(func():
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	)
