extends Node

var item_database: Dictionary[StringName, ItemData] = (
    func():
        var items_directory = ResourceLoader.list_directory("res://Items/");
        var final: Dictionary[StringName, ItemData] = {};
        for file in items_directory:
            if (!file.ends_with(".tres")): continue;
            final[file.trim_suffix(".tres")] = ResourceLoader.load("res://Items/%s" % file);
        return final;
).call();

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

func get_random_item(dungeon_data: DungeonData, painful: bool = false) -> String:
    var rng = RandomNumberGenerator.new();
    
    var item_pool = _database_where(item_database, {
        &"dungeon_pool": func(v: Array): return v.has(Enum.Dungeon.All) || v.has(dungeon_data.id),
        &"dungeon_exclude_pool": func(v: Array): return !v.has(dungeon_data.id),
        &"painful": painful
    });
    var keys = [];
    var weights = [];
    for item in item_pool:
        var item_data: ItemData = get_item_data(item);
        keys.append(item);
        weights.append(item_data.weight);
    
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

const tt_item_name_template = "%s\n[s=8](%s)"; 
func get_tooltip_text(item_data: ItemData, shop_item: bool, override = false, override_price: int = 0) -> String:
    var res: String = "";
    res = tt_item_name_template % [item_data.name, item_data.flavour_text];
    if (shop_item):
        if (!item_data.painful):
            res += "\n\n" + "Price: %d coins" % (override_price if override else item_data.price);
        else:
            res += "\n\n" + "Reward: %d coins" % -(override_price if override else item_data.price);
    for line in item_data.description.split('\n'):
        res += "\n[s=8]" + line;
    return res;

func decision_is_attack(decision: Enum.Decision) -> bool:
    return decision == Enum.Decision.Attack || decision == Enum.Decision.AttackHeavy || decision == Enum.Decision.SpellAttack;

func decision_is_spell(decision: Enum.Decision) -> bool:
    return decision == Enum.Decision.SpellDefend || decision == Enum.Decision.SpellRetype || decision == Enum.Decision.SpellAttack;

func _execute_item_func(function: Script, func_name: String, args: Array) -> void:
    var inst: Resource = function.new();
    var _inst_res = inst.callv(func_name, args);

func activate_items(player: Player, function: String, ...args: Array) -> void:
    for item in player.items:
        var count: int = player.items[item];
        var data: ItemData = get_item_data(item);
        if (data == null):
            push_error("Item %s failed to retrieve its item data." % item);
            continue;
        if (data.function == null): continue;
        if (data.unique_stacking):
            _execute_item_func(data.function, function, args + [RoomManager.instance, count]);
        else:
            for i in range(count):
                _execute_item_func(data.function, function, args + [RoomManager.instance, count]);
