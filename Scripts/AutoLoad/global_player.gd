extends Node

var current_dungeon: DungeonData;
var last_unlocked_item: RPGItemData;

# Save Stuff
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

var player_flags: Dictionary[StringName, int] = {
    # Story Flags
    # Tutorial Flags
    &"bDungeonTutorial": 0,
    # Vendor Flags
    &"bVendorMet": 0,
    # Lana Flags
    &"bLanaMet": 0,

    # True Ending Flags
    &"iAbyssFragmentCount": 0,
    &"bAbyssHeartObtained": 0,

    # Erroneous Entity Flags
    &"iEvilScore": 0, # Counts how many times you've visited Evilgrounds
    &"bErrorUnlocked": 0, # Flag for if the player has seen the error unlock dialogue
    &"bErrorWorld": 0, # Flag for if the player has been to the error world

    # Easter Egg Flags
    &"bMetAfternoon": 0 # Flag for if you met Afternoon and their sister Evening.
};

var coins: int = 0;

func set_flag(flag_name: StringName, value: int):
    player_flags[flag_name] = value;

func set_bool_flag(flag_name: StringName, value: bool):
    set_flag(flag_name, int(value));

func get_flag(flag_name: StringName) -> int:
    return player_flags[flag_name];

func get_bool_flag(flag_name: StringName) -> bool:
    return get_flag(flag_name) > 0;

func increment_flag(flag_name: StringName, amount: int = 1):
    set_flag(flag_name, get_flag(flag_name) + amount);

# RPG Items
var rpg_item_database: Dictionary[StringName, RPGItemData] = ItemUtils._get_loaded_rpgitems_directory("res://RPGItems/");
var unlocked_items: Array[StringName] = [
    &"TatteredCloak", &"WoodSword",
    &"Defend", &"Retype", &"Attack"
];
var cloak: RPGItemData = preload("res://RPGItems/Cloaks/TatteredCloak.tres");
var sword: RPGItemData = preload("res://RPGItems/Swords/WoodSword.tres");
var spells: Array[RPGItemData] = [
    load("res://RPGItems/Spells/Defend.tres"),
    load("res://RPGItems/Spells/Retype.tres"),
    load("res://RPGItems/Spells/Attack.tres")
];

func get_unlocked_items_of_type(item_type: Enum.RPGItemType) -> Array[StringName]:
    return ItemUtils._database_where(rpg_item_database, {
        &"item_type": item_type,
        &"resource_path": func(v: String): return unlocked_items.has(v.get_file().trim_suffix(".tres"));
    });

func get_upgrade_stat(stat_name: StringName) -> int:
    var sum = cloak.get(stat_name) + sword.get(stat_name);
    for spell in spells:
        sum += spell.get(stat_name)
    return sum;

func add_rpg_item(item_name: StringName):
    if (unlocked_items.has(item_name)): return;
    if (!rpg_item_database.has(item_name)): return;
    unlocked_items.append(item_name);
    last_unlocked_item = rpg_item_database[item_name];

func equip_item(item_type: Enum.RPGItemType, item_name: StringName):
    var item = rpg_item_database[item_name];
    if (item_type == Enum.RPGItemType.Cloak):
        cloak = item;
    elif (item_type == Enum.RPGItemType.Sword):
        sword = item;
    elif (item_type == Enum.RPGItemType.Spell):
        spells[item_type - Enum.RPGItemType.Spell] = item;

# wow I sure hope no one is able to modify their saves
# using this conviently exposed AES-256 encryption key!
var encryption_pass: String = "cc43f15359acc9ae246eab99fae2f0a1c020a6c2a6e832610b59612e7d262559";

# Save Data:
func save_player():
    var save_data = ConfigFile.new();
    save_data.set_value("flags", "completed_dungeons", completed_dungeons);
    save_data.set_value("flags", "player_flags", player_flags);
    save_data.set_value("flags", "coins", coins);

    save_data.set_value("rpg_items", "unlocked_items", unlocked_items);
    save_data.set_value("rpg_items", "cloak", cloak.resource_path);
    save_data.set_value("rpg_items", "sword", sword.resource_path);
    save_data.set_value("rpg_items", "num_spells", spells.size());
    for i in range(spells.size()):
        save_data.set_value("rpg_items", "spell%s" % i, spells[i].resource_path);
    
    save_data.set_value("version_info", "version", ProjectSettings.get_setting("application/config/version", "0.0.0"));

    if (OS.is_debug_build()):
        save_data.save("user://player_save_debug.sav");
    else:
        save_data.save_encrypted_pass("user://player_save.sav", encryption_pass);

func load_player():
    var save_data = ConfigFile.new();
    var result = save_data.load("user://player_save_debug.sav") if OS.is_debug_build() else save_data.load_encrypted_pass("user://player_save.sav", encryption_pass);
    if (result != OK):
        return;
    
    for section in save_data.get_sections():
        if (section == "flags"):
            var saved_dungeons = save_data.get_value(section, "completed_dungeons", completed_dungeons);
            for dungeon in saved_dungeons:
                completed_dungeons[dungeon] = saved_dungeons[dungeon];

            var saved_flags = save_data.get_value(section, "player_flags", player_flags);
            for flag in saved_flags:
                player_flags[flag] = saved_flags[flag];
            
            coins = save_data.get_value(section, "coins", coins);
        if (section == "rpg_items"):
            unlocked_items = save_data.get_value(section, "unlocked_items", unlocked_items);
            cloak = rpg_item_database.get(save_data.get_value(section, "cloak", &"TatteredCloak"), rpg_item_database[&"TatteredCloak"]);
            sword = rpg_item_database.get(save_data.get_value(section, "sword", &"WoodSword"), rpg_item_database[&"WoodSword"]);
            var num_spells = save_data.get_value(section, "num_spells", 3);
            var default_spells = [
                &"Defend", &"Retype", &"Attack"
            ];
            for i in range(num_spells):
                spells[i] = rpg_item_database.get(save_data.get_value(section, "spell%s" % i, default_spells[i]), rpg_item_database[default_spells[i]]) as SpellItemData;

func _ready() -> void:
    load_player();

func _notification(what: int) -> void:
    match what:
        NOTIFICATION_WM_CLOSE_REQUEST:
            save_player();

        NOTIFICATION_APPLICATION_PAUSED:
            save_player();
