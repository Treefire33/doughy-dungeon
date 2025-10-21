extends Panel

@onready var dungeon_name: Label = $Title;
@onready var stats_a: Label = $StatsA;
@onready var stats_b: Label = $StatsB;
@onready var stats_c: Label = $StatsC;
@onready var action_prompt: Label = $StaticPrompt;

func _ready() -> void:
	var a = Keybinds.format_action_string("[[Primary]] to Enter");
	action_prompt.text = a;

func prompt(object: RPGInteractable):
	dungeon_name.text = object.dungeon.name;
	stats_a.text = "room count: %d" % object.dungeon.room_count;
	stats_b.text = "base difficulty: %d" % object.dungeon.minimum_difficulty;
	stats_c.text = "difficulty ramp: %d" % object.dungeon.difficulty_floor_increment;
