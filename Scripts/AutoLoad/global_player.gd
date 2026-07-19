extends Node

var current_dungeon: DungeonData;
var current_scene: int = 0;

# Save Stuff
var met_vendor: bool = false;
var completed_dungeons: Array[bool] = [ 
	false, false, false, false, false, # Main Dungeons (Alcove, Oceanic, Doughy, Magmatic, Abyssal)
	false, false, # Side Dungeons (Cliff-Side, True Abyss)
];
var abyss_fragment_count: int = 0;
var has_abyss_heart: bool = false;
var grounds_for_evil: int = 0; # Secret activates when counter hits 10, resets when "Start" is chosen.
var _game_started: bool = false; # Checks if the game has started, prevents evilgrounds from happening from regular play.

# Upgrades
var current_cloak: Enum.Upgrades.Cloaks = Enum.Upgrades.Cloaks.Tattered;
var current_sword: Enum.Upgrades.Swords = Enum.Upgrades.Swords.Wood;
var current_shield: Enum.Upgrades.Shields = Enum.Upgrades.Shields.Standard;

# wow I sure hope no one is able to modify their saves
# using this conviently exposed AES-256 encryption key!
var encryption_pass: String = "cc43f15359acc9ae246eab99fae2f0a1c020a6c2a6e832610b59612e7d262559";

# Save Data:
func save_player():
	var save_data = ConfigFile.new();
	save_data.set_value("flags", "met_vendor", met_vendor);
	save_data.set_value("flags", "completed_dungeons", completed_dungeons);
	save_data.set_value("flags", "abyss_fragment_count", abyss_fragment_count);
	save_data.set_value("flags", "has_abyss_heart", has_abyss_heart);
	save_data.set_value("flags", "grounds_for_evil", grounds_for_evil);

	if (OS.is_debug_build()):
		save_data.save("user://player_save.sav");
	else:
		save_data.save_encrypted_pass("user://player_save.sav", encryption_pass);

func load_player():
	var save_data = ConfigFile.new();
	var result = save_data.load("user://player_save.sav") if OS.is_debug_build() else save_data.load_encrypted_pass("user://player_save.sav", encryption_pass);
	if (result != OK):
		return;
	
	for section in save_data.get_sections():
		if (section == "flags"):
			met_vendor = save_data.get_value(section, "met_vendor", false);
			completed_dungeons = save_data.get_value(section, "completed_dungeons", [ false, false, false, false, false, false, false ]);
			abyss_fragment_count = save_data.get_value(section, "abyss_fragment_count", 0);
			has_abyss_heart = save_data.get_value(section, "has_abyss_heart", false);
			grounds_for_evil = save_data.get_value(section, "grounds_for_evil", 0);

func _ready() -> void:
	load_player();

func _exit_tree() -> void:
	save_player();
