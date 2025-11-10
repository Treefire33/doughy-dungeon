extends Node
class_name PlayerGlobals

var current_dungeon: DungeonData;
var current_scene: int = 0;

var abyss_fragments_collected: int = 0;

# Flags:
var met_vendor: bool = false;
var completed_dungeons: Array[bool] = [ 
	false, false, false, false, false, # Main Dungeons (Alcove, Oceanic, Doughy, Magmatic, Abyssal)
	false, false, # Side Dungeons (Cliff-Side, True Abyss)
];
var has_abyss_heart: bool = false;

# Save Data:
func save_player():
	var save_data = ConfigFile.new();
	save_data.set_value("flags", "met_vendor", met_vendor);
	save_data.set_value("flags", "completed_dungeons", completed_dungeons);
	save_data.set_value("flags", "has_abyss_heart", has_abyss_heart);

	save_data.save("user://player_save.sav");

func load_player():
	var save_data = ConfigFile.new()
	var result = save_data.load("user://player_save.sav");
	if (result != OK):
		return;
	
	for section in save_data.get_sections():
		if (section == "flags"):
			met_vendor = save_data.get_value(section, "met_vendor", false);
			completed_dungeons = save_data.get_value(section, "completed_dungeons", [ false, false, false, false, false, false, false ]);
			has_abyss_heart = save_data.get_value(section, "has_abyss_heart", false);

func _ready() -> void:
	load_player();

func _exit_tree() -> void:
	save_player();

