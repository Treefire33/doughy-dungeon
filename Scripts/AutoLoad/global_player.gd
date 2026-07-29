extends Node

var current_dungeon: DungeonData;
var current_scene: StringName = "";

# Save Stuff
var met_vendor: bool = false;
# var completed_dungeons: Array[bool] = [ 
#     false, false, false, false, false, # Main Dungeons (Alcove, Oceanic, Doughy, Magmatic, Abyssal)
#     false, false, # Side Dungeons (Cliff-Side, True Abyss)

# ];
var completed_dungeons: Dictionary[Enum.Dungeon, bool] = {
    Enum.Dungeon.All: false,
    Enum.Dungeon.Alcove: false,
    Enum.Dungeon.Oceanic: false,
    Enum.Dungeon.Doughy: false,
    Enum.Dungeon.Magamatic: false,
    Enum.Dungeon.HavenOne: false,
    Enum.Dungeon.HavenTwo: false,
    Enum.Dungeon.HavenThree: false,
    Enum.Dungeon.Abyssal: false,
    Enum.Dungeon.CliffSide: false,
    Enum.Dungeon.TrueAbyss: false,
    Enum.Dungeon.TrueAlcove: false,
    Enum.Dungeon.ErrorEntity: false
}
var abyss_fragment_count: int = 0;
var has_abyss_heart: bool = false;
var grounds_for_evil: int = 0; # Counts how many times you've visited Evilgrounds
var error_unlocked: bool = false; # Permaflag for if the player has seen the error unlock dialogue

# RPG Items
func _get_loaded_items_directory(path: String) -> Dictionary[StringName, RPGItemData]:
    var items_directory = ResourceLoader.list_directory(path);
    var final: Dictionary[StringName, RPGItemData] = {};
    for file in items_directory:
        if (file.ends_with("/")): 
            final.merge(_get_loaded_items_directory(path+file)); 
            continue;
        final[file.trim_suffix(".tres")] = ResourceLoader.load(path + file);
    return final;

var rpg_item_database: Dictionary[StringName, RPGItemData] = self._get_loaded_items_directory("res://RPGItems/");
var unlocked_items: Array[StringName] = [
    "TatteredCloak", "WoodSword", "StandardSpell"
];
var cloak: RPGItemData = preload("res://RPGItems/Cloaks/TatteredCloak.tres");
var sword: RPGItemData = preload("res://RPGItems/Swords/WoodSword.tres");
var shield_spell: RPGItemData = preload("res://RPGItems/ShieldSpells/StandardSpell.tres");

func get_unlocked_items_of_type(item_type: Enum.RPGItemType) -> Array[StringName]:
    return ItemUtils._database_where(rpg_item_database, {
        &"item_type": item_type,
        &"resource_path": func(v: String): return unlocked_items.has(v.get_file().trim_suffix(".tres"));
    });

func get_upgrade_stat(stat_name: StringName) -> int:
    return cloak.get(stat_name) + sword.get(stat_name) + shield_spell.get(stat_name);

func add_rpg_item(item_name: StringName):
    if (unlocked_items.has(item_name)): return;
    if (!rpg_item_database.has(item_name)): return;
    unlocked_items.append(item_name);

func equip_item(item_type: Enum.RPGItemType, item_name: StringName):
    var item = rpg_item_database[item_name];
    if (item_type == Enum.RPGItemType.Cloak):
        cloak = item;
    elif (item_type == Enum.RPGItemType.Sword):
        sword = item;
    elif (item_type == Enum.RPGItemType.ShieldSpell):
        shield_spell = item;

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
    save_data.set_value("flags", "error_unlocked", error_unlocked);

    save_data.set_value("rpg_items", "unlocked_items", unlocked_items);
    save_data.set_value("rpg_items", "cloak", cloak.resource_path);
    save_data.set_value("rpg_items", "sword", sword.resource_path);
    save_data.set_value("rpg_items", "shield_spell", shield_spell.resource_path);

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
            completed_dungeons = save_data.get_value(section, "completed_dungeons", completed_dungeons);
            abyss_fragment_count = save_data.get_value(section, "abyss_fragment_count", 0);
            has_abyss_heart = save_data.get_value(section, "has_abyss_heart", false);
            grounds_for_evil = save_data.get_value(section, "grounds_for_evil", 0);
            error_unlocked = save_data.get_value(section, "error_unlocked", false);
        if (section == "rpg_items"):
            unlocked_items = save_data.get_value(section, "unlocked_items", unlocked_items);
            cloak = load(save_data.get_value(section, "cloak", "TatteredCloak")) as RPGItemData;
            sword = load(save_data.get_value(section, "sword", "WoodSword")) as RPGItemData;
            shield_spell = load(save_data.get_value(section, "shield_spell", "StandardSpell")) as RPGItemData;

func _ready() -> void:
    load_player();

func _exit_tree() -> void:
    save_player();
