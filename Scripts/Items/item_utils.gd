extends Node

func _get_loaded_items_directory(path: String) -> Dictionary[StringName, ItemData]:
    var items_directory = ResourceLoader.list_directory(path);
    var final: Dictionary[StringName, ItemData] = {};
    for file in items_directory:
        if (file.ends_with("/")): 
            final.merge(_get_loaded_items_directory(path+file)); 
            continue;
        if (!file.ends_with(".tres")): continue;
        final[file.trim_suffix(".tres")] = ResourceLoader.load(path + file);
    return final;

# wow I love Godot's type system so so so sos so much!
func _get_loaded_rpgitems_directory(path: String) -> Dictionary[StringName, RPGItemData]:
    var items_directory = ResourceLoader.list_directory(path);
    var final: Dictionary[StringName, RPGItemData] = {};
    for file in items_directory:
        if (file.ends_with("/")): 
            final.merge(_get_loaded_rpgitems_directory(path+file)); 
            continue;
        if (!file.ends_with(".tres")): continue;
        final[file.trim_suffix(".tres")] = ResourceLoader.load(path + file);
    return final;

var item_database: Dictionary[StringName, ItemData] = self._get_loaded_items_directory("res://Items/");
var _loaded_item_functions: Dictionary[StringName, Variant] = {};

func _database_where(database: Dictionary, conditions: Dictionary[StringName, Variant]) -> Array[StringName]:
    var final: Array[StringName] = database.keys();
    for condition in conditions.keys():
        var eval: Variant = conditions[condition];

        var to_remove: Array[StringName] = [];
        for item_name in final:
            var prop = database[item_name].get(condition);
            if (prop == null): continue;

            if (typeof(eval) == typeof(prop)):
                if (eval != prop): to_remove.append(item_name); continue;
            elif(typeof(eval) == TYPE_CALLABLE):
                if (!eval.call(prop)): to_remove.append(item_name); continue;
            else:
                push_error("Eval case for property: %s either does not match the property's type or is not a method." % condition);
                continue;
        
        for entry in to_remove:
            final.erase(entry);
    
    return final;

var item_rarity_probabilities: Dictionary[Enum.ItemRarity, float] = {
    Enum.ItemRarity.None: 0,
    Enum.ItemRarity.NoneTwo: 0,
    Enum.ItemRarity.Common: 0.60,
    Enum.ItemRarity.Uncommon: 0.23,
    Enum.ItemRarity.Rare: 0.07,
    Enum.ItemRarity.Abyssal: 0.001,
    Enum.ItemRarity.Curio: 0.01,
};
var item_rarity_colours: Dictionary[Enum.ItemRarity, Color] = {
    Enum.ItemRarity.None: Color.TRANSPARENT,
    Enum.ItemRarity.NoneTwo: Color.TRANSPARENT,
    Enum.ItemRarity.Common: Color.from_rgba8(127, 127, 127),
    Enum.ItemRarity.Uncommon: Color.from_rgba8(0, 200, 50),
    Enum.ItemRarity.Rare: Color.from_string("#00bad0", Color.RED),
    Enum.ItemRarity.Abyssal: Color.from_string("#540079", Color.RED),
    Enum.ItemRarity.Curio: Color.from_string("#cb7cff", Color.RED),
};
func get_random_item(dungeon_data: DungeonData, painful: bool = false) -> String:
    var rng = RandomNumberGenerator.new();
    var random_rarity: Enum.ItemRarity = item_rarity_probabilities.keys()[rng.rand_weighted(item_rarity_probabilities.values())];

    var item_pool = _database_where(item_database, {
        &"dungeon_pool": func(v: Array): return v.has(Enum.Dungeon.All) || v.has(dungeon_data.id),
        &"dungeon_exclude_pool": func(v: Array): return !v.has(dungeon_data.id),
        &"rarity": random_rarity,
        &"painful": painful
    });
    var keys = [];
    var weights = [];
    for item in item_pool:
        var item_data: ItemData = get_item_data(item);
        keys.append(item);
        weights.append(item_data.weight);
    
    if (keys.size() <= 0):
        return get_random_item(dungeon_data, painful);

    return keys[rng.rand_weighted(weights)];

func get_item_name(item_data: ItemData) -> String:
    return item_database.find_key(item_data);

func get_item_data(item_name: String) -> ItemData:
    return item_database[item_name];

func show_activation_toast(item: String):
    ToastParty.show({
        "text": "%s activated!" % item,
        "text_size": Settings.toast_size,
        "bgcolor": Color(0, 0, 0, 1),
        "color": Color(1, 1, 1, 1),
        "gravity": "bottom",
        "direction": "right",
    });
    Audio.play_audio(Audio.item_activated);

func show_custom_toast(message: String):
    ToastParty.show({
        "text": message,
        "text_size": Settings.toast_size,
        "bgcolor": Color(0, 0, 0, 1),
        "color": Color(1, 1, 1, 1),
        "gravity": "bottom",
        "direction": "right",
    });
    Audio.play_audio(Audio.item_activated);

func get_tooltip_text(item_data: ItemData, shop_item: bool, override = false, override_price: int = 0) -> Array[String]:
    var res: Array[String] = [
        item_data.name, "(%s)" % item_data.flavour_text
    ];
    if (shop_item):
        if (!item_data.painful):
            res.append("Price: %d coins" % (override_price if override else item_data.price));
        else:
            res.append("Reward: %d coins" % -(override_price if override else item_data.price));
    else:
        res.append("");
    res.append(item_data.description);
    return res;

func get_item_animation_name(item_data: ItemData) -> StringName:
    return item_data.sprite if !item_data.sprite.is_empty() else StringName(item_data.resource_path.get_file().trim_suffix(".tres"));

func decision_is_attack(decision: Enum.Decision) -> bool:
    return decision == Enum.Decision.Attack || decision == Enum.Decision.AttackHeavy;

func decision_is_spell(decision: Enum.Decision) -> bool:
    return decision == Enum.Decision.Spell;

func _execute_item_func(item_data: ItemData, function_name: StringName, args: ItemFunction.ItemFunctionArgs) -> void:
    var script_instance: ItemFunction = _loaded_item_functions.get(item_data.name, item_data.function.new());
    if (!_loaded_item_functions.has(item_data.name)): _loaded_item_functions[item_data.name] = script_instance;
    var _instance_resolution: Variant = script_instance.call(function_name, args);

func activate_items(player: Player, function: String, args: ItemFunction.ItemFunctionArgs) -> void:
    for item in player.items:
        var count: int = player.items[item];
        var data: ItemData = get_item_data(item);
        if (data == null):
            push_error("Item %s failed to retrieve its item data." % item);
            continue;
        if (data.function == null): continue;

        args.room_manager = RoomManager.instance;
        args.stack_count = count;
        if (data.unique_stacking):
            _execute_item_func(data, function, args);
        else:
            for i in range(count):
                _execute_item_func(data, function, args);
